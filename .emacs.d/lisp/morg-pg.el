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

  ;; --- подсказки: ключевые слова SQL и мета-команды psql ----------------------------------
  ;; Мета-команда psql — команда, которая начинается с обратной косой черты (\dt, \d+ …) и
  ;; выполняется самим клиентом psql, а не сервером. ob-sql запускает psql, поэтому они работают
  ;; и в sql-блоках. Подсказки включаются по тому же условию, что и таблицы (:engine postgresql).
  (defconst morg-pg--keywords
    '(("select" . "выбрать столбцы") ("distinct" . "без дубликатов") ("from" . "откуда")
      ("where" . "фильтр строк") ("group by" . "группировка") ("having" . "фильтр групп")
      ("order by" . "сортировка") ("limit" . "сколько строк") ("offset" . "пропустить N строк")
      ("fetch first" . "FETCH FIRST n ROWS ONLY") ("join" . "соединение") ("left join" . "все слева")
      ("right join" . "все справа") ("inner join" . "только совпавшие") ("full join" . "все с обеих")
      ("cross join" . "декартово") ("lateral" . "подзапрос видит левые таблицы")
      ("on" . "условие join") ("using" . "join по одноимённым") ("union" . "объединить, без дублей")
      ("union all" . "объединить как есть") ("intersect" . "пересечение") ("except" . "разность")
      ("with" . "CTE: именованный подзапрос") ("recursive" . "рекурсивный CTE")
      ("insert into" . "вставка") ("values" . "список значений") ("returning" . "вернуть изменённые строки")
      ("on conflict" . "upsert") ("do nothing" . "при конфликте ничего") ("do update set" . "при конфликте обновить")
      ("update" . "изменить") ("set" . "новые значения") ("delete from" . "удалить")
      ("for update" . "заблокировать строки") ("skip locked" . "пропустить занятые строки (после FOR UPDATE)")
      ("nowait" . "ошибка, если строка занята") ("case when" . "условное выражение")
      ("coalesce" . "первое не NULL") ("nullif" . "NULL, если равны") ("cast" . "привести тип")
      ("exists" . "есть ли строки") ("in" . "в списке") ("between" . "в диапазоне") ("like" . "шаблон")
      ("ilike" . "шаблон без регистра") ("is null" . "пусто") ("is not null" . "не пусто")
      ("count" . "агрегат: число") ("sum" . "агрегат: сумма") ("avg" . "агрегат: среднее")
      ("min" . "агрегат: минимум") ("max" . "агрегат: максимум") ("string_agg" . "склеить строки")
      ("array_agg" . "собрать в массив") ("over" . "оконная функция") ("partition by" . "окно: группы")
      ("row_number" . "номер строки в окне") ("explain analyze" . "план и реальное время")
      ("explain" . "план запроса") ("create index" . "индекс") ("create table" . "таблица")
      ("alter table" . "изменить таблицу") ("drop table" . "удалить таблицу") ("truncate" . "очистить таблицу")
      ("begin" . "начать транзакцию") ("commit" . "зафиксировать") ("rollback" . "откатить")))

  (defconst morg-pg--meta-commands
    '(("\\d" . "описание таблицы/объекта") ("\\d+" . "описание подробно") ("\\dt" . "список таблиц")
      ("\\dt+" . "таблицы с размером") ("\\dv" . "вью") ("\\dm" . "matview") ("\\di" . "индексы")
      ("\\ds" . "последовательности") ("\\df" . "функции") ("\\dn" . "схемы") ("\\du" . "роли")
      ("\\dx" . "расширения") ("\\dT" . "типы") ("\\dp" . "права доступа") ("\\l" . "базы данных")
      ("\\c" . "подключиться к базе") ("\\conninfo" . "параметры подключения")
      ("\\x" . "вертикальный вывод") ("\\timing" . "время запросов") ("\\pset" . "параметры вывода")
      ("\\a" . "выравнивание вкл/выкл") ("\\t" . "только строки, без шапки") ("\\o" . "вывод в файл")
      ("\\i" . "выполнить файл") ("\\copy" . "COPY через клиент") ("\\set" . "переменная psql")
      ("\\echo" . "вывести текст") ("\\sf" . "исходник функции") ("\\sv" . "исходник вью")
      ("\\gset" . "результат в переменные") ("\\watch" . "повторять запрос") ("\\?" . "справка")))

;; Ключевые слова нужны в любом sql-блоке (и в sql-mode), даже если :engine не задан
  ;; или определился иначе; таблицы и колонки по-прежнему только для postgresql.
  (defun morg-pg--sql-here-p ()
    (or (morg-pg--context)
        (and (derived-mode-p 'org-mode) (org-in-src-block-p)
             (equal (car (ignore-errors (org-babel-get-src-block-info 'light))) "sql"))
        (derived-mode-p 'sql-mode)))

  (defun morg-pg-debug ()
    "Показать, почему подсказки PostgreSQL работают или нет в точке (M-x morg-pg-debug)."
    (interactive)
    (let* ((orig (current-buffer))
           (info (and (derived-mode-p 'org-mode) (org-in-src-block-p)
                      (ignore-errors (org-babel-get-src-block-info 'light))))
           (ctx (morg-pg--context))
           (here (morg-pg--sql-here-p))
           (caps completion-at-point-functions))
      (with-current-buffer (get-buffer-create "*morg-pg-debug*")
        (erase-buffer)
        (insert (format "major-mode источника: %s\n" (buffer-local-value 'major-mode orig)))
        (insert (format "язык блока: %S\n" (car info)))
        (insert (format ":engine: %S\n" (alist-get :engine (nth 2 info))))
        (insert (format "morg-pg--context: %s\n" (if ctx "найден" "nil (подсказки таблиц не включатся)")))
        (insert (format "sql-блок (для ключевых слов): %s\n" (and here t)))
        (insert (format "capf-хуки: %S\n" caps))
        (insert (format "буфер: %s\n" orig))
        (pop-to-buffer (current-buffer)))))

  (defun morg-pg-keyword-capf ()
    "completion-at-point: ключевые слова SQL и мета-команды psql в sql-блоках PostgreSQL."
    (when (morg-pg--sql-here-p)
      (let* ((end (point))
             (beg (save-excursion
                    (skip-chars-backward "[:alnum:]_+")
                    (when (eq (char-before) ?\\) (backward-char))
                    (point))))
        (unless (eq (char-before beg) ?.)
          (let* ((meta (eq (char-after beg) ?\\))
                 (tbl (if meta morg-pg--meta-commands morg-pg--keywords)))
            (when (or meta (> (- end beg) 1))     ; ключевые слова — только с 2 букв
              (list beg end
                    ;; регистр как у набранного: SEL → SELECT, sel → select
                    ;; (completion-ignore-case по умолчанию nil, иначе «SEL» не найдёт «select»)
                    (let ((up (let ((typed (buffer-substring-no-properties beg end)))
                                (and (string-match-p "[A-Z]" typed)
                                     (not (string-match-p "[a-z]" typed))))))
                      (mapcar (lambda (e)
                                (propertize (if (and up (not meta)) (upcase (car e)) (car e))
                                            'morg-ann (concat "  " (cdr e))))
                              tbl))
                    :exclusive 'no
                    :annotation-function (lambda (s) (get-text-property 0 'morg-ann s))
                    :company-kind (lambda (_) (if meta 'snippet 'keyword)))))))))

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

  ;; --- ER-диаграмма схемы -------------------------------------------------------------
  ;; M-x morg-pg-er-diagram (C-c n E) в sql-блоке с :engine postgresql: читает из базы
  ;; таблицы, колонки, первичные и внешние ключи выбранной схемы и вставляет под блоком
  ;; готовый d2-блок. Выполнив его (C-c C-c), получаете картинку: таблицы-прямоугольники
  ;; со списком колонок и стрелки между связанными таблицами. Нужны установленные d2
  ;; и psql. Составные внешние ключи показываются по первой колонке; связи с таблицами
  ;; из других схем не рисуются.
  (defvar morg-pg-er-max-tables 60
    "Если таблиц больше, спросить подтверждение (иначе картинка нечитаема).")
  (defvar morg-pg-er-flags "--pad 20 --layout elk" "Ключи d2 в заголовке блока.")
  (defvar morg-pg-er-dir "~/syn/org/attachments/" "Куда складывать картинки.")

  (defun morg-pg--query-sync (c sql)
    "Выполнить SQL синхронно; вернуть список строк (списков полей) или ошибку."
    (let ((process-environment (cons "PGCONNECT_TIMEOUT=5" process-environment))
          (err (make-temp-file "morg-pg-err")))
      (unwind-protect
          (with-temp-buffer
            (let ((code (apply #'call-process morg-pg-program nil (list t err) nil
                               "-X" "-w" "-A" "-t" "-F" "\t"
                               (append (morg-pg--args c) (list "-c" sql)))))
              (unless (zerop code)
                (user-error "psql: %s"
                            (string-trim (with-temp-buffer
                                           (insert-file-contents err)
                                           (buffer-string)))))
              (mapcar (lambda (l) (split-string l "\t"))
                      (split-string (buffer-string) "\n" t))))
        (delete-file err))))

  (defun morg-pg--d2-name (s)
    "Имя в кавычках для D2 (кавычки и обратные косые экранируются)."
    (format "\"%s\"" (replace-regexp-in-string "[\"\\\\]" "\\\\\\&" s)))

  (defun morg-pg--er-neighbors (picked fks schema)
    "PICKED плюс таблицы, связанные с ними внешними ключами внутри SCHEMA."
    (let ((set (copy-sequence picked)))
      (dolist (f fks)
        (when (equal (nth 2 f) schema)
          (cond ((member (car f) picked) (cl-pushnew (nth 3 f) set :test #'equal))
                ((member (nth 3 f) picked) (cl-pushnew (car f) set :test #'equal)))))
      set))

  (defun morg-pg--er-d2 (schema cols fks tables)
    "Текст диаграммы D2.
COLS — строки (таблица колонка тип pk), FKS — (таблица колонка схема2 таблица2 колонка2),
TABLES — какие таблицы рисовать."
    (let ((fk-cols (make-hash-table :test #'equal)) edges out)
      (dolist (f fks)
        (when (and (equal (nth 2 f) schema)
                   (member (car f) tables) (member (nth 3 f) tables))
          (puthash (cons (car f) (nth 1 f)) t fk-cols)
          (push f edges)))
      (push "direction: right\n\n" out)
      (dolist (tb tables)
        (push (format "%s: {\n  shape: sql_table\n" (morg-pg--d2-name tb)) out)
        (dolist (c cols)
          (when (equal (car c) tb)
            (let* ((pk (equal (nth 3 c) "t"))
                   (fk (gethash (cons tb (nth 1 c)) fk-cols))
                   (constraint (cond ((and pk fk) " {constraint: [primary_key; foreign_key]}")
                                     (pk " {constraint: primary_key}")
                                     (fk " {constraint: foreign_key}")
                                     (t ""))))
              (push (format "  %s: %s%s\n" (morg-pg--d2-name (nth 1 c))
                            (morg-pg--d2-name (nth 2 c)) constraint)
                    out))))
        (push "}\n\n" out))
      (dolist (f (nreverse edges))
        (push (format "%s.%s -> %s.%s\n"
                      (morg-pg--d2-name (nth 0 f)) (morg-pg--d2-name (nth 1 f))
                      (morg-pg--d2-name (nth 3 f)) (morg-pg--d2-name (nth 4 f)))
              out))
      (apply #'concat (nreverse out))))

  (defun morg-pg-er-diagram ()
    "Построить ER-диаграмму (d2-блок) схемы PostgreSQL для подключения текущего sql-блока."
    (interactive)
    (unless (derived-mode-p 'org-mode)
      (user-error "Запустите в самой заметке (не в буфере редактирования блока)"))
    (let* ((ctx (or (morg-pg--context)
                    (user-error "Поставьте курсор в sql-блок с :engine postgresql")))
           (c (morg-pg--conn (car ctx)))
           (schemas (mapcar #'car
                            (morg-pg--query-sync
                             c (format "SELECT nspname FROM pg_namespace WHERE nspname NOT IN (%s) AND nspname NOT LIKE 'pg\\_toast%%' AND nspname NOT LIKE 'pg\\_temp%%' ORDER BY 1"
                                       morg-pg-system-schemas))))
           (schema (completing-read "Схема: " schemas nil t nil nil
                                    (if (member "public" schemas) "public" (car schemas))))
           (qs (morg-pg--quote schema))
           (cols (morg-pg--query-sync
                  c (format "SELECT c.relname, a.attname, format_type(a.atttypid, a.atttypmod), COALESCE((SELECT true FROM pg_index i WHERE i.indrelid = c.oid AND i.indisprimary AND a.attnum = ANY(i.indkey::int2[])), false) FROM pg_attribute a JOIN pg_class c ON c.oid = a.attrelid JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '%s' AND c.relkind IN ('r','p') AND a.attnum > 0 AND NOT a.attisdropped ORDER BY c.relname, a.attnum"
                            qs)))
           (fks (morg-pg--query-sync
                 c (format "SELECT c1.relname, a1.attname, n2.nspname, c2.relname, a2.attname FROM pg_constraint k JOIN pg_class c1 ON c1.oid = k.conrelid JOIN pg_namespace n1 ON n1.oid = c1.relnamespace JOIN pg_class c2 ON c2.oid = k.confrelid JOIN pg_namespace n2 ON n2.oid = c2.relnamespace JOIN pg_attribute a1 ON a1.attrelid = k.conrelid AND a1.attnum = k.conkey[1] JOIN pg_attribute a2 ON a2.attrelid = k.confrelid AND a2.attnum = k.confkey[1] WHERE k.contype = 'f' AND n1.nspname = '%s' ORDER BY 1,2"
                           qs)))
           (all (delete-dups (mapcar #'car cols)))
           (picked (delete "" (completing-read-multiple
                               "Таблицы через запятую (пусто — вся схема): " all)))
           (tables (sort (if picked (morg-pg--er-neighbors picked fks schema) (copy-sequence all))
                         #'string<)))
      (unless tables (user-error "В схеме %s нет таблиц" schema))
      (when (and (> (length tables) morg-pg-er-max-tables)
                 (not (y-or-n-p (format "Таблиц %d — картинка будет огромной. Продолжить? "
                                        (length tables)))))
        (user-error "Отменено: выберите нужные таблицы или поднимите morg-pg-er-max-tables"))
      (let* ((safe (lambda (s) (replace-regexp-in-string "[^[:alnum:]_-]" "_" (format "%s" s))))
             (base (format "er-%s-%s" (funcall safe (or (plist-get c :db) "db")) (funcall safe schema)))
             (file (concat (file-name-as-directory morg-pg-er-dir) base ".png"))
             (d2 (morg-pg--er-d2 schema cols fks tables)))
        (make-directory (file-name-directory (expand-file-name file)) t)
        (when (and (derived-mode-p 'org-mode) (org-in-src-block-p))
          (goto-char (org-element-property :end (org-element-at-point))))
        (unless (bolp) (insert "\n"))
        (insert (format "\n#+name: %s\n#+caption: ER-диаграмма схемы %s (%d таблиц)\n#+begin_src d2 :file %s :results file replace :flags \"%s\"\n%s#+end_src\n"
                        base schema (length tables) file morg-pg-er-flags d2))
        (re-search-backward "^[ \t]*#\\+begin_src d2" nil t)
        (message "Блок с диаграммой вставлен (%d таблиц)." (length tables))
        (cond
         ((not (executable-find "d2"))
          (message "Блок вставлен, но программа d2 не найдена в PATH — картинку не построить."))
         ((y-or-n-p "Построить картинку сейчас? ")
          (org-babel-execute-src-block)
          ;; картинку показываем чуть позже: файл уже записан, блок перерисован
          (let ((buf (current-buffer)))
            (run-with-timer
             0.3 nil
             (lambda ()
               (when (buffer-live-p buf)
                 (with-current-buffer buf
                   (condition-case err
                       (cond ((fboundp 'org-link-preview-refresh) (org-link-preview-refresh))
                             (t (org-redisplay-inline-images)))
                     (error (message "Не удалось показать картинку: %s"
                                     (error-message-string err))))))))))))))

  (defun morg-pg--setup ()
    (add-hook 'completion-at-point-functions #'morg-pg-capf -50 t)
    (add-hook 'completion-at-point-functions #'morg-pg-keyword-capf -40 t)
    (add-hook 'post-self-insert-hook #'morg-pg--prefetch nil t))
  (add-hook 'org-mode-hook #'morg-pg--setup)
  (add-hook 'sql-mode-hook #'morg-pg--setup)
  (with-eval-after-load 'org
    (define-key org-mode-map (kbd "C-c n R") #'morg-pg-refresh)
    (define-key org-mode-map (kbd "C-c n E") #'morg-pg-er-diagram))

  (provide 'morg-pg)
