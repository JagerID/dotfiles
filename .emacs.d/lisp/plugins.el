;;; plugins.el --- generated from config.org -*- lexical-binding: t -*-

(use-package vertico
  :custom
  (vertico-count  10)
  (vertico-cycle  t)
  :init (vertico-mode))

(use-package marginalia
  :init (marginalia-mode))

(use-package embark
  :bind
  (("C-`"    . embark-act)
   ("C-;"    . embark-dwim)
   ("C-h B"  . embark-bindings)))

(use-package embark-consult)

(use-package orderless
  :custom
  (completion-styles            '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :bind
  (("C-f"    . consult-line)
   ("C-S-f"  . consult-ripgrep)
   ("C-S-o"  . consult-outline))
  :config
  (global-set-key (kbd "C-p")    #'project-find-file)
  (global-set-key (kbd "C-S-p")  #'project-switch-project))

(use-package corfu
  :bind
  ("C-SPC" . completion-at-point)
  (:map corfu-map
        ("TAB"      . corfu-next)
        ([tab]      . corfu-next)
        ("S-TAB"    . corfu-previous)
        ([backtab]  . corfu-previous))
  :custom
  (corfu-auto             t)
  (corfu-cycle            t)
  (corfu-auto-prefix      2)
  (corfu-quit-no-match    t)
  (corfu-auto-delay       0.25)
  (corfu-popupinfo-delay  0.5)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-history-mode)
  :config
  ;; Подсказки всегда моноширинным Iosevka (шрифт текста и подсказок — один).
  ;; Тема при смене перезаписывает лица, поэтому применяем и после enable-theme.
  (defun my/corfu-fonts (&rest _)
    (dolist (face '(corfu-default corfu-current corfu-popupinfo))
      (when (facep face)
        (set-face-attribute face nil :family "Iosevka Nerd Font"))))
  (my/corfu-fonts)
  (add-hook 'enable-theme-functions #'my/corfu-fonts))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'tempel-complete))

(use-package magit
  :custom (magit-diff-refine-hunk 'all)
  :bind ("C-x g" . magit-status))

(use-package docker
  :bind ("C-x d" . docker))

(use-package dirvish
  :custom
  (dirvish-quick-access-entries
   '(("h" "~/" "Home")
     ("d" "~/Downloads" "Downloads")
     ("p" "~/dev" "Projects")
     ("e" "~/.emacs.d/lisp" "Emacs config")))
  (dirvish-mode-line-format
   '(:left (sort symlink) :right (omit yank index)))
  (dirvish-attributes
   '(nerd-icons file-size collapse subtree-state vc-state git-msg))
  (dired-listing-switches
   "-l --almost-all --human-readable --group-directories-first --no-group")

  (dirvish-subtree-state-style 'nerd)
  (delete-by-moving-to-trash t)
  (dirvish-side-width 35)
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-auto-revert-buffer t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'top)
  (dired-create-destination-dirs 'ask)
  (dirvish-default-layout '(0 0.4 0.6))

  :bind
  (("C-c f"  . dirvish)
   ("C-c T"  . dirvish-side)
   :map dirvish-mode-map
   ("TAB"        . dirvish-subtree-toggle)   ; раскрыть / свернуть папку
   ("<backtab>"  . dirvish-subtree-up)       ; к родителю раскрытой папки
   ("h"          . dired-up-directory)       ; на уровень вверх
   ("l"          . dired-find-file)          ; войти в папку / открыть файл
   ("y"          . dirvish-yank-menu)        ; копировать / переместить / симлинк
   ("s"          . dirvish-quicksort))       ; сортировка
  :hook (dired-mode . dired-omit-mode)
  :init (dirvish-override-dired-mode))

(use-package vterm
  :commands vterm
  :custom
  (vterm-shell                  "/usr/bin/zsh")
  (vterm-max-scrollback         10000)
  (vterm-kill-buffer-on-exit    t)
  (vterm-always-compile-module  t)
  :bind (:map vterm-mode-map
              ("<escape>" . vterm-send-escape))   ; ESC уходит в шелл, а не в Emacs
  :config
  (add-to-list 'display-buffer-alist
               '("\\*vterm"
                 (display-buffer-at-bottom)
                 (window-height . 0.3))))

;; без `:after vterm': иначе пакет (и клавиши C-c t, C-t) появляются только
;; после ручного запуска vterm. Теперь клавиша сама подгружает пакет (autoload).
(use-package vterm-toggle
  :commands vterm-toggle
  :bind ("C-c t" . vterm-toggle))

(use-package multi-vterm
  :commands (multi-vterm multi-vterm-dedicated-toggle)
  :custom
  (multi-vterm-dedicated-window-height-percent 30)
  :bind (("C-t"    . multi-vterm-dedicated-toggle)   ; показать/спрятать терминал снизу
         ("C-S-t"  . multi-vterm)                    ; новый терминал
         :map vterm-mode-map
         ("C-t"    . multi-vterm-dedicated-toggle)
         ("C-S-t"  . multi-vterm)))

(use-package breadcrumb
  :init (breadcrumb-mode 1))

(use-package undo-fu
  :bind
  ("C-z"    . undo-fu-only-undo)
  ("C-S-z"  . undo-fu-only-redo))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package smartparens
  :config
  (require 'smartparens-config)
  (sp-pair "(" ")" :unless '(sp-point-after-word-p sp-point-before-word-p))
  (setq sp-pair-overlay-mode nil)
  (setq sp-cancel-autoskip-on-backward-movement t)
  :hook (prog-mode . smartparens-mode))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package drag-stuff
  :bind (("M-<up>"   . drag-stuff-up)
         ("M-<down>" . drag-stuff-down))
  :config (drag-stuff-global-mode))

;; Пиксельные иконки: все значки nerd-icons (подсказки, vertico, dired, строка состояния)
;; рисуются шрифтом Cozette. Поставьте его с патчем Nerd Font, иначе значков в нём мало:
;;   yay -S nerd-fonts-cozette-ttf ; fc-cache -fv ; (проверка: fc-list | grep -i cozette)
;; Если в Cozette нет нужного значка, Emacs сам возьмёт его из Symbols Nerd Font.
;; Вернуть обычные иконки: (setq my/icon-font-candidates nil) или удалить шрифт.
(defvar my/icon-font-candidates
  '("CozetteVector Nerd Font" "Cozette Nerd Font" "CozetteVector" "Cozette")
  "Семейства шрифта для иконок, по порядку; берётся первое установленное.")

(use-package nerd-icons
  :config
  (defun my/apply-icon-font (&rest _)
    (when (display-graphic-p)
      (when-let* ((fam (seq-find (lambda (f) (find-font (font-spec :family f)))
                                 my/icon-font-candidates)))
        (setq nerd-icons-font-family fam))))
  ;; в daemon шрифты видны только после создания первого кадра
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'my/apply-icon-font)
    (my/apply-icon-font)))
(use-package nerd-icons-corfu
  :after corfu
  :init
  ;; иконка в подсказках слишком близко к тексту: добавляем ещё один пробел после неё.
  ;; Нужен шире отступ — увеличьте число в make-string (или поставьте 2).
  (defvar my/corfu-icon-gap 1 "Сколько лишних пробелов между иконкой и текстом в подсказках.")
  (defun my/corfu-icon-formatter (metadata)
    "Обёртка над nerd-icons-corfu-formatter: иконка + дополнительный отступ."
    (when-let* ((fmt (nerd-icons-corfu-formatter metadata)))
      (lambda (cand)
        (when-let* ((icon (funcall fmt cand)))
          (concat icon (make-string my/corfu-icon-gap ?\s))))))
  (add-to-list 'corfu-margin-formatters #'my/corfu-icon-formatter))

(use-package nerd-icons-completion
  :after vertico
  :config (nerd-icons-completion-mode))

(use-package colorful-mode
  :config (global-colorful-mode))

(use-package diff-hl
  :init
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode)
  (diff-hl-show-hunk-mouse-mode))

(use-package spacious-padding
  :custom
  (spacious-padding-widths
   '(:internal-border-width 12 :right-divider-width 20 :fringe-width 8))
  :config (spacious-padding-mode 1))

(use-package zoom
  :custom
  (zoom-size '(0.618 . 0.618))
  (zoom-ignored-buffer-names '("*org-roam*"))   ; буфер backlinks не растягивать
  :init (zoom-mode))

(use-package ligature                   ; лигатуры (JetBrains Mono, Iosevka и др.)
  :config
  (ligature-set-ligatures 'prog-mode '("->" "=>" "!=" "==" ">=" "<=" "::" "&&" "||"))
  (global-ligature-mode t))

(use-package pulsar                     ; короткая подсветка строки при прыжках
  :custom
  (pulsar-pulse       t)
  (pulsar-delay       0.04)
  (pulsar-iterations  10)
  (pulsar-face        'pulsar-magenta)
  :init
  (pulsar-global-mode 1)
  :config
  (add-hook 'consult-after-jump-hook #'pulsar-pulse-line)
  (add-hook 'imenu-after-jump-hook   #'pulsar-recenter-top))

(defun my/add-cargo-bin-to-path ()
  "Добавить ~/.cargo/bin в exec-path и PATH (rust-analyzer, rustfmt, cargo и др.)."
  (let ((cargo-bin (expand-file-name "~/.cargo/bin")))
    (unless (member cargo-bin exec-path)
      (add-to-list 'exec-path cargo-bin)
      (setenv "PATH" (concat cargo-bin path-separator (getenv "PATH"))))))

(use-package glsl-mode                  ; шейдеры: .glsl .vert .frag .geom .comp
  :mode ("\\.glsl\\'" "\\.vert\\'" "\\.frag\\'" "\\.geom\\'" "\\.comp\\'")
  :hook (glsl-mode . (lambda ()
                       (setq-local indent-tabs-mode nil
                                   tab-width 4
                                   c-basic-offset 4)))
  :config
  ;; LSP: shader-language-server (cargo install shader_language_server)
  ;; Emacs из десктопа может не видеть ~/.cargo/bin, добавляем в exec-path
  (my/add-cargo-bin-to-path)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(glsl-mode . ("shader-language-server" "--stdio"))))
  (add-hook 'glsl-mode-hook #'eglot-ensure))

(use-package dimmer                     ; приглушает неактивные окна
  :custom
  (dimmer-fraction                0.25)
  (dimmer-watch-frame-focus-events nil)
  :config
  (dimmer-configure-org)
  (dimmer-configure-magit)
  (dimmer-mode 1))

(use-package helpful                    ; более подробная справка по функциям и переменным
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)))

;; --- PATH из оболочки ------------------------------------------------------
;; Emacs из десктопа/лаунчера не читает ~/.zshrc, поэтому не видит бинарники,
;; добавленные в PATH (rust-analyzer, cargo и др.). Копируем PATH из zsh.
;; Запуск zsh -l -i при каждом старте занимает сотни миллисекунд, поэтому результат
;; кешируется в shell-env-cache.el на неделю. Сбросить: M-x my/refresh-shell-env.
(use-package exec-path-from-shell
  :defer t
  :custom
  (exec-path-from-shell-arguments '("-l" "-i"))     ; читать и ~/.zshrc
  (exec-path-from-shell-variables '("PATH" "MANPATH" "CARGO_HOME" "RUSTUP_HOME")))

(defvar my/shell-env-cache (locate-user-emacs-file "shell-env-cache.el"))
(defvar my/shell-env-max-age (* 7 24 3600) "Срок жизни кеша окружения, секунд.")

(defun my/load-shell-env ()
  "Взять PATH и др. из оболочки (из кеша, если он свежий)."
  (if (and (file-exists-p my/shell-env-cache)
           (< (float-time (time-since (file-attribute-modification-time
                                       (file-attributes my/shell-env-cache))))
              my/shell-env-max-age))
      (progn
        (dolist (kv (with-temp-buffer
                      (insert-file-contents my/shell-env-cache)
                      (read (current-buffer))))
          (setenv (car kv) (cdr kv)))
        (setq exec-path (delete-dups
                         (append (split-string (or (getenv "PATH") "") path-separator t)
                                 exec-path))))
    (require 'exec-path-from-shell)
    (exec-path-from-shell-initialize)
    (with-temp-file my/shell-env-cache
      (prin1 (mapcar (lambda (v) (cons v (getenv v)))
                     exec-path-from-shell-variables)
             (current-buffer)))))

(defun my/refresh-shell-env ()
  "Сбросить кеш окружения и перечитать PATH из оболочки."
  (interactive)
  (when (file-exists-p my/shell-env-cache) (delete-file my/shell-env-cache))
  (my/load-shell-env)
  (message "PATH обновлён из оболочки"))

(when (or (daemonp) (display-graphic-p))
  (my/load-shell-env))

;; --- Грамматики tree-sitter ------------------------------------------------
;; Один раз: M-x treesit-install-language-grammar RET c   (и rust). Нужны gcc и сеть.
(with-eval-after-load 'treesit
  (dolist (src '((c    "https://github.com/tree-sitter/tree-sitter-c")
                 (rust "https://github.com/tree-sitter/tree-sitter-rust")
                 (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
                 (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
                 (json "https://github.com/tree-sitter/tree-sitter-json")))
    (add-to-list 'treesit-language-source-alist src)))

;; --- C: c-ts-mode, отступ 8 (табы, стиль Linux kernel) ---------------------
;; Сам по себе Emacs открывает .c/.h в старом c-mode: ts-режимы нужно включать
;; явно. .h считаем C-файлами; для C++ заголовков (.hpp/.cpp) режим не менялся.
(setq major-mode-remap-alist
      (append '((c-mode          . c-ts-mode)
                (c-or-c++-mode   . c-or-c++-ts-mode))
              major-mode-remap-alist))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-ts-mode))

(use-package c-ts-mode
  :ensure nil                           ; встроен в Emacs
  :custom
  (c-ts-mode-indent-offset 8)
  (c-ts-mode-indent-style  'linux)
  :hook (c-ts-mode . (lambda ()
                       (setq-local indent-tabs-mode t   ; табы, как в ядре
                                   tab-width 8
                                   fill-column 80))))

;; --- Автоформат при сохранении (apheleia) ---------------------------------
;; Асинхронно форматирует буфер при сохранении, курсор остаётся на месте.
;; Формат берётся по режиму: C → clang-format, Rust → rustfmt, elisp → отступы и т. д.
;; Нужны: sudo pacman -S clang  (clang-format). Если в проекте есть .clang-format —
;; используется он; иначе стиль ниже (табы по 8, фигурные скобки как в Linux).
;; Выключить в буфере: M-x apheleia-mode; глобально: (apheleia-global-mode -1).
(defvar my/clang-format-fallback-style
  "{BasedOnStyle: LLVM, IndentWidth: 8, TabWidth: 8, UseTab: Always, ColumnLimit: 80, BreakBeforeBraces: Linux, AllowShortIfStatementsOnASingleLine: false, AllowShortLoopsOnASingleLine: false, IndentCaseLabels: false}"
  "Стиль clang-format, если в проекте нет .clang-format.")

(defun my/clang-format-style-arg ()
  "Аргумент -style: файл проекта, если есть, иначе запасной стиль."
  (if (or (locate-dominating-file default-directory ".clang-format")
          (locate-dominating-file default-directory "_clang-format"))
      "-style=file"
    (concat "-style=" my/clang-format-fallback-style)))

(use-package apheleia
  :config
  (setf (alist-get 'clang-format apheleia-formatters)
        '("clang-format"
          "-assume-filename"
          (or (apheleia-formatter-local-buffer-file-name)
              filepath
              (apheleia-formatters-mode-extension)
              ".c")
          (my/clang-format-style-arg)))
  (apheleia-global-mode +1))

;; --- Rust --------------------------------------------------------------------
;; Нужны (Arch): sudo pacman -S rustup && rustup default stable
;;               rustup component add rust-analyzer rustfmt clippy
;; rust-ts-mode — встроенный режим на tree-sitter (подсветка, отступы). Нужна
;;                 грамматика: M-x treesit-install-language-grammar RET rust
;;                 (нужны gcc и интернет) или пакет tree-sitter-rust;
;; eglot      — LSP (rust-analyzer): подсказки, переход (M-.), диагностика, inlay hints;
;; apheleia   — форматирование (rustfmt) при сохранении, см. раздел «Автоформат» выше;
;; cargo      — команды cargo на C-c C-c: C-b build, C-r run, C-t test, C-k check, C-l clippy.
(use-package rust-ts-mode
  :ensure nil                           ; встроен в Emacs
  :mode "\\.rs\\'"
  :custom
  (rust-ts-mode-indent-offset 4)
  :init
  (my/add-cargo-bin-to-path)
  :hook ((rust-ts-mode . eglot-ensure)
         (rust-ts-mode . (lambda ()
                           (setq-local indent-tabs-mode nil   ; глобально у вас tab-ы
                                       fill-column 100)))))

(use-package cargo
  :hook (rust-ts-mode . cargo-minor-mode))

(with-eval-after-load 'eglot
  ;; скорость: не ждать подключения к серверу, не вести журнал событий (он сильно
  ;; раздувается), не показывать прогресс, закрывать сервер вместе с последним буфером
  (setq eglot-sync-connect       nil
        eglot-autoshutdown       t
        eglot-report-progress    nil
        eglot-events-buffer-size 0                    ; Emacs 29
        eglot-events-buffer-config '(:size 0 :format full)) ; Emacs 30+
  (setq eldoc-idle-delay 0.3)
  ;; проверка при сохранении через clippy вместо обычного cargo check
  (setq-default eglot-workspace-configuration
                '(:rust-analyzer (:check (:command "clippy"))))
  (define-key eglot-mode-map (kbd "C-c l r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c l a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c l f") #'eglot-format)
  (define-key eglot-mode-map (kbd "C-c l d") #'flymake-show-buffer-diagnostics))

;; --- TRAMP: удалённые файлы и org-babel на других машинах ------------------------
;; Файлы:      C-x C-f /ssh:user@host:/путь/файл   (sudo: /sudo::/etc/hosts,
;;             через хост с sudo: /ssh:host|sudo:host:/etc/hosts)
;; Org-babel:  заголовок :dir выполняет блок на удалённой машине (шаблон <ssh):
;;               #+begin_src sh :dir /ssh:user@host:~/ :results output
;;               uname -a
;;               #+end_src
;;             Работает для sh, python и других языков, которые запускают процесс;
;;             :dir можно задать и на весь файл: #+PROPERTY: header-args :dir /ssh:host:~/
;; Пароли: лучше ключи ssh + ssh-agent; иначе ~/.authinfo.gpg (auth-source).
(use-package tramp
  :ensure nil
  :custom
  (tramp-default-method          "ssh")               ; быстрее, чем scp по умолчанию
  (tramp-verbose                 1)                   ; меньше шума в *Messages*
  (tramp-connection-timeout      15)
  ;; одно ssh-соединение переиспользуется (ControlMaster): новые команды без пароля
  (tramp-use-connection-share    nil)                 ; соединением управляет сам ssh
  (tramp-ssh-controlmaster-options
   "-o ControlMaster=auto -o ControlPath=tramp.%%C -o ControlPersist=10m")
  (remote-file-name-inhibit-cache 60)                 ; кешировать листинги на 60 с
  (enable-remote-dir-locals      t)                   ; .dir-locals.el на удалённых машинах
  (tramp-auto-save-directory     (locate-user-emacs-file "tramp-autosave/"))
  :config
  ;; vc на удалённых каталогах очень медленный — отключаем
  (setq vc-ignore-dir-regexp
        (format "\\(%s\\)\\|\\(%s\\)" vc-ignore-dir-regexp tramp-file-name-regexp)))

;; --- подсказки по клавишам --------------------------------------------------
;; which-key встроен в Emacs 30: после префикса (C-c, C-x ...) показывает, что дальше
(use-package which-key
  :ensure nil
  :custom
  (which-key-idle-delay        0.6)
  (which-key-sort-order        #'which-key-key-order-alpha)
  (which-key-max-description-length 40)
  :init (which-key-mode 1))

;; --- проверка орфографии: jinx (русский + английский) -----------------------
;; Подчёркивает ошибки только в тексте, комментариях и строках; код в org-блоках
;; пропускает. M-$ — исправить слово, C-M-$ — выбрать языки.
;; Нужны (Arch): sudo pacman -S enchant hunspell-ru hunspell-en_us pkgconf gcc
;; (модуль jinx соберётся при первом запуске).
(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$"   . jinx-correct)
         ("C-M-$" . jinx-languages))
  :custom
  (jinx-languages "ru_RU en_US"))

;; --- вкладки: tab-bar-mode ----------------------------------------------------
;; Встроенные вкладки (набор окон на вкладку). Основные клавиши (префикс C-x t):
;;   C-x t 2 — новая вкладка, C-x t 0 — закрыть, C-x t o — следующая,
;;   C-x t r — переименовать, C-x t p / C-x t C-p — проект в новой вкладке,
;;   C-x t u — вернуть закрытую. Панель видна, только когда вкладок больше одной.
(use-package tab-bar
  :ensure nil
  :custom
  (tab-bar-show                1)
  (tab-bar-close-button-show   nil)
  (tab-bar-new-button-show     nil)
  (tab-bar-tab-hints           t)                     ; номера на вкладках
  (tab-bar-new-tab-choice      "*scratch*")
  (tab-bar-select-tab-modifiers '(meta))              ; M-1 … M-9 — перейти на вкладку
  :init
  (tab-bar-mode 1)
  (tab-bar-history-mode 1))                           ; история окон: C-c <left>/<right>

(defun my/tab-bar-faces (&rest _)
  "Цвета вкладок в палитре tokyo-night."
  (dolist (spec '((tab-bar          :background "#16161e" :foreground "#565f89")
                  (tab-bar-tab      :background "#1a1b26" :foreground "#7aa2f7" :weight bold
                                    :box nil)
                  (tab-bar-tab-inactive :background "#16161e" :foreground "#565f89"
                                    :box nil)))
    (when (facep (car spec))
      (apply #'set-face-attribute (car spec) nil (cdr spec)))))

(my/tab-bar-faces)
(add-hook 'enable-theme-functions #'my/tab-bar-faces)   ; смена темы перезаписывает лица

;; --- KDL (конфиг niri и др.) -------------------------------------------------
(use-package kdl-mode
  :mode "\\.kdl\\'")

;; --- строка состояния: doom-modeline --------------------------------------------
;; Иконки (nerd-icons), имя файла, git, LSP, ошибки, число слов в org-заметках.
;; Справа дополнительно показывается заголовок (#+title) заметки: имя файла у roam —
;; это временная метка, по нему трудно понять, что открыто.
(use-package doom-modeline
  :custom
  (doom-modeline-height                      28)
  (doom-modeline-bar-width                   4)
  (doom-modeline-icon                        t)
  (doom-modeline-buffer-file-name-style      'truncate-upto-project)
  (doom-modeline-minor-modes                 nil)
  (doom-modeline-buffer-encoding             nil)   ; не показывать UTF-8 и т. п.
  (doom-modeline-enable-word-count           t)
  (doom-modeline-continuous-word-count-modes '(org-mode markdown-mode text-mode))
  (doom-modeline-vcs-max-length              24)
  :init (doom-modeline-mode 1))

;; Иконки строки состояния рисуются шире своей ячейки и налезают на следующий текст
;; (путь к файлу оказывается под иконкой). Добавляем после каждой иконки пробелы.
(defvar my/modeline-icon-gap 1 "Сколько пробелов добавлять после иконки в строке состояния.")

(defun my/modeline-icon-pad (icon)
  "Фильтр результата doom-modeline-icon: иконка + дополнительный отступ."
  (if (and (stringp icon) (not (string-empty-p icon)) (> my/modeline-icon-gap 0))
      (concat icon (make-string my/modeline-icon-gap ?\s))
    icon))

(with-eval-after-load 'doom-modeline
  (advice-add 'doom-modeline-icon :filter-return #'my/modeline-icon-pad))

(defvar-local morg--title-cache nil "(ТИК . ЗАГОЛОВОК) — чтобы не искать #+title при каждой отрисовке.")

(defun morg--note-title ()
  "Заголовок заметки (#+title) для org-буфера; пересчитывается только при изменении текста."
  (let ((tick (buffer-chars-modified-tick)))
    (unless (eq (car morg--title-cache) tick)
      (setq morg--title-cache
            (cons tick
                  (save-excursion
                    (save-restriction
                      (widen)
                      (goto-char (point-min))
                      (when (re-search-forward "^#\\+title:[ \t]*\\(.*\\)$"
                                               (min (point-max) 2000) t)
                        (match-string-no-properties 1)))))))
    (cdr morg--title-cache)))

(defun morg--modeline-note ()
  (when (derived-mode-p 'org-mode)
    (when-let* ((title (morg--note-title))
                ((not (string-empty-p title))))
      (propertize (concat " ✎ " (truncate-string-to-width title 32 nil nil "…") " ")
                  'face '(:foreground "#7dcfff")))))

(add-to-list 'global-mode-string '(:eval (morg--modeline-note)) t)

;; --- статистика запуска и учёт времени -----------------------------------------
(defun my/emacs-stats ()
  "Показать время запуска и сколько пакетов/библиотек загружено."
  (interactive)
  (message "Emacs: запуск %s · пакетов активно: %d · библиотек загружено: %d · аптайм %s"
           (emacs-init-time) (length package-activated-list) (length features)
           (emacs-uptime)))

;; В режиме демона emacs-startup-hook срабатывает при запуске демона, когда окна ещё нет,
;; и сообщение пропадает. Поэтому в демоне показываем статистику один раз, при открытии
;; первого фрейма через emacsclient (с небольшой задержкой, чтобы эхо-область успела
;; появиться). Вручную в любой момент: M-x my/emacs-stats.
(defun my/emacs-stats-once ()
  (remove-hook 'server-after-make-frame-hook #'my/emacs-stats-once)
  (run-with-timer 0.5 nil #'my/emacs-stats))

(if (daemonp)
    (add-hook 'server-after-make-frame-hook #'my/emacs-stats-once)
  (add-hook 'emacs-startup-hook #'my/emacs-stats))

;; ActivityWatch — локальный аналог WakaTime: время по проектам, файлам и языкам,
;; простой (AFK) отдельно; все данные остаются на машине (http://localhost:5600).
;; Arch (AUR): yay -S activitywatch-bin, затем запустить aw-server и aw-watcher-afk
;; (aw-qt поднимает всё сразу). На Wayland watcher окон и AFK может не работать:
;; активность редактирования Emacs всё равно считается плагином ниже.
(use-package activity-watch-mode
  :custom
  (activity-watch-api-host "127.0.0.1")
  (activity-watch-api-port 5600)
  :config
  (global-activity-watch-mode))

;; --- sideline: ошибки и действия прямо справа от строки ---------------------------
;; Ошибки и предупреждения компилятора (flymake) и доступные исправления/действия LSP
;; (eglot) показываются справа от строки, на которой стоит курсор. Включается сам,
;; когда в буфере работает flymake или eglot (Rust, C). Документация по hover
;; (eldoc) по-прежнему выводится в эхо-области; плавающее окно для неё — eldoc-box.
(use-package sideline
  :hook ((flymake-mode        . sideline-mode)
         (eglot-managed-mode  . sideline-mode))
  :custom
  (sideline-delay                 0.2)
  (sideline-display-backend-name  nil)
  (sideline-truncate              t)
  (sideline-backends-right        '(sideline-flymake sideline-eglot)))

(use-package sideline-flymake :after sideline)
(use-package sideline-eglot   :after (sideline eglot))

;; --- стартовый экран ---------------------------------------------------------------
;; Недавно изменённые заметки roam, недавние файлы, внизу — время запуска и число
;; пакетов. Работает и в обычном запуске, и в emacsclient (daemon).
(defvar my/dashboard-roam-dir "~/syn/org/roam/")

(defun my/dashboard--title (file)
  "#+title: заметки FILE (читаются первые 2000 байт) или имя файла."
  (with-temp-buffer
    (insert-file-contents file nil 0 2000)
    (goto-char (point-min))
    (if (re-search-forward "^#\\+title:[ \t]*\\(.+\\)$" nil t)
        (match-string 1)
      (file-name-base file))))

(defvar my/dashboard--roam-files nil "Файлы заметок на экране; n1 = первый.")
(defvar my/dashboard--recent-files nil "Недавние файлы на экране; r1 = первый.")

(defun my/dashboard--insert-item (prefix idx file label)
  "Строка вида «n1  LABEL»; клик или клавиши PREFIX+IDX открывают FILE."
  (insert "    ")
  (insert (propertize (format "%s%d " prefix idx) 'face 'font-lock-comment-face))
  (widget-create 'push-button
                 :action (lambda (&rest _) (find-file file))
                 :mouse-face 'highlight
                 :button-prefix "" :button-suffix ""
                 :format "%[%t%]"
                 label)
  (insert "\n"))

(defun my/dashboard-insert-roam (list-size)
  "Секция: LIST-SIZE недавно изменённых заметок roam (n1, n2, …)."
  (dashboard-insert-heading "Недавние заметки (n1…):")
  (insert "\n")
  (setq my/dashboard--roam-files nil)
  (let ((dir (expand-file-name my/dashboard-roam-dir)))
    (if (not (file-directory-p dir))
        (insert "    (каталог заметок не найден)")
      (let* ((stamped (mapcar (lambda (f)
                                (cons (file-attribute-modification-time (file-attributes f)) f))
                              (directory-files-recursively dir "\\.org\\'")))
             (sorted (seq-take (sort stamped (lambda (a b) (time-less-p (car b) (car a))))
                               (min list-size 9)))
             (i 0))
        (dolist (entry sorted)
          (let ((f (cdr entry)))
            (setq i (1+ i))
            (push f my/dashboard--roam-files)
            (my/dashboard--insert-item "n" i f (my/dashboard--title f))))
        (setq my/dashboard--roam-files (nreverse my/dashboard--roam-files))))))

(use-package recentf
  :ensure nil
  :custom (recentf-max-saved-items 100)
  :config (recentf-mode 1))

(defun my/dashboard-insert-recent (list-size)
  "Секция: LIST-SIZE недавних файлов (r1, r2, …)."
  (dashboard-insert-heading "Недавние файлы (r1…):")
  (insert "\n")
  (setq my/dashboard--recent-files nil)
  (let ((files (seq-take (seq-filter (lambda (f)
                                       (and (not (file-remote-p f)) (file-exists-p f)))
                                     (bound-and-true-p recentf-list))
                         (min list-size 9)))
        (i 0))
    (if (null files)
        (insert "    (пока пусто)")
      (dolist (f files)
        (setq i (1+ i))
        (push f my/dashboard--recent-files)
        (my/dashboard--insert-item "r" i f (abbreviate-file-name f)))
      (setq my/dashboard--recent-files (nreverse my/dashboard--recent-files)))))

(defun my/dashboard-open (kind idx)
  "Открыть элемент IDX (с 1) списка KIND: `roam' или `recent'."
  (let ((f (nth (1- idx) (if (eq kind 'roam)
                             my/dashboard--roam-files
                           my/dashboard--recent-files))))
    (if f (find-file f) (message "Нет элемента с номером %d" idx))))

(use-package dashboard
  :demand t
  :custom
  (dashboard-center-content        t)
  (dashboard-startup-banner        'logo)
  (dashboard-banner-logo-title     "Emacs")
  (dashboard-set-heading-icons     nil)     ; без иконок: не зависим от шрифтов
  (dashboard-set-file-icons        nil)
  (dashboard-set-footer            t)
  :config
  (add-to-list 'dashboard-item-generators '(roam . my/dashboard-insert-roam))
  (add-to-list 'dashboard-item-generators '(my-recent . my/dashboard-insert-recent))
  (setq dashboard-items '((roam . 8) (my-recent . 5)))
  ;; n и r — префиксные клавиши: n1…n9 (заметки), r1…r9 (файлы)
  (define-key dashboard-mode-map "n" nil)
  (define-key dashboard-mode-map "r" nil)
  (dotimes (k 9)
    (let ((i (1+ k)))
      (define-key dashboard-mode-map (kbd (format "n%d" i))
                  (lambda () (interactive) (my/dashboard-open 'roam i)))
      (define-key dashboard-mode-map (kbd (format "r%d" i))
                  (lambda () (interactive) (my/dashboard-open 'recent i)))))
  ;; подвал: время запуска и число пакетов (считается после старта)
  (add-hook 'emacs-startup-hook
            (lambda ()
              (setq dashboard-footer-messages
                    (list (format "⏱ запуск %s · пакетов: %d"
                                  (emacs-init-time "%.2f с")
                                  (length package-activated-list))))))
  (dashboard-setup-startup-hook)
  ;; для emacsclient: «домашний» буфер нового кадра — этот экран
  (when (daemonp)
    (setq initial-buffer-choice
          (lambda () (get-buffer-create dashboard-buffer-name)))))

;; --- Markdown: просмотрщик ----------------------------------------------------------
;; .md-файлы открываются в режиме просмотра (markdown-view-mode): буфер только для чтения,
;; разметка спрятана (## , **, `…`, ссылки показываются текстом), заголовки крупнее,
;; блоки кода подсвечены языком и лежат на «карточке», картинки показываются, текст по
;; центру в колонке (olivetti). Клавиши в просмотре:
;;   e — перейти к правке (markdown-mode), в правке C-c v — обратно в просмотр
;;   TAB / S-TAB — свернуть/развернуть заголовок / все заголовки
;;   n / p — следующий / предыдущий заголовок;  q — закрыть буфер
(use-package olivetti
  :custom (olivetti-body-width 100))

(defun my/md--tint (fg amount)
  "Цвет FG, подмешанный в фон default на долю AMOUNT (0…1)."
  (let ((bg (or (face-background 'default nil 'default) "#1a1b26")))
    (apply #'color-rgb-to-hex
           (append (cl-mapcar (lambda (a b) (+ (* a amount) (* b (- 1 amount))))
                              (color-name-to-rgb fg) (color-name-to-rgb bg))
                   '(2)))))

(defun my/md-apply-faces (&rest _)
  "Оформление markdown под текущую тему (вызывается и после смены темы)."
  (when (facep 'markdown-code-face)
    (let ((card (my/md--tint "#7dcfff" 0.06)))
      (dolist (f '(markdown-code-face markdown-pre-face))
        (set-face-attribute f nil :background card :extend t))
      (set-face-attribute 'markdown-inline-code-face nil :background card)
      (set-face-attribute 'markdown-blockquote-face nil :slant 'italic :foreground "#9aa5ce")
      (set-face-attribute 'markdown-header-face-1 nil :weight 'bold :foreground "#7aa2f7")
      (set-face-attribute 'markdown-header-face-2 nil :weight 'bold :foreground "#bb9af7")
      (set-face-attribute 'markdown-header-face-3 nil :weight 'bold :foreground "#7dcfff")
      (set-face-attribute 'markdown-header-delimiter-face nil :foreground "#565f89"))))

(defun my/markdown-toggle-view ()
  "Переключить просмотр (только чтение) и правку текущего markdown-буфера."
  (interactive)
  (if (derived-mode-p 'markdown-view-mode)
      (markdown-mode)
    (markdown-view-mode)))

(use-package markdown-mode
  :mode ("\\.\\(md\\|markdown\\)\\'" . markdown-view-mode)
  :custom
  (markdown-hide-markup               t)
  (markdown-hide-urls                 t)
  (markdown-fontify-code-blocks-natively t)
  (markdown-header-scaling            t)
  (markdown-header-scaling-values     '(1.5 1.3 1.15 1.05 1.0 1.0))
  (markdown-list-item-bullets         '("●" "○" "◆" "◇"))
  (markdown-max-image-size            '(900 . 700))
  (markdown-display-remote-images     nil)
  (markdown-enable-highlighting-syntax t)
  :bind (:map markdown-view-mode-map
         ("e"     . my/markdown-toggle-view)
         ("q"     . quit-window)
         ("TAB"   . markdown-cycle)
         ("<backtab>" . markdown-shifttab)
         ("n"     . markdown-outline-next)
         ("p"     . markdown-outline-previous)
         :map markdown-mode-map
         ("C-c v" . my/markdown-toggle-view))
  :hook (markdown-view-mode . (lambda ()
                                (visual-line-mode 1)
                                (olivetti-mode 1)
                                (setq-local line-spacing 0.25)
                                (markdown-display-inline-images)))
  :config
  ;; для внешнего предпросмотра/экспорта (C-c C-c l): нужен pandoc
  (when (executable-find "pandoc")
    (setq markdown-command "pandoc -f gfm -t html5 --standalone"))
  (my/md-apply-faces)
  (add-hook 'enable-theme-functions #'my/md-apply-faces))

(provide 'plugins)
