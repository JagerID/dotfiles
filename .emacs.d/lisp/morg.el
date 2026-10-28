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

  (defun morg-apply-heading-sizes (&rest _)
    "Применить текущий пресет размеров заголовков."
    (dolist (spec (cdr (assoc morg-heading-preset morg-heading-presets)))
      (set-face-attribute (car spec) nil :height (cdr spec) :weight 'bold))
    (dolist (face '(org-level-5 org-level-6 org-level-7 org-level-8))
      (set-face-attribute face nil :height 1.0 :weight 'bold)))

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

  ;; --- таблицы: выравнивание по пикселям ---------------------------------
  (use-package valign
    :hook (org-mode . valign-mode)
    :custom (valign-fancy-bar nil))       ; рамки рисует org-modern-table

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
    (when morg-text-color
      (face-remap-add-relative 'default :foreground morg-text-color))
    (add-hook 'post-command-hook #'morg-highlight-heading nil t)
    (olivetti-mode 1))                    ; выключить в буфере: C-c o

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
    (org-roam-directory                     org-roam-dir)
    (org-roam-capture-templates             morg-roam-capture-templates)
    (org-roam-dailies-capture-templates     morg-roam-dailies-capture-templates)
    :config
    (org-roam-db-autosync-mode 1))

  (use-package org-roam-ui
    :after org-roam
    :custom (org-roam-ui-follow t))


  (defun morg-apply-tag-faces (&rest _)
    "Цвет тегов (палитра tokyo-night); перезапускается при смене темы."
    (when (facep 'org-modern-tag)
      (set-face-attribute 'org-modern-tag nil
                          :background "#3b4261" :foreground "#bb9af7" :weight 'bold)))

  (use-package org-modern
    :hook (org-mode . org-modern-mode)
    :config
    (morg-apply-tag-faces)
    (morg-apply-text-faces)               ; org-modern-horizontal-rule появляется после загрузки
    (add-hook 'enable-theme-functions #'morg-apply-tag-faces)

    :custom
    (org-modern-star                '("◉" "○" "✸" "✿" "◆" "▶"))
    (org-modern-horizontal-rule     t)       ; ----- превращается в линию
    (org-modern-block-fringe        nil)     ; с org-indent фринж у блоков не нужен
    (org-modern-list                '((?* . "•") (?+ . "‣") (?- . "–")))
    (org-modern-checkbox            '((?X . "☑") (?- . "◪") (?\s . "☐")))
    (org-modern-timestamp           t)
    (org-modern-priority            t)
    (org-modern-progress            t)
    (org-modern-table               t)
    (org-modern-todo-faces
     '(("TODO"   :background "#f7768e" :foreground "#1a1b26" :weight bold)
       ("NEXT"   :background "#7aa2f7" :foreground "#1a1b26" :weight bold)
       ("WAIT"   :background "#e0af68" :foreground "#1a1b26" :weight bold)
       ("DONE"   :background "#9ece6a" :foreground "#1a1b26" :weight bold)
       ("CANCEL" :background "#565f89" :foreground "#1a1b26" :weight bold)))
    (org-modern-block-name
     `((t . t)
       ("src"       ,(nerd-icons-faicon "nf-fa-code")                "─")
       ("note"      ,(nerd-icons-faicon "nf-fa-info_circle")         "─")
       ("tip"       ,(nerd-icons-faicon "nf-fa-lightbulb_o")         "─")
       ("warning"   ,(nerd-icons-faicon "nf-fa-exclamation_triangle") "─")
       ("important" ,(nerd-icons-faicon "nf-fa-exclamation_circle")  "─")
       ("quote"     "❝" "❞")
       ("example"   "»–" "–«"))))

  (use-package org-appear
    :hook (org-mode . org-appear-mode))

  (provide 'morg)
