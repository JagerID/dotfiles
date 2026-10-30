;;; morg-pg.el --- generated from config.org -*- lexical-binding: t -*-

(require 'cl-lib)
(require 'subr-x)

;; --- подсказки (corfu) по схемам, таблицам и колонкам PostgreSQL ------------
;; Работает в sql-блоках с :engine postgresql — и в самой заметке, и в буфере
;; редактирования (C-c '). Параметры подключения (:dbhost :dbport :dbuser
;; :database) берутся из заголовков блока / #+PROPERTY / .dir-locals.el —
;; те же, что использует C-c C-c. Пароль — из ~/.pgpass (psql запускается с -w).
;;
;; Данные подгружаются постепенно и асинхронно (Emacs не подвисает):
;;   1. при первой подсказке — один запрос со списком всех таблиц (без колонок);
;;   2. колонки конкретной таблицы — отдельным запросом, когда она понадобилась
;;      (после "таблица." / "алиас." / "схема.таблица.");
;;   3. всё кешируется; M-x morg-pg-refresh сбрасывает кеш подключения.
;; Первая подсказка после запроса может прийти с задержкой: поставьте ещё символ
;; или нажмите M-TAB.
(defvar morg-pg-program "psql")
(defvar morg-pg-system-schemas "'pg_catalog','information_schema'")
(defvar morg-pg-retry-seconds 30
  "Через сколько секунд повторять запрос, который завершился ошибкой.")
(defvar morg-pg--cache (make-hash-table :test #'equal)
  "ключ \"подключение|что\" -> данные (список строк-полей).")
(defvar morg-pg--pending (make-hash-table :test #'equal)
  "ключ -> время последнего запроса.")
(defvar morg-pg--sql-words
  '("where" "on" "join" "left" "right" "inner" "outer" "full" "cross" "natural"
    "group" "order" "limit" "using" "union" "values" "set" "returning" "select"
    "having" "window" "offset" "fetch" "lateral" "as" "and" "or" "from"))

(defun morg-pg--conn (params)
  "Plist подключения из заголовков блока PARAMS."
  (list :host (alist-get :dbhost params)
        :port (alist-get :dbport params)
        :user (alist-get :dbuser params)
        :db   (alist-get :database params)))

(defun morg-pg--conn-key (c)
  (format "%s:%s:%s:%s" (plist-get c :host) (plist-get c :port)
          (plist-get c :user) (plist-get c :db)))

(defun morg-pg--args (c)
  (append (when (plist-get c :host) (list "-h" (format "%s" (plist-get c :host))))
          (when (plist-get c :port) (list "-p" (format "%s" (plist-get c :port))))
          (when (plist-get c :user) (list "-U" (format "%s" (plist-get c :user))))
          (when (plist-get c :db)   (list "-d" (format "%s" (plist-get c :db))))))

(defun morg-pg--quote (s)
  (replace-regexp-in-string "'" "''" s))

(defun morg-pg--fetch (c key sql done)
  "Асинхронно выполнить SQL; по успеху вызвать DONE со списком строк (списков полей)."
  (let ((last (gethash key morg-pg--pending)))
    (unless (and last (< (- (float-time) last) morg-pg-retry-seconds))
      (puthash key (float-time) morg-pg--pending)
      (let ((buf (generate-new-buffer " *morg-pg*" t))
            (process-environment (cons "PGCONNECT_TIMEOUT=3" process-environment)))
        (condition-case err
            (make-process
             :name "morg-pg" :buffer buf :noquery t :connection-type 'pipe
             :command (append (list morg-pg-program "-X" "-w" "-A" "-t" "-F" "\t")
                              (morg-pg--args c) (list "-c" sql))
             :sentinel
             (lambda (p _event)
               (unless (process-live-p p)
                 (if (zerop (process-exit-status p))
                     (funcall done
                              (with-current-buffer buf
                                (mapcar (lambda (l) (split-string l "\t"))
                                        (split-string (buffer-string) "\n" t))))
                   (message "morg-pg: %s"
                            (truncate-string-to-width
                             (string-trim (with-current-buffer buf (buffer-string)))
                             160 nil nil "…")))
                 (kill-buffer buf))))
          (error (kill-buffer buf)
                 (message "morg-pg: не удалось запустить %s (%s)"
                          morg-pg-program (error-message-string err))))))))

(defun morg-pg--cached (c suffix sql)
  "Данные из кеша по SUFFIX; при промахе запустить загрузку и вернуть nil."
  (let* ((key (concat (morg-pg--conn-key c) "|" suffix))
         (hit (gethash key morg-pg--cache 'miss)))
    (if (not (eq hit 'miss))
        hit
      (morg-pg--fetch c key sql (lambda (rows) (puthash key rows morg-pg--cache)))
      nil)))

(defun morg-pg--tables (c)
  "Список (схема таблица вид) всех пользовательских таблиц/вью."
  (morg-pg--cached
   c "tables"
   (format "SELECT n.nspname, c.relname, c.relkind FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind IN ('r','p','v','m','f') AND n.nspname NOT IN (%s) AND n.nspname NOT LIKE 'pg\\_toast%%' ORDER BY 1,2"
           morg-pg-system-schemas)))

(defun morg-pg--columns (c schema table)
  "Список (колонка тип) таблицы SCHEMA.TABLE; грузится при первом обращении."
  (morg-pg--cached
   c (format "col|%s.%s" schema table)
   (format "SELECT a.attname, format_type(a.atttypid, a.atttypmod) FROM pg_attribute a JOIN pg_class c ON c.oid = a.attrelid JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '%s' AND c.relname = '%s' AND a.attnum > 0 AND NOT a.attisdropped ORDER BY a.attnum"
           (morg-pg--quote schema) (morg-pg--quote table))))

(defun morg-pg--resolve (c ref)
  "REF (\"таблица\" или \"схема.таблица\") -> (схема . таблица) либо nil."
  (let ((rows (morg-pg--tables c))
        (ref (replace-regexp-in-string "\"" "" ref)))
    (if (string-match "\\`\\([^.]+\\)\\.\\([^.]+\\)\\'" ref)
        (let ((s (match-string 1 ref)) (tb (match-string 2 ref)))
          (when (cl-find-if (lambda (r) (and (string-equal-ignore-case (car r) s)
                                             (string-equal-ignore-case (cadr r) tb)))
                            rows)
            (cons s tb)))
      (let ((r (or (cl-find-if (lambda (r) (and (string-equal-ignore-case (cadr r) ref)
                                                (equal (car r) "public")))
                               rows)
                   (cl-find-if (lambda (r) (string-equal-ignore-case (cadr r) ref))
                               rows))))
        (and r (cons (car r) (cadr r)))))))

(defun morg-pg--aliases (text)
  "Алиасы из FROM/JOIN в TEXT: ((\"alias\" . \"таблица\") ...), плюс сами таблицы."
  (let (res)
    (with-temp-buffer
      (insert text)
      (goto-char (point-min))
      (let ((case-fold-search t))
        (while (re-search-forward
                "\\b\\(?:from\\|join\\|update\\|into\\)[ \t\n]+\\([[:alnum:]_.\"]+\\)\\(?:[ \t\n]+\\(?:as[ \t\n]+\\)?\\([[:alpha:]_][[:alnum:]_]*\\)\\)?"
                nil t)
          (let ((tbl (match-string 1)) (al (match-string 2)))
            (push (cons (downcase (replace-regexp-in-string "\"" "" tbl)) tbl) res)
            (when (and al (not (member (downcase al) morg-pg--sql-words)))
              (push (cons (downcase al) tbl) res))))))
    res))

(defun morg-pg--item (name ann kind)
  (propertize name 'morg-ann ann 'morg-kind kind))

(defun morg-pg--kind-ann (k)
  (pcase k ("v" "  вью") ("m" "  matview") ("f" "  foreign") (_ "  таблица")))

(defun morg-pg--col-items (c schema table)
  (mapcar (lambda (r) (morg-pg--item (car r) (concat "  " (cadr r)) 'field))
          (morg-pg--columns c schema table)))

(defun morg-pg--candidates (c parts text)
  "Кандидаты по PARTS — сегментам перед последней точкой; TEXT — текст запроса."
  (let ((rows (morg-pg--tables c)))
    (pcase (length parts)
      (0 (append
          (mapcar (lambda (s) (morg-pg--item s "  схема" 'module))
                  (delete-dups (mapcar #'car rows)))
          (cl-loop for r in rows
                   when (equal (car r) "public")
                   collect (morg-pg--item (cadr r) (morg-pg--kind-ann (nth 2 r)) 'struct))))
      (1 (let* ((p (car parts))
                (ref (or (cdr (assoc (downcase p) (morg-pg--aliases text))) p))
                (res (morg-pg--resolve c ref)))
           (append
            (cl-loop for r in rows
                     when (string-equal-ignore-case (car r) p)
                     collect (morg-pg--item (cadr r) (morg-pg--kind-ann (nth 2 r)) 'struct))
            (when res (morg-pg--col-items c (car res) (cdr res))))))
      (_ (let ((res (morg-pg--resolve
                     c (concat (nth (- (length parts) 2) parts) "."
                               (car (last parts))))))
           (when res (morg-pg--col-items c (car res) (cdr res))))))))

(defun morg-pg--context ()
  "(PARAMS . ТЕКСТ-ЗАПРОСА) если точка в sql-блоке с движком postgres, иначе nil."
  (let ((ctx
         (cond
          ((and (derived-mode-p 'org-mode) (org-in-src-block-p))
           (let ((info (ignore-errors (org-babel-get-src-block-info 'light))))
             (when (and info (equal (nth 0 info) "sql"))
               (cons (nth 2 info) (nth 1 info)))))
          ((and (derived-mode-p 'sql-mode) (bound-and-true-p org-src--babel-info))
           (cons (nth 2 org-src--babel-info)
                 (buffer-substring-no-properties (point-min) (point-max)))))))
    (when (and ctx (string-match-p
                    "postg" (format "%s" (alist-get :engine (car ctx) ""))))
      ctx)))

(defun morg-pg-capf ()
  "completion-at-point для sql-блоков PostgreSQL: схемы, таблицы, колонки."
  (when-let* ((ctx (morg-pg--context))
              (c (morg-pg--conn (car ctx))))
    (let* ((end (point))
           (beg (save-excursion (skip-chars-backward "[:alnum:]_") (point)))
           (parts (save-excursion
                    (goto-char beg)
                    (let (ps)
                      (while (eq (char-before) ?.)
                        (backward-char)
                        (let ((e (point)))
                          (skip-chars-backward "[:alnum:]_\"")
                          (push (buffer-substring-no-properties (point) e) ps)))
                      ps)))
           (cands (morg-pg--candidates c parts (cdr ctx))))
      (when cands
        (list beg end cands
              :exclusive 'no
              :annotation-function (lambda (s) (get-text-property 0 'morg-ann s))
              :company-kind (lambda (s) (get-text-property 0 'morg-kind s)))))))

(defun morg-pg--prefetch ()
  "После набора точки заранее запросить колонки/таблицы (асинхронно)."
  (when (eq last-command-event ?.)
    (ignore-errors (morg-pg-capf))))

(defun morg-pg-refresh ()
  "Сбросить кеш подсказок PostgreSQL для подключения текущего sql-блока."
  (interactive)
  (let* ((ctx (morg-pg--context))
         (c (and ctx (morg-pg--conn (car ctx)))))
    (unless c (user-error "Поставьте курсор в sql-блок с :engine postgresql"))
    (let ((prefix (morg-pg--conn-key c)) keys)
      (dolist (tbl (list morg-pg--cache morg-pg--pending))
        (setq keys nil)
        (maphash (lambda (k _) (when (string-prefix-p prefix k) (push k keys))) tbl)
        (dolist (k keys) (remhash k tbl)))
      (morg-pg--tables c)
      (message "morg-pg: кеш сброшен, список таблиц загружается"))))

(defun morg-pg--setup ()
  (add-hook 'completion-at-point-functions #'morg-pg-capf -50 t)
  (add-hook 'post-self-insert-hook #'morg-pg--prefetch nil t))
(add-hook 'org-mode-hook #'morg-pg--setup)
(add-hook 'sql-mode-hook #'morg-pg--setup)
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c n R") #'morg-pg-refresh))

(provide 'morg-pg)
