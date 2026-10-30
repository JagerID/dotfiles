;;; morg.el --- generated from config.org -*- lexical-binding: t -*-

(require 'morg-templates)

  (defvar root-dir             (expand-file-name "~/syn"))
  (defvar books-dir            (expand-file-name "books/"        root-dir))
  (defvar org-dir              (expand-file-name "org/"          root-dir))
  (defvar org-roam-dir         (expand-file-name "roam/"         org-dir))
  (defvar org-notes-file       (expand-file-name "index.org"     org-dir))
  (defvar org-attachments-dir  (expand-file-name "attachments/"  org-dir))
  (defvar org-tasks-file       (expand-file-name "tasks.org"     org-dir))
  (defvar org-agenda-fls       (list org-tasks-file))
  (make-directory books-dir            t)
  (make-directory org-roam-dir         t)
  (make-directory org-attachments-dir  t)

  (defvar morg-capture-templates
    '(("t" "задача" entry
       (file+headline org-tasks-file "Inbox")        ; всегда tasks.org → Inbox
       "* TODO %?\n")
      ("s" "задача с датой" entry
       (file+headline org-tasks-file "Inbox")
       "* TODO %?\nSCHEDULED: %^t\n")                ; спросит дату, попадёт в agenda
      ("l" "задача со ссылкой" entry
       (file+headline org-tasks-file "Inbox")
       "* TODO %?\n%a\n")))

  (defvar my/org-babel-languages
    '((shell     . t)
      (python    . t)
      (plantuml  . t)
      (sql       . t)
      (C         . t)
      (d2        . t)
      (dot       . t)))

  (defun my/split-ctrl-i ()
    "В GUI-фрейме сделать C-i отдельной клавишей, не равной TAB."
    (when (display-graphic-p)
      (define-key input-decode-map [?\C-i] [C-i])))

  (defun my/org-toggle-emphasis (m)
    "Обернуть выделение (или слово у курсора) маркером M или снять его."
    (let* ((c (char-to-string m))
           (r (if (use-region-p)
                  (cons (region-beginning) (region-end))
                (bounds-of-thing-at-point 'word))))
      (if (null r)
          (progn (insert c c) (backward-char))   ; нет слова: пустая пара
        (let ((b (car r)) (e (cdr r)))
          (save-excursion
            (if (and (eq (char-before b) m) (eq (char-after e) m))
                (progn (goto-char e) (delete-char 1)   ; маркеры снаружи: снять
                       (goto-char b) (delete-char -1))
              (goto-char e) (insert c)                 ; иначе обернуть
              (goto-char b) (insert c)))
          (deactivate-mark)))))

  (defun my/org-bold ()   (interactive) (my/org-toggle-emphasis ?*))
  (defun my/org-italic () (interactive) (my/org-toggle-emphasis ?/))
  (defun my/org-code ()   (interactive) (my/org-toggle-emphasis ?~))

  (my/split-ctrl-i)
  (add-hook 'server-after-make-frame-hook #'my/split-ctrl-i)

  ;; --- размеры заголовков -------------------------------------------------
  ;; множитель к высоте основного шрифта; уровни 5-8 всегда 1.0
  (defvar morg-heading-presets
    '(("обычный"    . ((org-document-title . 1.8) (org-level-1 . 1.5) (org-level-2 . 1.3)
                       (org-level-3 . 1.15) (org-level-4 . 1.05)))
      ("крупный"    . ((org-document-title . 2.2) (org-level-1 . 1.8) (org-level-2 . 1.5)
                       (org-level-3 . 1.3) (org-level-4 . 1.15)))
      ("компактный" . ((org-document-title . 1.4) (org-level-1 . 1.2) (org-level-2 . 1.1)
                       (org-level-3 . 1.0) (org-level-4 . 1.0))))
    "Пресеты размеров заголовков: имя -> список (лицо . множитель).")

  (defvar morg-heading-preset "обычный"
    "Текущий пресет из `morg-heading-presets'.")

  ;; цвета заголовков: «Ocean ladder» (бирюзовый → голубой → синий → серо-синий)
  (defvar morg-heading-colors
    '((org-document-title . "#d6f5f0")
      (org-level-1 . "#73daca") (org-level-2 . "#7dcfff")
      (org-level-3 . "#7aa2f7") (org-level-4 . "#9aa5ce")
      (org-level-5 . "#73daca") (org-level-6 . "#7dcfff")
      (org-level-7 . "#7aa2f7") (org-level-8 . "#9aa5ce"))
    "Цвета заголовков: лицо -> цвет.")

  (defun morg-apply-heading-sizes (&rest _)
    "Применить текущий пресет размеров и цвета заголовков."
    (dolist (spec (cdr (assoc morg-heading-preset morg-heading-presets)))
      (set-face-attribute (car spec) nil :height (cdr spec) :weight 'bold))
    (dolist (face '(org-level-5 org-level-6 org-level-7 org-level-8))
      (set-face-attribute face nil :height 1.0 :weight 'bold))
    (dolist (spec morg-heading-colors)
      (when (facep (car spec))
        (set-face-attribute (car spec) nil :foreground (cdr spec)))))

  (defun morg-set-heading-preset (name)
    "Интерактивно переключить пресет размеров заголовков."
    (interactive (list (completing-read "Размер заголовков: "
                                        (mapcar #'car morg-heading-presets) nil t)))
    (setq morg-heading-preset name)
    (morg-apply-heading-sizes))

  (with-eval-after-load 'org
    (morg-apply-heading-sizes))
  ;; смена темы перезаписывает лица, применяем заново (Emacs 29+)
  (add-hook 'enable-theme-functions #'morg-apply-heading-sizes)

  ;; --- цвет обычного текста в org (вместо синеватого цвета темы) -----------
  ;; nil — оставить цвет темы
  (defvar morg-text-color "#ffffff")

  ;; --- olivetti: текст колонкой по центру ----------------------------------
  (use-package olivetti
    :custom
    (olivetti-body-width        100)
    (olivetti-minimum-body-width 60)
    :bind ("C-c o" . olivetti-mode))      ; переключатель

  ;; --- таблицы: valign отключён ---------------------------------------------
  ;; valign сам перерисовывает строки-разделители |---+---| и перекрывает линии
  ;; из morg--table-prettify (они выходили белыми). Шрифт моноширинный, поэтому
  ;; столбцы и так ровные. Нужен valign (широкие символы, смешанные шрифты) —
  ;; верните (use-package valign :hook (org-mode . valign-mode)), но линии
  ;; разделителей тогда будут рисоваться им, а не нашим кодом.

  ;; --- цвета и лица текста (палитра tokyo-night) --------------------------
  (defun morg-apply-text-faces (&rest _)
    "Цвета жирного, курсива, цитат, блоков, ссылок, метаданных и свойств."
    (let ((bg-block  "#1f2335")
          (bg-edge   "#181925")
          (muted     "#565f89")
          (muted-2   "#414868"))
      (dolist (spec
               `((bold               :foreground "#ffffff" :weight bold)
                 (italic             :foreground "#9ece6a" :slant italic)
                 (org-quote          :foreground "#a9b1d6" :background ,bg-block
                                     :slant italic :extend t)
                 (org-block          :background unspecified :extend t)
                 (org-block-begin-line :foreground ,muted :background unspecified
                                     :slant normal :extend t)
                 (org-block-end-line :foreground ,muted :background unspecified
                                     :slant normal :extend t)
                 (org-link           :foreground "#7dcfff" :underline nil)
                 ;; ~код~ как inline-код в чате Claude: красноватый текст на мягком фоне
                 (org-code           :foreground "#ff7a93" :background "#2b2f47")
                 ,@(when morg-text-color    ; таблицы того же цвета, что и текст
                     `((org-table        :foreground ,morg-text-color)
                       (org-table-row    :foreground ,morg-text-color)
                       (org-table-header :foreground ,morg-text-color)))
                 (org-meta-line      :foreground ,muted :slant italic)
                 (org-document-info-keyword :foreground ,muted :slant italic)
                 (org-drawer         :foreground ,muted-2)
                 (org-special-keyword :foreground ,muted-2 :slant italic)
                 (org-property-value :foreground ,muted)
                 (org-modern-horizontal-rule :foreground ,muted-2
                                     :strike-through ,muted-2)))
        (when (facep (car spec))
          (apply #'set-face-attribute (car spec) nil (cdr spec))))))

  (with-eval-after-load 'org
    (morg-apply-text-faces))
  (add-hook 'enable-theme-functions #'morg-apply-text-faces)

  ;; --- подсветка текущего заголовка ---------------------------------------
  (defface morg-current-heading
    '((t :background "#292e42" :extend t))
    "Фон строки заголовка, в поддереве которого находится курсор.")

  (defvar-local morg--heading-overlay nil)

  (defun morg-highlight-heading ()
    "Подсветить заголовок текущего поддерева."
    (let ((pos (save-excursion
                 (condition-case nil
                     (progn (org-back-to-heading t) (point))
                   (error nil)))))
      (cond
       ((null pos)
        (when (overlayp morg--heading-overlay)
          (delete-overlay morg--heading-overlay)))
       (t
        (let ((end (min (point-max)
                        (1+ (save-excursion (goto-char pos) (line-end-position))))))
          (if (overlayp morg--heading-overlay)
              (move-overlay morg--heading-overlay pos end)
            (setq morg--heading-overlay (make-overlay pos end nil t))
            (overlay-put morg--heading-overlay 'face 'morg-current-heading)
            (overlay-put morg--heading-overlay 'priority 10)))))))

  ;; --- результаты org-babel ------------------------------------------------
  (require 'ansi-color)

  (defun morg-babel-ansi-colors ()
    "Раскрасить ANSI-коды в результате блока под курсором.
Для shell-команд нужен вывод с цветом, например `ls --color=always'."
    (when-let* ((beg (org-babel-where-is-src-block-result))
                (end (save-excursion (goto-char beg) (org-babel-result-end))))
      (save-excursion
        (ansi-color-apply-on-region beg end))))

  (defvar morg-babel-fold-threshold 15
    "Результат длиннее этого числа строк сворачивается после выполнения.")

  (defun morg-babel-fold-long-result ()
    "Свернуть длинный результат блока под курсором (раскрыть: C-c C-v t)."
    (when-let ((beg (org-babel-where-is-src-block-result)))
      (save-excursion
        (goto-char beg)
        (let ((end (org-babel-result-end)))
          (when (> (count-lines beg end) morg-babel-fold-threshold)
            (goto-char beg)
            (org-babel-hide-result-toggle t))))))

  (defun morg-babel-hide-success-output ()
    "Закрыть окно stderr после успешного запуска (например d2: «success: ...»).
Если в выводе есть что-то про ошибку, окно остаётся."
    (when-let* ((buf (get-buffer "*Org-Babel Error Output*"))
                (win (get-buffer-window buf)))
      (when (with-current-buffer buf
              (let ((text (buffer-string)))
                (and (string-match-p "success:" text)
                     (not (string-match-p "err" text)))))
        (delete-window win))))

  (add-hook 'org-babel-after-execute-hook #'morg-babel-hide-success-output)

  (defun morg-visual-setup ()
    "Визуальные настройки для org-буферов."
    (setq-local line-spacing 0.25)        ; межстрочный интервал
    ;; страховка: ispell-дополнение слов в org-буферах не нужно (см. common.el)
    (setq-local completion-at-point-functions
                (remq 'ispell-completion-at-point completion-at-point-functions))
    (when morg-text-color
      (face-remap-add-relative 'default :foreground morg-text-color))
    (add-hook 'post-command-hook #'morg-highlight-heading nil t)
    (olivetti-mode 1)                     ; выключить в буфере: C-c o
    (add-hook 'after-save-hook #'morg-fit-width nil t)
    (morg-fit-width))

  ;; --- olivetti: ширина текста подстраивается под самую широкую таблицу ----
  (defvar morg-olivetti-base-width 100
    "Обычная ширина текста; расширяется только если в буфере есть таблица шире.")

  (defun morg-fit-width ()
    "Расширить olivetti под самую широкую таблицу в буфере."
    (when (and (derived-mode-p 'org-mode) (bound-and-true-p olivetti-mode))
      (let ((w morg-olivetti-base-width))
        (save-excursion
          (goto-char (point-min))
          (while (re-search-forward "^[ \t]*|.*$" nil t)
            (setq w (max w (+ 4 (string-width (match-string 0)))))))
        (olivetti-set-width (min w (max morg-olivetti-base-width
                                        (- (window-total-width) 4)))))))

  (advice-add 'org-table-align :after (lambda (&rest _) (morg-fit-width)))

  ;; --- PlantUML: путь к jar ------------------------------------------------
  ;; Arch: sudo pacman -S plantuml  (jar обычно в /usr/share/java/plantuml/)
  ;; Если jar лежит в другом месте, добавьте путь в список.
  (defvar morg-plantuml-jar
    (seq-find #'file-exists-p
              (list "/usr/share/java/plantuml/plantuml.jar"
                    "/usr/share/plantuml/plantuml.jar"
                    (expand-file-name "plantuml.jar" user-emacs-directory)))
    "Путь к plantuml.jar или nil, если не найден.")

  (unless morg-plantuml-jar
    (message "plantuml.jar не найден: поставьте пакет plantuml или поправьте morg-plantuml-jar"))

  ;; общий файл настроек (-config): если его нет, создаём с тёмным оформлением.
  ;; Хотите стиль по умолчанию — очистите файл, оставив только комментарии.
  (defvar morg-plantuml-config (expand-file-name "plantuml.cfg" user-emacs-directory)
    "Файл настроек PlantUML, передаётся через -config.")

  (unless (file-exists-p morg-plantuml-config)
    (let ((coding-system-for-write 'utf-8))
      (with-temp-file morg-plantuml-config
        (insert "' Common PlantUML settings (passed with -config)\n"
                "skinparam backgroundColor #1a1b26\n"
                "skinparam shadowing false\n"
                "skinparam defaultFontColor #ffffff\n"
                "skinparam ArrowColor #a9b1d6\n"
                "skinparam ArrowFontColor #ffffff\n"
                "skinparam rectangle {\n"
                "  BackgroundColor #24283b\n"
                "  BorderColor #565f89\n"
                "  FontColor #ffffff\n"
                "}\n"))))

  ;; --- D2: диаграммы в org-блоках ------------------------------------------
  ;; нужен бинарник `d2' в PATH. Использование:
  ;;   #+begin_src d2 :file ~/syn/org/attachments/имя.png :flags "--pad 20"
  ;; (результат только файл, поэтому :file обязателен; тема/раскладка через :flags,
  ;;  например "--theme ID --layout elk"; список тем: `d2 themes')
  ;; Пакеты стоят до (use-package org), чтобы быть установленными к загрузке языков.
  (use-package d2-mode
    :mode "\\.d2\\'")

  (use-package ob-d2
    :defer t)

  (use-package org
    :bind (("C-c c" . org-capture)
           ("C-c a" . org-agenda)
           :map org-mode-map
           ("C-b"   . my/org-bold)
           ("<C-i>" . my/org-italic)
           ("C-c h" . morg-set-heading-preset))
    :hook ((org-babel-after-execute . org-link-preview-refresh)
           (org-babel-after-execute . morg-babel-ansi-colors)
           (org-babel-after-execute . morg-babel-fold-long-result)
           (org-mode                . morg-visual-setup))
    :custom
    (org-ellipsis                         " ▾")

    ;; рекомендации org-modern
    (org-auto-align-tags                  nil)
    (org-tags-column                      0)
    (org-catch-invisible-edits            'show-and-error)
    (org-special-ctrl-a/e                 t)
    (org-insert-heading-respect-content   t)
    (org-directory                        org-dir)
    (org-default-notes-file               org-notes-file)
    (org-attach-dir                       org-attachments-dir)

    (org-startup-indented                 t)
    (org-hide-emphasis-markers            t)
    (org-pretty-entities                  t)
    (org-use-sub-superscripts             '{})  ; rack_id остаётся текстом, индекс только a_{b}
    (org-link-descriptive                 t)
    (org-support-shift-select             t)

    (org-startup-with-inline-images       t)
    (org-image-actual-width               '(500))

    (org-return-follows-link              t)
    (org-log-done                         'time)
    (org-enforce-todo-dependencies        t)

    (org-image-max-width                  'window)
    (org-image-align                      'center)

    (org-refile-targets                   '((org-agenda-files :maxlevel . 3)))
    (org-refile-use-outline-path          'file)
    (org-outline-path-complete-in-steps   nil)

    (org-agenda-files                     org-agenda-fls)
    (org-capture-templates                morg-capture-templates)
    (org-todo-keywords                    '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "CANCEL(c)")))

    ;; статусы заметок: взаимоисключающая группа (работает в C-c C-q);
    ;; надёжная смена статуса в roam: morg-set-status / morg-status-advance
    (org-tag-persistent-alist             '((:startgroup)
                                            ("draft"  . ?d)
                                            ("review" . ?r)
                                            ("done"   . ?x)
                                            (:endgroup)
                                            ("question"    . ?q)))

    (org-plantuml-jar-path                morg-plantuml-jar)
    (org-plantuml-exec-mode               'jar)
    (org-plantuml-args
     (list "-headless" "-charset" "UTF-8"          ; UTF-8 нужен для кириллицы
           "-config" morg-plantuml-config))

    (org-confirm-babel-evaluate           nil)
    (org-src-fontify-natively             t)
    (org-src-tab-acts-natively            t)
    (org-src-content-indentation          0)
    :config
    (org-babel-do-load-languages 'org-babel-load-languages my/org-babel-languages))

  ;; --- быстрые блоки: <src TAB, <c TAB и т.д. (org-tempo) -----------------
  ;; ключ = то, что пишется после "<". Сначала дополняем alist, потом грузим
  ;; org-tempo, чтобы он сразу создал шаблоны.
  (with-eval-after-load 'org
    (dolist (tpl '(("src" . "src")
                   ("cc"  . "src C")           ; "c" занято стандартным center
                   ("sh"  . "src shell")
                   ("el"  . "src emacs-lisp")
                   ("py"  . "src python")
                   ("sql" . "src sql")
                   ("n"   . "note")
                   ("t"   . "tip")
                   ("w"   . "warning")
                   ("im"  . "important")        ; "i" занято org-tempo (#+index)
                   ("qs"  . "question")
                   ("pu"  . "src plantuml :file ~/syn/org/attachments/.png")
                   ("d2"  . "src d2 :file ~/syn/org/attachments/.png :flags \"--pad 20\"")))
      (add-to-list 'org-structure-template-alist tpl t))
    (require 'org-tempo)
    ;; callout с кодом внутри: <nsql TAB, <nsh TAB, <nel TAB
    (dolist (spec '(("nsql" . "sql") ("nsh" . "shell") ("nel" . "emacs-lisp")))
      (tempo-define-template
       (concat "morg-note-" (car spec))
       `("#+begin_note" n "*Что делает:* " p n
         ;; вложенный src — с отступом в 2 пробела (вне callout отступа нет)
         ,(concat "  #+begin_src " (cdr spec)) n "  " p n "  #+end_src" n "#+end_note" n)
       (concat "<" (car spec))
       "callout note с src-блоком"
       'org-tempo-tags)))

  ;; --- поиск по заметкам: C-f в org-файлах --------------------------------
  ;; consult-org-roam-search ищет по ВСЕМ заметкам roam (нужен ripgrep).
  ;; Поиск по строкам текущего буфера в org уезжает на C-c s.
  ;; В остальных режимах C-f остаётся consult-line.
  (use-package consult-org-roam
    :after (org org-roam consult)
    :custom (consult-org-roam-grep-func #'consult-ripgrep)
    :bind (:map org-mode-map
                ("C-f"   . consult-org-roam-search)
                ("C-c s" . consult-line))
    :config (consult-org-roam-mode 1))

  ;; асинхронный запуск блоков: добавьте заголовок :async, например
  ;; #+begin_src shell :async yes   (не работает вместе с :session)
  (use-package ob-async
    :after org)

  (use-package org-roam
    :bind (("C-c n f" . org-roam-node-find)
           ("C-c n i" . org-roam-node-insert)
           ("C-c n l" . org-roam-buffer-toggle)
           ("C-c n c" . org-roam-capture)
           ("C-c n r" . org-roam-ref-find)
           ("C-c n d" . org-roam-dailies-capture-today)
           ("C-c n t" . org-roam-dailies-goto-today))
    :custom
    (org-roam-complete-everywhere           t)
    ;; сортировка в C-c n f: недавно изменённые заметки сверху
    (org-roam-node-default-sort             'file-mtime)
    ;; теги в списке поиска (C-c n f, C-c n i)
    (org-roam-node-display-template         "${morg-line}")
    (org-roam-directory                     org-roam-dir)
    (org-roam-capture-templates             morg-roam-capture-templates)
    (org-roam-dailies-capture-templates     morg-roam-dailies-capture-templates)
    :config
    (org-roam-db-autosync-mode 1))

  (use-package org-roam-ui
    :after org-roam
    :custom (org-roam-ui-follow t))

  ;; vertico по умолчанию пересортировывает кандидатов (история/длина/алфавит)
  ;; и ломает порядок org-roam; на время org-roam-node-find отключаем это
  (define-advice org-roam-node-find (:around (fn &rest args) keep-mtime-order)
    (let ((vertico-sort-function nil))
      (apply fn args)))

  ;; --- теги: статусы, режим изучения, статистика ---------------------------
  (defvar morg-status-tags '("draft" "review" "done")
    "Статусы заметки, взаимоисключающие. Порядок = путь продвижения.")

  (defvar morg-study-tags (append morg-status-tags '("question"))
    "Теги для фильтров режима изучения и для статистики.")

  (defun morg--node-status ()
    "Текущий статус заметки в точке или nil."
    (seq-find (lambda (tag) (member tag morg-status-tags))
              (org-roam-node-tags (org-roam-node-at-point 'assert))))

  (defun morg-set-status (status)
    "Поставить заметке статус STATUS, сняв прежний (статусы взаимоисключающие)."
    (interactive (list (completing-read "Статус: " morg-status-tags nil t)))
    (let ((old (seq-filter (lambda (tag) (member tag morg-status-tags))
                           (org-roam-node-tags (org-roam-node-at-point 'assert)))))
      (when old (org-roam-tag-remove old))
      (org-roam-tag-add (list status))
      (message "Статус: %s" status)))

  (defun morg-status-advance ()
    "Перевести заметку на следующий статус: draft → review → done."
    (interactive)
    (let* ((cur  (morg--node-status))
           (next (if cur
                     (cadr (member cur morg-status-tags))
                   (car morg-status-tags))))
      (if next
          (morg-set-status next)
        (message "Уже «%s», дальше некуда" cur))))

  (defun morg-find-by-tag (tag)
    "Режим изучения: поиск заметок только с тегом TAG (например, «draft»)."
    (interactive
     (list (completing-read "Тег: "
                            (delete-dups (append morg-study-tags
                                                 (org-roam-tag-completions)))
                            nil nil)))
    (org-roam-node-find nil nil
                        (lambda (node) (member tag (org-roam-node-tags node)))))

  (defun morg-status-stats ()
    "Показать, сколько заметок на каждом статусе (и с тегом «question»)."
    (interactive)
    (let ((rows (org-roam-db-query
                 [:select [tag (funcall count *)] :from tags :group-by tag])))
      (message "%s"
               (mapconcat (lambda (tag)
                            (format "%s: %d" tag (or (cadr (assoc tag rows)) 0)))
                          morg-study-tags "  ·  "))))

  (global-set-key (kbd "C-c n g") #'org-roam-tag-add)
  (global-set-key (kbd "C-c n G") #'org-roam-tag-remove)
  (global-set-key (kbd "C-c n s") #'morg-set-status)
  (global-set-key (kbd "C-c n n") #'morg-status-advance)
  (global-set-key (kbd "C-c n q") #'morg-find-by-tag)
  (global-set-key (kbd "C-c n p") #'morg-status-stats)


  ;; --- теги как #хэштеги с лёгкой заливкой (обычный текст) -----------------
  ;; В буфере ":a:b:" в конце заголовка и в #+filetags показывается как чипы
  ;; " #a "  " #b " (только отображение, текст файла не меняется): яркий цвет
  ;; текста + лёгкий фон того же цвета, без рамки. Пробелы по краям чипа входят
  ;; в заливку, между чипами обычный зазор. Статусы — свои цвета, остальные — один.
  (require 'cl-lib)
  (require 'color)     ; color-rgb-to-hex

  (defvar morg-tag-colors
    '(("draft"    . "#ff7a93")            ; коралловый
      ("review"   . "#ffc857")            ; янтарный
      ("done"     . "#8fe388")            ; ярко-зелёный
      ("question" . "#6ea8ff"))           ; синий
    "Яркие цвета тегов-статусов.")

  (defvar morg-tag-default-color "#7fd6e8"
    "Цвет всех остальных тегов (не статусов): яркий бирюзово-голубой.")

  (defvar morg-tag-tint 0.20
    "Насколько цвет тега подмешивается в фон чипа (0 — нет, 1 — сплошной).")

  (defun morg--mix (fg bg amount)
    "Смешать цвет FG с фоном BG: AMOUNT 0..1 — доля FG. Возвращает \"#rrggbb\"."
    (let ((f (color-name-to-rgb fg))
          (b (color-name-to-rgb bg)))
      (apply #'color-rgb-to-hex
             (append (cl-mapcar (lambda (x y) (+ y (* (- x y) amount))) f b)
                     '(2)))))

  (defun morg--tag-face (tag)
    "Лицо чипа для тега TAG (строка без двоеточий): цвет текста + лёгкий фон."
    (let* ((fg (or (cdr (assoc tag morg-tag-colors)) morg-tag-default-color))
           (base (or (face-background 'default nil t) "#1a1b26")))
      `(:foreground ,fg :background ,(morg--mix fg base morg-tag-tint))))

  (defun morg--hashtagify ()
    "Показать группу тегов (группа 1 в данных совпадения) как чипы \" #a \"."
    (save-match-data
      (let ((beg (match-beginning 1))
            (end (match-end 1))
            colons)
        (save-excursion
          (goto-char beg)
          (while (search-forward ":" end t)
            (push (1- (point)) colons)))
        (setq colons (nreverse colons))
        (let ((n (length colons)) (i 0))
          (dolist (p colons)
            (let* ((prev (and (> i 0) (nth (1- i) colons)))
                   (next (and (< i (1- n)) (nth (1+ i) colons)))
                   (face-prev (and prev (morg--tag-face
                                         (buffer-substring-no-properties (1+ prev) p))))
                   (face-next (and next (morg--tag-face
                                         (buffer-substring-no-properties (1+ p) next)))))
              ;; двоеточие = закрыть предыдущий чип + зазор + открыть следующий
              (put-text-property
               p (1+ p) 'display
               (concat (and face-prev (propertize " " 'face face-prev))
                       (and face-prev face-next " ")
                       (and face-next (propertize " #" 'face face-next))))
              (when face-next
                (add-face-text-property (1+ p) next face-next)))
            (setq i (1+ i))))))
    nil)

  (with-eval-after-load 'org
    (font-lock-add-keywords
     'org-mode
     '(("^\\*+ .*?[ \t]+\\(:[[:alnum:]_@#%:]+:\\)[ \t]*$" (1 (morg--hashtagify)))
       ("^#\\+filetags:[ \t]+\\(:[[:alnum:]_@#%:]+:\\)"   (1 (morg--hashtagify))))
     t)
    (add-hook 'org-mode-hook
              (lambda ()
                (setq-local font-lock-extra-managed-props
                            (cl-union '(display line-height)
                                      font-lock-extra-managed-props)))))

  ;; org-roam-node-find / node-insert: заголовок | тема (папка) | теги.
  ;; Колонка тегов выравнивается по пикселям через (space :align-to (- right N)),
  ;; поэтому не «ползёт» из-за ширины букв, иконок и отступов у тегов.
  ;; Колонка темы — фиксированной ширины, стоит левее тегов.
  (defvar morg-roam-tags-columns 44
    "Сколько колонок справа в списке org-roam отдано под теги.")

  (defvar morg-roam-topic-columns 14
    "Ширина колонки темы (папки) слева в списке org-roam.")

  (with-eval-after-load 'org-roam
    (cl-defmethod org-roam-node-morg-tags ((node org-roam-node))
      (mapconcat (lambda (tag)
                   (propertize (concat " #" tag " ") 'face (morg--tag-face tag)))
                 (org-roam-node-tags node) " "))

    (cl-defmethod org-roam-node-morg-topic ((node org-roam-node))
      "Тема заметки: путь папки относительно roam; «/» — корень."
      (let* ((rel (file-relative-name (org-roam-node-file node) org-roam-directory))
             (dir (file-name-directory rel)))
        (truncate-string-to-width (if dir (directory-file-name dir) "/")
                                  morg-roam-topic-columns nil ?\s "…")))

    (cl-defmethod org-roam-node-morg-line ((node org-roam-node))
      (let* ((cols  morg-roam-tags-columns)
             (room  (max 20 (- (window-width (minibuffer-window))
                               cols morg-roam-topic-columns 6)))
             (topic (propertize (org-roam-node-morg-topic node)
                                'face '(:foreground "#7982a9")))
             (title (truncate-string-to-width
                     (org-roam-node-title node) room nil nil "…"))
             (tags  (truncate-string-to-width
                     (org-roam-node-morg-tags node) (1- cols) nil nil "…")))
        ;; заголовок | тема | теги: обе правые колонки выровнены по пикселям
        (concat title " "
                (propertize " " 'display
                            `(space :align-to (- right ,(+ cols morg-roam-topic-columns 2))))
                topic
                (propertize " " 'display `(space :align-to (- right ,cols)))
                tags))))

  ;; --- таблицы: первая строка (над первой горизонтальной линией) жирная -----
  ;; Шапкой считается строка таблицы, за которой сразу идёт линия |---+---| и
  ;; перед которой нет других строк таблицы.
  (defface morg-table-header-row
    '((t :inherit bold))
    "Лицо первой (шапочной) строки таблицы Org.")

  (defun morg--table-header-matcher (limit)
    "Найти строку-шапку таблицы до LIMIT (для font-lock)."
    (let (found)
      (while (and (not found)
                  (re-search-forward "^[ \t]*|[^-\n].*$" limit t))
        (let* ((md   (match-data))
               (beg  (match-beginning 0))
               (prev-ok (save-excursion
                          (goto-char beg)
                          (or (bobp)
                              (progn (forward-line -1)
                                     (not (looking-at-p "[ \t]*|"))))))
               (next-ok (save-excursion
                          (goto-char beg)
                          (forward-line 1)
                          (looking-at-p "[ \t]*|-"))))
          (when (and prev-ok next-ok)
            (set-match-data md)
            (setq found t))))
      found))

  (with-eval-after-load 'org
    (font-lock-add-keywords
     'org-mode
     '((morg--table-header-matcher (0 'morg-table-header-row prepend)))
     t))

  ;; --- таблицы: тонкие линии из рамочных символов ---------------------------
  ;; Только отображение (текст файла остаётся обычным org-таблицей):
  ;;   |  в строках данных   -> │
  ;;   |---+---|             -> ├───┼───┤  (┌┬┐ если это верх таблицы, └┴┘ — низ)
  ;; Одно и то же начертание у вертикальных и горизонтальных линий, поэтому
  ;; они одной толщины. У строк таблицы отключается межстрочный интервал
  ;; (line-height t на переводе строки), чтобы линии не рвались между строками.
  (defvar morg-table-line-color "#7d88b8"
    "Цвет линий таблиц (nil — цвет текста).")

  (defun morg--table-glyph (ch pos beg last top bottom)
    "Символ-рамка для CH в строке-линии: POS — позиция, BEG/LAST — края строки."
    (cond ((eq ch ?-) "─")
          ((eq ch ?+) (cond (top "┬") (bottom "┴") (t "┼")))
          ((= pos beg)  (cond (top "┌") (bottom "└") (t "├")))
          ((= pos last) (cond (top "┐") (bottom "┘") (t "┤")))
          (t "│")))

  (defun morg--table-prettify (limit)
    "Для font-lock: нарисовать линии таблиц Org в области до LIMIT."
    (while (re-search-forward "^[ \t]*\\(|.*\\)$" limit t)
      (let* ((beg  (match-beginning 1))
             (bol  (line-beginning-position))
             (end  (save-excursion
                     (goto-char (match-end 1))
                     (skip-chars-backward " \t")
                     (point)))
             (last (1- end))
             (hline (save-excursion (goto-char beg) (looking-at-p "|-[-+|]*[ \t]*$")))
             (top    (save-excursion (goto-char bol)
                                     (or (bobp)
                                         (progn (forward-line -1)
                                                (not (looking-at-p "[ \t]*|"))))))
             (bottom (save-excursion (goto-char bol)
                                     (forward-line 1)
                                     (not (looking-at-p "[ \t]*|")))))
        (save-excursion
          (goto-char beg)
          (while (< (point) end)
            (let ((ch (char-after)))
              (when (or (eq ch ?|) (and hline (memq ch '(?- ?+))))
                (put-text-property
                 (point) (1+ (point)) 'display
                 (propertize (if hline
                                 (morg--table-glyph ch (point) beg last top bottom)
                               "│")
                             'face (and morg-table-line-color
                                        `(:foreground ,morg-table-line-color))))))
            (forward-char 1)))
        ;; line-height = t на символе перевода строки: у этой строки межстрочный
        ;; интервал игнорируется (свойство line-spacing лишь увеличивает интервал,
        ;; уменьшить им нельзя), поэтому вертикальные линии не рвутся
        (let ((eol (line-end-position)))
          (when (< eol (point-max))
            (put-text-property eol (1+ eol) 'line-height t)))))
    nil)

  (with-eval-after-load 'org
    (font-lock-add-keywords 'org-mode '(morg--table-prettify) t))

  ;; --- callout-блоки как в Obsidian ------------------------------------------
  ;; #+begin_note ... #+end_note (а также tip / warning / important / question):
  ;; тело блока слегка подкрашено цветом типа, строки begin/end — цветные и жирные.
  ;; Внутрь можно класть обычные src-блоки (см. шаблоны <nsql, <nsh, <nel).
  (defvar morg-callout-colors
    '(("note"      . "#7dcfff")
      ("tip"       . "#9ece6a")
      ("warning"   . "#e0af68")
      ("important" . "#f7768e")
      ("question"  . "#7aa2f7"))
    "Типы callout-блоков и их цвета.")
  (defvar morg-callout-body-tint 0.08 "Насколько цвет типа подмешан в фон тела блока.")

  (defvar morg--callout-names
    (regexp-opt (mapcar #'car morg-callout-colors))
    "Регулярное выражение с именами callout-блоков.")

  (defun morg--callout-color (name)
    "Цвет типа блока NAME."
    (or (cdr (assoc (downcase name) morg-callout-colors)) "#7fd6e8"))

  (defun morg--callout-body-face ()
    "Лицо тела блока; тип берётся из группы 1 совпадения morg--callout-matcher."
    `(:background ,(morg--mix (morg--callout-color (match-string-no-properties 1))
                              (or (face-background 'default nil t) "#1a1b26")
                              morg-callout-body-tint)
      :extend t))

  (defun morg--callout-head-face (name)
    "Лицо строк #+begin_/#+end_ для типа NAME."
    ;; Только цвет и жирность, без своего фона: фон строк даёт тело блока,
    ;; иначе он накладывается на фон иконки org-modern (двойная подсветка).
    `(:foreground ,(morg--callout-color name) :weight bold))

  (defun morg--callout-matcher (limit)
    "Для font-lock: найти блок #+begin_X ... #+end_X; совпадение 0 — весь блок, 1 — тип."
    (let (found)
      (while (and (not found)
                  (re-search-forward
                   (concat "^[ \t]*#\\+begin_\\(" morg--callout-names "\\)\\_>") limit t))
        (let ((bb (match-beginning 0))
              (tb (match-beginning 1))
              (te (match-end 1))
              (name (match-string-no-properties 1)))
          (when (re-search-forward
                 (concat "^[ \t]*#\\+end_" (regexp-quote name) "\\_>.*$") nil t)
            ;; тело включает строку #+end_ вместе с переводом строки: иначе
            ;; :extend не срабатывает и красится только видимый символ-замена
            (set-match-data (list bb (min (point-max) (1+ (point))) tb te))
            (setq found t))))
      found))

  (defun morg--callout-extend-region ()
    "Если правка внутри callout-блока, перекрасить блок целиком."
    (let ((re (concat "^[ \t]*#\\+\\(begin\\|end\\)_" morg--callout-names "\\_>"))
          (changed nil))
      (save-excursion
        (goto-char font-lock-beg)
        (when (and (re-search-backward re nil t)
                   (string-equal-ignore-case (match-string 1) "begin"))
          (setq font-lock-beg (line-beginning-position) changed t)))
      (save-excursion
        (goto-char font-lock-end)
        (when (and (re-search-forward re nil t)
                   (string-equal-ignore-case (match-string 1) "end"))
          (setq font-lock-end (line-end-position) changed t)))
      changed))

  (defun morg--callout-src-fontify (limit)
    "Подсветить синтаксис src-блоков, вложенных в callout (Org сам их не трогает).
Только красит и всегда возвращает nil — для font-lock это «ничего не найдено»."
    (while (re-search-forward
            "^[ \t]*#\\+begin_src[ \t]+\\([^ \t\n]+\\)[^\n]*\n" limit t)
      (let ((lang (match-string-no-properties 1))
            (beg (match-end 0)))
        (when (and (save-excursion
                     (goto-char beg)
                     (and (re-search-backward
                           (concat "^[ \t]*#\\+\\(begin\\|end\\)_" morg--callout-names "\\_>")
                           nil t)
                          (string-equal-ignore-case (match-string 1) "begin")))
                   (re-search-forward "^[ \t]*#\\+end_src" nil t))
          (let ((end (match-beginning 0)))
            (ignore-errors (org-src-font-lock-fontify-block lang beg end))))))
    nil)

  (font-lock-add-keywords
   'org-mode
   `(morg--callout-src-fontify          ; раньше фона: фон блока накладывается поверх
     (morg--callout-matcher (0 (morg--callout-body-face) prepend))
     (,(concat "^[ \t]*\\(#\\+\\(?:begin\\|end\\)_\\(" morg--callout-names "\\)\\_>.*\\)$")
      (1 (morg--callout-head-face (match-string-no-properties 2)) prepend)))
   t)

  (add-hook 'org-mode-hook
            (lambda ()
              (add-hook 'font-lock-extend-region-functions
                        #'morg--callout-extend-region t t)))

  ;; --- отступ у src-блоков, вложенных в callout ---------------------------------
  (defvar morg-callout-src-indent 2 "Отступ вложенного в callout src-блока.")

  (defun morg--in-callout-p ()
    "Не-nil, если точка внутри callout-блока (между #+begin_X и #+end_X)."
    (save-excursion
      (beginning-of-line)
      (and (re-search-backward
            (concat "^[ \t]*#\\+\\(begin\\|end\\)_" morg--callout-names "\\_>") nil t)
           (string-equal-ignore-case (match-string 1) "begin"))))

  (defun morg--tempo-indent-nested (fn &rest args)
    "После <s TAB (и др.) внутри callout сдвинуть вставленный src-блок."
    (let ((inside (morg--in-callout-p))
          (start (line-beginning-position))
          (marker (point-marker)))
      (apply fn args)
      (when (and inside (> (point-max) start))
        (save-excursion
          (goto-char start)
          (let* ((ind (max morg-callout-src-indent (current-indentation)))
                 (end (when (re-search-forward "^[ \t]*#\\+end_src" nil t)
                        (copy-marker (line-end-position)))))
            (when end
              (goto-char start)
              (while (<= (point) end)
                (unless (or (looking-at-p "[ \t]*$") (>= (current-indentation) ind))
                  (indent-line-to ind))
                (forward-line 1)))))
        (when (looking-at-p "[ \t]*$")      ; точка на пустой строке кода — встать после отступа
          (end-of-line)))
      (set-marker marker nil)))

  (with-eval-after-load 'org-tempo
    (advice-add 'org-tempo-complete-tag :around #'morg--tempo-indent-nested))

  (defun morg-indent-nested-src ()
    "Сдвинуть на `morg-callout-src-indent' все src-блоки внутри callout в буфере."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (let ((n 0))
        (while (re-search-forward "^\\([ \t]*\\)#\\+begin_src\\_>" nil t)
          (let ((bol (match-beginning 0))
                (cur (current-indentation)))
            (when (and (< cur morg-callout-src-indent)
                       (save-excursion (goto-char bol) (morg--in-callout-p)))
              (let ((shift (- morg-callout-src-indent cur))
                    (end (save-excursion
                           (when (re-search-forward "^[ \t]*#\\+end_src" nil t)
                             (copy-marker (line-end-position))))))
                (when end
                  (goto-char bol)
                  (while (<= (point) end)
                    (unless (looking-at-p "[ \t]*$")
                      (insert (make-string shift ?\s)))
                    (forward-line 1))
                  (setq n (1+ n)))))))
        (message "Сдвинуто src-блоков в callout: %d" n))))
  ;; C-c n i обычно занят org-roam-node-insert, поэтому C-c n >
  (with-eval-after-load 'org
    (define-key org-mode-map (kbd "C-c n >") #'morg-indent-nested-src))

  (use-package org-modern
    :hook (org-mode . org-modern-mode)
    :config
    (morg-apply-text-faces)               ; org-modern-horizontal-rule появляется после загрузки

    :custom
    (org-modern-star                '("◉" "○" "✸" "✿" "◆" "▶"))
    (org-modern-horizontal-rule     t)       ; ----- превращается в линию
    (org-modern-block-fringe        nil)     ; с org-indent фринж у блоков не нужен
    (org-modern-list                '((?* . "•") (?+ . "‣") (?- . "–")))
    (org-modern-checkbox            '((?X . "☑") (?- . "◪") (?\s . "☐")))
    (org-modern-timestamp           t)
    (org-modern-priority            t)
    (org-modern-progress            t)
    (org-modern-table               nil)     ; линии таблиц рисуем сами (morg--table-prettify)
    (org-modern-tag                 nil)     ; теги рисуем сами, как #хэштеги (см. выше)
    (org-modern-todo-faces
     '(("TODO"   :background "#f7768e" :foreground "#1a1b26" :weight bold)
       ("NEXT"   :background "#7aa2f7" :foreground "#1a1b26" :weight bold)
       ("WAIT"   :background "#e0af68" :foreground "#1a1b26" :weight bold)
       ("DONE"   :background "#9ece6a" :foreground "#1a1b26" :weight bold)
       ("CANCEL" :background "#565f89" :foreground "#1a1b26" :weight bold)))
    (org-modern-block-name
     `((t . t)
       ;; <> и </> — иконки nerd-icons: узкие, как картинки (обычные символы шире)
       ("src"       ,(concat (nerd-icons-faicon "nf-fa-angle_left")
                             (nerd-icons-faicon "nf-fa-angle_right"))
                    ,(nerd-icons-faicon "nf-fa-code"))
       ;; у callout-блоков конец — просто цветная полоса (текст — один пробел)
       ("note"      ,(nerd-icons-faicon "nf-fa-info_circle")         " ")
       ("tip"       ,(nerd-icons-faicon "nf-fa-lightbulb_o")         " ")
       ("warning"   ,(nerd-icons-faicon "nf-fa-exclamation_triangle") " ")
       ("important" ,(nerd-icons-faicon "nf-fa-exclamation_circle")  " ")
       ("question"  ,(nerd-icons-faicon "nf-fa-question_circle")     " ")
       ("quote"     "❝" "❞")
       ("example"   "»–" "–«"))))

  (use-package org-appear
    :hook (org-mode . org-appear-mode))

  (require 'morg-pg)                     ; подсказки PostgreSQL в sql-блоках

  (provide 'morg)
