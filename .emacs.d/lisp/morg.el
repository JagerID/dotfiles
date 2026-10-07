;;; -*- lexical-binding: t -*-

(defun my/org--emphasis-span (m)
  "Вернуть (BEG . END) фрагмента с маркером M, содержащего точку, или nil."
  (let* ((q (regexp-quote (char-to-string m)))
         (re (concat q "[^ \t\n]\\(?:[^\n]*?[^ \t\n]\\)?" q))
         (pt (point))						; позиция курсора
         (lim (line-end-position))				; ищем только в пределах строки
         found)
    (save-excursion
      (goto-char (line-beginning-position))
      (while (and (not found) (re-search-forward re lim t))
        (when (<= (match-beginning 0) pt (match-end 0))
          (setq found (cons (match-beginning 0) (match-end 0))))))
    found))

(defun my/org-toggle-emphasis (m)
  "Переключить обрамление маркером M (символ) для слова/выделения."
  (let ((c (char-to-string m)))
    (cond
     ((use-region-p)						; 1) есть выделение
      (let ((beg (region-beginning)) (end (region-end)))
        (save-excursion						; пробелы по краям не обрамляем
          (goto-char beg) (skip-chars-forward " \t\n" end) (setq beg (point))
          (goto-char end) (skip-chars-backward " \t\n" beg) (setq end (point)))
        (cond
         ((and (> (- end beg) 1)				; маркеры внутри выделения -> снять
               (eq (char-after beg) m) (eq (char-before end) m))
          (save-excursion
            (goto-char end) (delete-char -1)
            (goto-char beg) (delete-char 1))
          (set-mark (- end 2)) (goto-char beg))
         ((and (> beg (point-min))				; маркеры снаружи выделения -> снять
               (eq (char-before beg) m) (eq (char-after end) m))
          (save-excursion
            (goto-char end) (delete-char 1)
            (goto-char (1- beg)) (delete-char 1))
          (set-mark (1- end)) (goto-char (1- beg)))
         (t							; иначе обернуть, выделение сохранить
          (goto-char end) (insert c)
          (goto-char beg) (insert c)
          (set-mark (1+ end)) (goto-char (1+ beg))))))
     ((and (eq (char-before) m) (eq (char-after) m))		; 2) пустая пара вокруг курсора -> удалить
      (delete-char 1) (delete-char -1))
     ((let ((span (my/org--emphasis-span m)))			; 3) курсор внутри обрамления -> снять
        (when span
          (let ((b (car span)) (e (cdr span)) (pt (point)))
            (save-excursion
              (goto-char (1- e)) (delete-char 1)
              (goto-char b) (delete-char 1))
            (goto-char (max b (min (if (> pt b) (1- pt) pt) (- e 2)))))
          t)))
     ((let ((bounds (bounds-of-thing-at-point 'word)))		; 4) слово у курсора -> обернуть
        (when bounds
          (let ((pt (point)))
            (goto-char (cdr bounds)) (insert c)
            (goto-char (car bounds)) (insert c)
            (goto-char (1+ pt)))
          t)))
     (t (insert c c) (backward-char)))))			; 5) ничего нет -> пустая пара

(defmacro my/org-define-emphasis (name marker)
  "Объявить команду NAME, переключающую обрамление MARKER."
  `(defun ,name () (interactive) (my/org-toggle-emphasis ,marker)))

(my/org-define-emphasis my/org-bold        ?*)			; жирный        *текст*
(my/org-define-emphasis my/org-italic      ?/)			; курсив        /текст/
(my/org-define-emphasis my/org-code        ?~)			; код           ~текст~
(my/org-define-emphasis my/org-strike      ?+)			; зачёркнутый   +текст+
(my/org-define-emphasis my/org-underline   ?_)			; подчёркнутый  _текст_
(my/org-define-emphasis my/org-mark-yellow ?`)			; жёлтый маркер `текст`
(my/org-define-emphasis my/org-mark-red    ?!)			; красный       !текст!
(my/org-define-emphasis my/org-mark-green  ?%)			; зелёный       %текст%
(my/org-define-emphasis my/org-mark-blue   ?&)			; синий         &текст&
(my/org-define-emphasis my/org-mark-orange ?^)			; оранжевый     ^текст^
(my/org-define-emphasis my/org-mark-purple ?@)			; фиолетовый    @текст@
(my/org-define-emphasis my/org-mark-cyan   ??)			; бирюзовый     ?текст?

(defun my/clipboard-has-image-p ()
  "Есть ли в буфере обмена картинка."
  (cond
   ((executable-find "wl-paste")				; Wayland
    (string-match-p "image/" (shell-command-to-string
                              "wl-paste --list-types 2>/dev/null")))
   ((executable-find "xclip")					; X11
    (string-match-p "image/" (shell-command-to-string
                              "xclip -selection clipboard -t TARGETS -o 2>/dev/null")))))

(defun my/org-smart-paste ()
  "Вставить картинку из буфера, если она там есть, иначе обычный yank."
  (interactive)
  (if (my/clipboard-has-image-p)
      (org-download-clipboard)					; картинка -> в images/
    (call-interactively #'yank)))				; текст -> обычная вставка

(defun my/setup-ctrl-i (&optional frame)
  "Отделить C-i от TAB в графическом фрейме FRAME."
  (with-selected-frame (or frame (selected-frame))
    (when (display-graphic-p)
      (define-key input-decode-map [?\C-i] [C-i]))))

(my/setup-ctrl-i)						; обычный запуск Emacs
(add-hook 'after-make-frame-functions #'my/setup-ctrl-i)	; каждый фрейм emacsclient

(defface my/org-tag-badge
  '((((background light))
     :foreground "#1d4ed8" :background "#dbeafe"
     :box (:line-width (3 . -1) :color "#dbeafe"))
    (((background dark))
     :foreground "#93c5fd" :background "#1e3a5f"
     :box (:line-width (3 . -1) :color "#1e3a5f")))
  "Плашка одного тега Org."
  :group 'org-faces)

(defface my/org-red
  '((((background light)) :foreground "#c62828" :weight bold)
    (((background dark))  :foreground "#f7768e" :weight bold))
  "Красный: определения."
  :group 'org-faces)

(defface my/org-green
  '((((background light)) :foreground "#2e7d32" :weight bold)
    (((background dark))  :foreground "#9ece6a" :weight bold))
  "Зелёный: примеры."
  :group 'org-faces)

(defface my/org-blue
  '((((background light)) :foreground "#1565c0" :weight bold)
    (((background dark))  :foreground "#7aa2f7" :weight bold))
  "Синий: термины."
  :group 'org-faces)

(defface my/org-mark
  '((((background light)) :background "#fff3b0" :foreground "#3b3000")
    (((background dark))  :background "#5c4b00" :foreground "#ffe58f"))
  "Жёлтый маркер, как выделение в Obsidian."
  :group 'org-faces)

(defface my/org-orange
  '((((background light)) :foreground "#e65100" :weight bold)
    (((background dark))  :foreground "#ff9e64" :weight bold))
  "Оранжевый: предупреждения."
  :group 'org-faces)

(defface my/org-purple
  '((((background light)) :foreground "#6a1b9a" :weight bold)
    (((background dark))  :foreground "#bb9af7" :weight bold))
  "Фиолетовый: ключевые идеи."
  :group 'org-faces)

(defface my/org-cyan
  '((((background light)) :foreground "#00838f" :weight bold)
    (((background dark))  :foreground "#7dcfff" :weight bold))
  "Бирюзовый: заметки и ссылки."
  :group 'org-faces)

(defun my/org-tag-badges ()
  "Оформить теги заголовков и #+filetags плашками (локально для буфера)."
  (font-lock-add-keywords
   nil
   '(("^\\*+ .*[ \t]\\(:[[:alnum:]_@#%:]+:\\)[ \t]*$"		; теги у заголовка
      ("[^: \t\n]+"						; каждое слово между двоеточиями
       (progn (goto-char (match-beginning 1)) (match-end 1))
       nil
       (0 'my/org-tag-badge prepend)))
     ("^#\\+[Ff][Ii][Ll][Ee][Tt][Aa][Gg][Ss]:"			; #+filetags
      ("[^: \t\n]+" (line-end-position) nil
       (0 'my/org-tag-badge prepend))))
   'append))

(defconst my/org-color-specs
  '((?` . my/org-mark)						; жёлтый маркер
    (?! . my/org-red)						; красный
    (?% . my/org-green)						; зелёный
    (?& . my/org-blue)						; синий
    (?^ . my/org-orange)					; оранжевый
    (?@ . my/org-purple)					; фиолетовый
    (?? . my/org-cyan))						; бирюзовый
  "Маркеры цветных выделений и их faces.")

(defvar-local my/org--mark-active nil
  "Цветное выделение под курсором (BEG . END): его маркеры показываются.")

(defun my/org--mark-re (marker)
  "Регулярка выделения с MARKER: группы 1 - открывающий, 2 - текст, 3 - закрывающий."
  (let* ((raw (char-to-string marker))				; символ маркера (для [...])
         (m (regexp-quote raw))					; он же для регулярки
         (c org-emphasis-regexp-components)
         (pre (nth 0 c))					; символы перед маркером
         (post (nth 1 c))					; символы после маркера
         (border (nth 2 c))					; что нельзя у края текста
         (edge (concat "[^" border raw "]")))			; символ у края текста
    (concat "\\(?:^\\|[" pre "]\\)"
            "\\(" m "\\)"
            "\\(" edge "\\(?:[^\n]*?" edge "\\)?\\)"
            "\\(" m "\\)"
            "\\(?:[" post "]\\|$\\)")))

(defun my/org--mark-delim ()
  "Вид маркера: виден под курсором, иначе скрыт (при org-hide-emphasis-markers)."
  (if (and org-hide-emphasis-markers
           (not (equal my/org--mark-active
                       (cons (match-beginning 1) (match-end 3)))))
      '(face shadow invisible t)
    'shadow))

(defun my/org--mark-at-point ()
  "Вернуть (BEG . END) цветного выделения под курсором или nil."
  (let ((pt (point)) (eol (line-end-position)) found)
    (save-excursion
      (dolist (spec my/org-color-specs)
        (goto-char (line-beginning-position))
        (let ((re (my/org--mark-re (car spec))))
          (while (and (not found) (re-search-forward re eol t))
            (goto-char (match-end 3))
            (when (<= (match-beginning 1) pt (match-end 3))
              (setq found (cons (match-beginning 1) (match-end 3))))))))
    found))

(defun my/org--mark-update ()
  "Показать маркеры выделения под курсором, у остальных скрыть."
  (let ((new (my/org--mark-at-point))
        (old my/org--mark-active))
    (unless (equal new old)
      (setq my/org--mark-active new)
      (dolist (r (list old new))
        (when r
          (font-lock-flush (max (point-min) (car r))
                           (min (point-max) (cdr r))))))))

(defun my/org-color-marks ()
  "Цветные выделения: жёлтый, красный, зелёный, синий (локально для буфера)."
  (dolist (spec my/org-color-specs)
    (let* ((re (my/org--mark-re (car spec)))
           (matcher (lambda (limit)
                      (when (re-search-forward re limit t)
                        (goto-char (match-end 3))		; не съедать символ после маркера
                        t))))
      (font-lock-add-keywords
       nil
       `((,matcher
          (1 (my/org--mark-delim) prepend)			; открывающий маркер
          (2 ',(cdr spec) prepend)				; сам текст
          (3 (my/org--mark-delim) prepend)))			; закрывающий маркер
       'append)))
  (add-hook 'post-command-hook #'my/org--mark-update nil t))	; раскрывать маркеры под курсором

(defun my/org-prettify-setup ()
  "Включить prettify-symbols с набором символов для Org."
  (setq-local prettify-symbols-alist
              '(("[ ]" . "☐")					; пустой чекбокс
                ("[X]" . "☑")					; отмеченный
                ("[-]" . "◪")					; частично
                ("#+begin_src" . "»")				; начало блока кода
                ("#+end_src"   . "«")				; конец блока кода
                ("#+BEGIN_SRC" . "»")
                ("#+END_SRC"   . "«")))
  (prettify-symbols-mode 1))

(defun my/org-setup-faces ()
  "Настроить faces Org. Вызывать после загрузки org (и после смены темы)."
  (dolist (f '((org-level-1 . 1.6)				; размеры заголовков как в Obsidian
               (org-level-2 . 1.4)
               (org-level-3 . 1.25)
               (org-level-4 . 1.1)
               (org-level-5 . 1.0)))
    (set-face-attribute (car f) nil :height (cdr f) :weight 'bold))

  (set-face-attribute 'org-drawer nil				; строки :PROPERTIES: / :END:
                      :foreground "#b58900" :height 0.85)
  (set-face-attribute 'org-special-keyword nil			; имена свойств (:ID:, :CREATED:)
                      :foreground "#2aa198" :height 0.85)
  (set-face-attribute 'org-property-value nil			; значения свойств
                      :foreground "#6c71c4" :height 0.85)

  (set-face-attribute 'org-document-title nil			; сам #+title
                      :inherit 'font-lock-keyword-face
                      :height 1.0 :weight 'bold)
  (set-face-attribute 'org-document-info-keyword nil		; "#+title:", "#+date:" и т.д.
                      :inherit 'shadow :height 0.85)
  (set-face-attribute 'org-document-info nil			; значения date, author
                      :inherit 'font-lock-string-face)
  (set-face-attribute 'org-meta-line nil			; остальные #+-строки
                      :inherit '(font-lock-comment-face fixed-pitch)
                      :height 0.85 :slant 'normal)

  (set-face-attribute 'org-tag nil				; двоеточия между тегами
                      :inherit 'shadow :height 0.8 :weight 'normal)

  (dolist (face '(org-block org-code org-verbatim org-table	; моноширинные элементы
                  org-formula org-checkbox org-special-keyword))
    (set-face-attribute face nil :inherit 'fixed-pitch)))

(defvar org-babel-default-header-args:glsl '((:results . "output")))

(defun org-babel-execute:glsl (body params)
  "Проверить шейдер через glslangValidator.
Стадия берётся из заголовка :stage (vert, frag, comp, geom...), по умолчанию frag:
glslangValidator определяет стадию по расширению временного файла."
  (unless (executable-find "glslangValidator")
    (user-error "Не найден glslangValidator (пакет glslang)"))
  (let* ((stage (or (cdr (assq :stage params)) "frag"))		; стадия шейдера
         (file (make-temp-file "org-glsl-" nil (concat "." stage)))
         (out ""))
    (unwind-protect
        (progn
          (write-region body nil file nil 'silent)
          (setq out (with-output-to-string
                      (with-current-buffer standard-output
                        (call-process "glslangValidator" nil t nil file)))))
      (delete-file file))
    (setq out (string-trim
               (replace-regexp-in-string (regexp-quote file) "shader" out)))
    (if (string= out "shader") "OK" out)))

(use-package ob-rust						; babel для Rust (rustc)
  :defer t)							; только установка; подгрузит org-babel

(use-package glsl-mode						; подсветка GLSL в блоках и файлах
  :defer t)							; режим подхватывается по имени языка glsl

(use-package org
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         :map org-mode-map
         ("C-b"     . my/org-bold)				; жирный
         ("<C-i>"   . my/org-italic)				; курсив (только GUI)
         ("C-`"     . my/org-code)				; код
         ("C-S-x"   . my/org-strike)				; зачёркнутый
         ("C-c u"   . my/org-underline)				; подчёркнутый (C-u занят)
         ("C-c h y" . my/org-mark-yellow)			; жёлтый маркер
         ("C-c h r" . my/org-mark-red)				; красный
         ("C-c h g" . my/org-mark-green)			; зелёный
         ("C-c h b" . my/org-mark-blue)				; синий
         ("C-c h o" . my/org-mark-orange)			; оранжевый
         ("C-c h p" . my/org-mark-purple)			; фиолетовый
         ("C-c h c" . my/org-mark-cyan)				; бирюзовый
         ("C-y"     . my/org-smart-paste))			; картинка из буфера / текст
  :hook ((org-mode . my/org-prettify-setup)			; символы вместо [ ], #+begin_src
         (org-mode . my/org-tag-badges)				; плашки тегов
         (org-mode . my/org-color-marks)			; цветные выделения (` ! % & ^ @ ?)
         (org-mode . org-hide-drawer-all))			; свернуть drawers при открытии
  :custom
  (org-directory "~/org/")
  (org-default-notes-file (concat org-directory "inbox.org"))
  (org-agenda-files (list org-directory))			; агенда: ~/org/, без roam/
  (org-log-done 'time)						; время закрытия TODO

  (org-support-shift-select t)					; выделение Shift+стрелки
  (org-startup-indented t)					; отступы вместо звёздочек
  (org-hide-emphasis-markers t)					; прятать маркеры вокруг выделений
  (org-pretty-entities t)					; нужно для org-appear-autoentities
  (org-image-actual-width nil)					; уважать #+attr_org :width
  (org-tags-column 0)						; тег сразу после заголовка
  (org-agenda-tags-column 0)					; то же в агенде
  (prettify-symbols-unprettify-at-point 'right-edge)		; раскрывать символ под курсором

  (org-startup-with-latex-preview nil)				; формулы по запросу (ошибка LaTeX не ломает открытие)
  (org-preview-latex-default-process 'dvisvgm)			; SVG чётче, чем dvipng
  (org-preview-latex-image-directory "~/.cache/org-ltximg/")	; картинки формул не в папке заметок

  (org-src-fontify-natively t)					; подсветка кода в блоках
  (org-edit-src-content-indentation 0)				; без отступа внутри блока
  (org-confirm-babel-evaluate nil)				; C-c C-c без вопросов

  (org-structure-template-alist					; <имя + TAB
   '(("c"   . "src C")						; вместо center
     ("cp"  . "src C++")
     ("sh"  . "src sh")
     ("lua" . "src lua")
     ("gl"  . "src glsl")
     ("el"  . "src emacs-lisp")
     ("py"  . "src python")
     ("rs"  . "src rust")
     ("mk"  . "src makefile")
     ("a"   . "export ascii")
     ("q"   . "quote")
     ("e"   . "example")
     ("v"   . "verse")
     ("C"   . "comment")
     ("n"   . "note")))						; свой блок-врезка
  :config
  (my/org-setup-faces)						; faces: заголовки, drawers, теги

  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.6))	; размер формул

  (setf (alist-get "rust" org-src-lang-modes nil nil #'equal)
        'rust-ts)						; rust-ts-mode (нужна грамматика)

  (org-babel-do-load-languages					; языки для C-c C-c
   'org-babel-load-languages
   '((C . t) (shell . t) (python . t) (emacs-lisp . t) (rust . t) (lua . t))))

(use-package org-appear						; разметка видна, когда курсор на ней
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)					; *жирный*, /курсив/ и т.д.
  (org-appear-autolinks t)					; ссылки
  (org-appear-autoentities t))					; \alpha и т.п.

(use-package org-superstar					; красивые маркеры
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-headline-bullets-list '("❖" "✿" "✸" "❀" "✦"))
  (org-superstar-remove-leading-stars t)			; убрать ведущие звёзды
  (org-superstar-prettify-item-bullets t)			; маркеры списков
  (org-superstar-item-bullet-alist '((?- . ?•)
                                     (?+ . ?◦)
                                     (?* . ?▸))))

(use-package org-fragtog					; формула раскрывается под курсором
  :hook (org-mode . org-fragtog-mode))

(use-package org-tempo
  :ensure nil							; встроенный в Org
  :after org
  :config
  (tempo-define-template "org-c-main"				; <cm  C с main, запускается
    '("#+begin_src C :includes <stdio.h> :results output" n
      "int main(void)" n
      "{" n
      "    " p n
      "    return 0;" n
      "}" n
      "#+end_src" n)
    "<cm" "C-блок с main" 'org-tempo-tags)

  (tempo-define-template "org-c-func"				; <cf  C без запуска
    '("#+begin_src C :tangle no" n p n "#+end_src" n)
    "<cf" "C-блок без запуска" 'org-tempo-tags)

  (tempo-define-template "org-c-tangle"				; <ct  C, tangle в файл
    '("#+begin_src C :tangle " (p "src/file.c" file) " :mkdirp yes" n
      p n
      "#+end_src" n)
    "<ct" "C-блок с tangle в файл" 'org-tempo-tags)

  (tempo-define-template "org-sh-out"				; <sho  shell с выводом
    '("#+begin_src sh :results output" n p n "#+end_src" n)
    "<sho" "shell-блок с выводом" 'org-tempo-tags)

  (tempo-define-template "org-header"				; <hd  шапка заметки
    '("#+title: " (p "Название" title) n
      "#+date: " (format-time-string "%Y-%m-%d") n
      "#+filetags: " p n n)
    "<hd" "Шапка заметки" 'org-tempo-tags)

  (tempo-define-template "org-rust-main"			; <rm  Rust с main, запускается
    '("#+begin_src rust :results output" n
      "fn main() {" n
      "    " p n
      "}" n
      "#+end_src" n)
    "<rm" "Rust-блок с main" 'org-tempo-tags)

  (tempo-define-template "org-rust-func"			; <rf  Rust без запуска
    '("#+begin_src rust :eval no" n p n "#+end_src" n)
    "<rf" "Rust-блок без запуска" 'org-tempo-tags)

  (tempo-define-template "org-rust-tangle"			; <rt  Rust, tangle в файл
    '("#+begin_src rust :tangle " (p "src/main.rs" file) " :mkdirp yes" n
      p n
      "#+end_src" n)
    "<rt" "Rust-блок с tangle в файл" 'org-tempo-tags)

  (tempo-define-template "org-glsl-vert"			; <gv  вершинный шейдер
    '("#+begin_src glsl :stage vert :tangle " (p "shaders/shader.vert" file) " :mkdirp yes" n
      "#version 330 core" n
      "layout (location = 0) in vec3 aPos;" n n
      "void main()" n
      "{" n
      "    gl_Position = vec4(aPos, 1.0);" n
      "    " p n
      "}" n
      "#+end_src" n)
    "<gv" "GLSL: вершинный шейдер" 'org-tempo-tags)

  (tempo-define-template "org-glsl-frag"			; <gf  фрагментный шейдер
    '("#+begin_src glsl :stage frag :tangle " (p "shaders/shader.frag" file) " :mkdirp yes" n
      "#version 330 core" n
      "out vec4 FragColor;" n n
      "void main()" n
      "{" n
      "    FragColor = vec4(1.0, 0.5, 0.2, 1.0);" n
      "    " p n
      "}" n
      "#+end_src" n)
    "<gf" "GLSL: фрагментный шейдер" 'org-tempo-tags))

(use-package org-download
  :after org
  :commands org-download-clipboard				; нужна для my/org-smart-paste
  :hook (dired-mode . org-download-enable)			; drag-and-drop из dired
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "./images")				; папка images рядом с заметкой
  (org-download-heading-lvl nil)
  (org-download-timestamp "%Y%m%d-%H%M%S_")			; дата в имени файла
  (org-download-image-attr-list '("#+attr_org: :width 500"))
  (org-download-display-inline-images nil))			; показом занимается org

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/sync/org/roam/"))
  (org-roam-completion-everywhere t)				; ссылки по Tab в тексте
  (org-roam-capture-templates
   '(("d" "Обычная" plain "%?"					; имя файла = заголовок, без даты
      :target (file+head "${slug}.org"
                         "#+title: ${title}\n#+filetags: \n")
      :unnarrowed t)))
  :bind (("C-c n f" . org-roam-node-find)			; найти/создать заметку
         ("C-c n i" . org-roam-node-insert)			; вставить ссылку
         ("C-c n l" . org-roam-buffer-toggle)			; панель бэклинков
         ("C-c n c" . org-roam-capture)				; быстрая заметка
         ("C-c n j" . org-roam-dailies-capture-today))		; запись дня
  :config
  (org-roam-db-autosync-mode))					; синхронизация индекса SQLite

(use-package org-roam-ui					; граф заметок в браузере
  :after org-roam
  :bind ("C-c n g" . org-roam-ui-mode))

(use-package reverse-im						; сочетания в русской раскладке
  :custom (reverse-im-input-methods '("russian-computer"))
  :config (reverse-im-mode t))

(use-package jinx						; проверка орфографии
  :hook (emacs-startup . global-jinx-mode)
  :bind ("M-$" . jinx-correct)					; исправить слово
  :custom (jinx-languages "ru_RU en_US"))

(provide 'morg)
