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

  ;; --- SVG: svg-mode ------------------------------------------------------------------
  ;; Отдельного пакета svg-mode нет, поэтому режим собран здесь: SVG — это XML, так что режим
  ;; наследует встроенный nxml-mode (подсветка, закрытие тегов, проверка разметки) и добавляет:
  ;;   - живой предпросмотр справа: обновляется через полсекунды после правки; если XML
  ;;     сломан, остаётся последняя удачная картинка, а в шапке окна — текст ошибки;
  ;;   - цвета вида #7dcfff подсвечиваются своим цветом (rainbow-mode);
  ;;   - C-c C-p — показать/убрать предпросмотр, C-c C-b — сменить фон предпросмотра
  ;;     (белый → серый → тёмный; на тёмном фоне чёрные иконки не видно),
  ;;   - C-c C-c — посмотреть файл как картинку (image-mode), там же C-c C-c вернёт в текст.
  ;; Нужна поддержка SVG в Emacs (librsvg): проверка — (image-type-available-p 'svg).
  (use-package rainbow-mode
    :commands rainbow-mode)

  (defvar svg-mode-big-size 300000
    "Файл больше стольких символов считается большим: без автопредпросмотра и подсветки цветов.")

  (defvar svg-mode-backgrounds '("#ffffff" "#c0c0c0" "#1a1b26")
    "Фоны предпросмотра, по кругу (C-c C-b).")
  (defvar svg-mode-wrap-attrs "auto"
    "Атрибуты внешнего <svg> для фрагмента без своего корня (C-c C-a).
\"auto\" — viewBox вычисляется по координатам x/y/x1/y1/cx/cy/r/width/height в коде;
пути (path d=…) при вычислении не учитываются — для них задайте viewBox вручную.")
  (defvar-local svg-mode-auto-wrap t
    "Не-nil: если в буфере нет корневого <svg>, предпросмотр оборачивает код в него.
Файл не меняется — оборачивается только то, что видно справа. Переключение: C-c C-w.")
  (defvar-local svg-mode--bg-index 0)
  (defvar-local svg-mode--preview nil "Буфер предпросмотра этого svg-буфера.")
  (defvar-local svg-mode--timer nil)

  (defun svg-mode--auto-attrs (text)
    "Атрибуты viewBox/width/height по рамке, в которую попадают координаты из TEXT."
    (let (xs ys lastx lasty)
      (with-temp-buffer
        (insert text)
        (goto-char (point-min))
        (while (re-search-forward
                "[ \t\n]\\(x1\\|x2\\|cx\\|x\\|y1\\|y2\\|cy\\|y\\|width\\|height\\|r\\)=[\"']\\(-?[0-9]*\\.?[0-9]+\\)"
                nil t)
          (let ((k (match-string 1)) (v (string-to-number (match-string 2))))
            (pcase k
              ((or "x" "x1" "x2" "cx") (setq lastx v) (push v xs))
              ((or "y" "y1" "y2" "cy") (setq lasty v) (push v ys))
              ("width"  (when lastx (push (+ lastx v) xs)))
              ("height" (when lasty (push (+ lasty v) ys)))
              ("r" (when (and lastx lasty)
                     (push (- lastx v) xs) (push (+ lastx v) xs)
                     (push (- lasty v) ys) (push (+ lasty v) ys)))))))
      (if (or (null xs) (null ys))
          "viewBox=\"0 0 100 100\" width=\"100\" height=\"100\""
        (let* ((pad 2)
               (x0 (- (apply #'min xs) pad)) (y0 (- (apply #'min ys) pad))
               (w (max 1 (+ (- (apply #'max xs) (apply #'min xs)) (* 2 pad))))
               (h (max 1 (+ (- (apply #'max ys) (apply #'min ys)) (* 2 pad)))))
          (format "viewBox=\"%s %s %s %s\" width=\"%s\" height=\"%s\""
                  x0 y0 w h w h)))))

  (defun svg-mode--payload (text)
    "TEXT для отрисовки. Убирает \\\" (скопировано из JSON-строки); если включено
автообрамление и корня <svg> нет — оборачивает."
    (let ((text (replace-regexp-in-string "\\\\\"" "\"" text t t)))
      (if (and svg-mode-auto-wrap
               (not (string-match-p "<svg[[:space:]>/]" text)))
          (concat "<svg xmlns=\"http://www.w3.org/2000/svg\" "
                  "xmlns:xlink=\"http://www.w3.org/1999/xlink\" "
                  (if (equal svg-mode-wrap-attrs "auto")
                      (svg-mode--auto-attrs text)
                    svg-mode-wrap-attrs)
                  ">\n" text "\n</svg>")
        text)))

  (defun svg-mode-unescape ()
    "Заменить в буфере \\\" на \" (текст, скопированный из JSON-строки)."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (let ((n 0))
        (while (search-forward "\\\"" nil t) (replace-match "\"" t t) (setq n (1+ n)))
        (message "Исправлено вхождений: %d" n))))

  ;; Масштаб и сдвиг предпросмотра. zoom = 1.0 — «вписать в окно»; сдвиг ox/oy — какая часть
  ;; увеличенной картинки видна (показывается срез картинки размером с окно).
  (defvar-local svg-mode--zoom 1.0)
  (defvar-local svg-mode--ox 0)
  (defvar-local svg-mode--oy 0)
  (defvar-local svg-mode--fit 1.0 "Масштаб «вписать в окно» с прошлой отрисовки.")

  (defvar-local svg-mode--error nil "Текст ошибки разбора SVG или nil.")

  (defun svg-mode--update (buf)
    "Перерисовать предпросмотр для svg-буфера BUF."
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (let ((pb svg-mode--preview))
          (when (and (buffer-live-p pb) (get-buffer-window pb))
            (let* ((win  (get-buffer-window pb))
                   (ww   (max 50 (- (window-body-width win t) 4)))
                   (wh   (max 50 (- (window-body-height win t) 4)))
                   (data (svg-mode--payload
                          (buffer-substring-no-properties (point-min) (point-max))))
                   (bg   (nth svg-mode--bg-index svg-mode-backgrounds)))
              (condition-case err
                  (let* ((img0 (create-image data 'svg t :background bg))
                         (size (image-size img0 t)) ; здесь разбор падает, если SVG некорректен
                         (fit  (min (/ (float ww) (max 1 (car size)))
                                    (/ (float wh) (max 1 (cdr size)))))
                         (scale (* fit svg-mode--zoom))
                         (iw (round (* (car size) scale)))
                         (ih (round (* (cdr size) scale)))
                         (img (create-image data 'svg t :background bg :scale scale)))
                    (setq svg-mode--fit fit
                          svg-mode--error nil)
                    ;; сдвиг не должен выводить за край картинки
                    (setq svg-mode--ox (max 0 (min svg-mode--ox (max 0 (- iw ww))))
                          svg-mode--oy (max 0 (min svg-mode--oy (max 0 (- ih wh)))))
                    (with-current-buffer pb
                      (let ((inhibit-read-only t))
                        (erase-buffer)
                        (if (or (> iw ww) (> ih wh))
                            (insert-image img nil nil
                                          (list (buffer-local-value 'svg-mode--ox buf)
                                                (buffer-local-value 'svg-mode--oy buf)
                                                (min iw ww) (min ih wh)))
                          (insert-image img)))
                      (set-window-hscroll win 0)
                      (force-mode-line-update)))
                (error
                 (setq svg-mode--error (error-message-string err))
                 (with-current-buffer pb (force-mode-line-update))))))))))

  (defun svg-mode--pan (buf dx dy)
    "Сдвинуть видимую часть предпросмотра BUF на DX, DY пикселей."
    (with-current-buffer buf
      (setq svg-mode--ox (+ svg-mode--ox dx)
            svg-mode--oy (+ svg-mode--oy dy))
      (svg-mode--update buf)))

  (defun svg-mode--zoom-by (buf factor)
    "Умножить масштаб BUF на FACTOR, сохраняя в центре окна ту же точку картинки."
    (with-current-buffer buf
      (when-let ((win (and (buffer-live-p svg-mode--preview)
                           (get-buffer-window svg-mode--preview))))
        (let* ((ww (window-body-width win t)) (wh (window-body-height win t))
               (old (* svg-mode--fit svg-mode--zoom))
               (cx (/ (+ svg-mode--ox (/ ww 2.0)) old))
               (cy (/ (+ svg-mode--oy (/ wh 2.0)) old))
               (z (max 0.1 (min 50.0 (* svg-mode--zoom factor))))
               (new (* svg-mode--fit z)))
          (setq svg-mode--zoom z
                svg-mode--ox (round (- (* cx new) (/ ww 2.0)))
                svg-mode--oy (round (- (* cy new) (/ wh 2.0)))))
        (svg-mode--update buf))))

  (defun svg-mode--zoom-reset (buf)
    (with-current-buffer buf
      (setq svg-mode--zoom 1.0 svg-mode--ox 0 svg-mode--oy 0)
      (svg-mode--update buf)))

  (defun svg-mode-zoom-in ()    (interactive) (svg-mode--zoom-by (current-buffer) 1.25))
  (defun svg-mode-zoom-out ()   (interactive) (svg-mode--zoom-by (current-buffer) 0.8))
  (defun svg-mode-zoom-reset () (interactive) (svg-mode--zoom-reset (current-buffer)))

  ;; --- режим буфера предпросмотра: клавиши и мышь -------------------------------------
  (defvar-local svg-preview--source nil "svg-буфер, которому принадлежит этот предпросмотр.")

  (defmacro svg-preview--cmd (name doc &rest body)
    "Команда NAME в буфере предпросмотра; в BODY доступна переменная src."
    (declare (indent 2))
    `(defun ,name (&optional _e)
       ,doc (interactive)
       (when (buffer-live-p svg-preview--source)
         (let ((src svg-preview--source)) ,@body))))

  (svg-preview--cmd svg-preview-zoom-in  "Приблизить." (svg-mode--zoom-by src 1.25))
  (svg-preview--cmd svg-preview-zoom-out "Отдалить."   (svg-mode--zoom-by src 0.8))
  (svg-preview--cmd svg-preview-fit      "Вписать в окно." (svg-mode--zoom-reset src))
  (svg-preview--cmd svg-preview-left     "Сдвиг влево."  (svg-mode--pan src -60 0))
  (svg-preview--cmd svg-preview-right    "Сдвиг вправо." (svg-mode--pan src 60 0))
  (svg-preview--cmd svg-preview-up       "Сдвиг вверх."  (svg-mode--pan src 0 -60))
  (svg-preview--cmd svg-preview-down     "Сдвиг вниз."   (svg-mode--pan src 0 60))
  (svg-preview--cmd svg-preview-bg "Сменить фон."
    (with-current-buffer src (svg-mode-cycle-background)))
  (svg-preview--cmd svg-preview-refresh "Перерисовать." (svg-mode--update src))

  (defun svg-preview-drag (event)
    "Перетаскивание картинки мышью (зажать левую кнопку и двигать)."
    (interactive "e")
    (when (buffer-live-p svg-preview--source)
      (let ((src svg-preview--source)
            (last (posn-x-y (event-start event))) ev)
        (track-mouse
          (while (progn (setq ev (read-event)) (mouse-movement-p ev))
            (let ((cur (posn-x-y (event-start ev))))
              (when (and cur last (consp cur) (consp last))
                (svg-mode--pan src (- (car last) (car cur)) (- (cdr last) (cdr cur)))
                (setq last cur))))))))

  (defun svg-preview--header ()
    "Шапка окна предпросмотра: масштаб (или ошибка разбора SVG)."
    (let ((src svg-preview--source))
      (if (not (buffer-live-p src))
          ""
        (let ((err (buffer-local-value 'svg-mode--error src))
              (z   (buffer-local-value 'svg-mode--zoom src)))
          (if err
              (propertize (format " ошибка SVG: %s" err) 'face 'error)
            (format " %d%%   + − 0 — масштаб, колесо и перетаскивание — сдвиг" (round (* 100 z))))))))

  (defvar-keymap svg-preview-mode-map
    :parent special-mode-map
    "+" #'svg-preview-zoom-in   "=" #'svg-preview-zoom-in
    "-" #'svg-preview-zoom-out  "0" #'svg-preview-fit
    "<left>" #'svg-preview-left   "h" #'svg-preview-left
    "<right>" #'svg-preview-right "l" #'svg-preview-right
    "<up>" #'svg-preview-up       "k" #'svg-preview-up
    "<down>" #'svg-preview-down   "j" #'svg-preview-down
    "b" #'svg-preview-bg  "g" #'svg-preview-refresh
    "<wheel-up>" #'svg-preview-up     "<wheel-down>" #'svg-preview-down
    "<wheel-left>" #'svg-preview-left "<wheel-right>" #'svg-preview-right
    "C-<wheel-up>" #'svg-preview-zoom-in "C-<wheel-down>" #'svg-preview-zoom-out
    "<down-mouse-1>" #'svg-preview-drag)

  (define-derived-mode svg-preview-mode special-mode "SVG-просмотр"
    "Предпросмотр SVG: приближение, отдаление и сдвиг."
    (setq cursor-type nil
          header-line-format '(:eval (svg-preview--header))))

  (defun svg-mode--schedule (&rest _)
    "После правки: перерисовать предпросмотр через 0.5 с простоя."
    (when (timerp svg-mode--timer) (cancel-timer svg-mode--timer))
    (when (buffer-live-p svg-mode--preview)
      (setq svg-mode--timer
            (run-with-idle-timer (if (< (buffer-size) svg-mode-big-size) 0.5 2.0)
                                 nil #'svg-mode--update (current-buffer)))))

  (defun svg-mode-preview ()
    "Показать предпросмотр справа или убрать его, если он уже виден."
    (interactive)
    (unless (image-type-available-p 'svg)
      (user-error "Эта сборка Emacs не умеет показывать SVG (нет librsvg)"))
    (let ((pb (if (buffer-live-p svg-mode--preview)
                  svg-mode--preview
                (setq svg-mode--preview
                      (let ((src (current-buffer)))
                        (with-current-buffer (generate-new-buffer
                                              (format "*svg: %s*" (buffer-name)))
                          (svg-preview-mode)
                          (setq svg-preview--source src)
                          (current-buffer)))))))
      (if-let ((win (get-buffer-window pb)))
          (delete-window win)
        (display-buffer-in-side-window
         pb '((side . right) (slot . 0) (window-width . 0.4)
              (window-parameters . ((no-delete-other-windows . t)))))
        (svg-mode--update (current-buffer)))))

  (defun svg-mode-cycle-background ()
    "Сменить фон предпросмотра."
    (interactive)
    (setq svg-mode--bg-index (mod (1+ svg-mode--bg-index) (length svg-mode-backgrounds)))
    (svg-mode--update (current-buffer)))

  (defun svg-mode--update-name ()
    (setq mode-name (if svg-mode-auto-wrap "SVG+обёртка" "SVG"))
    (force-mode-line-update))

  (defun svg-mode-toggle-wrap ()
    "Включить/выключить автообрамление фрагмента внешним <svg> в предпросмотре."
    (interactive)
    (setq svg-mode-auto-wrap (not svg-mode-auto-wrap))
    (svg-mode--update-name)
    (svg-mode--update (current-buffer))
    (message "Автообрамление <svg>: %s" (if svg-mode-auto-wrap "включено" "выключено")))

  (defun svg-mode-set-wrap-attrs (attrs)
    "Задать атрибуты внешнего <svg> для автообрамления, например viewBox и размер."
    (interactive (list (read-string "Атрибуты <svg>: " svg-mode-wrap-attrs)))
    (setq svg-mode-wrap-attrs attrs)
    (svg-mode--update (current-buffer)))

  (defun svg-mode-view-image ()
    "Показать файл как картинку (image-mode); C-c C-c там возвращает текст."
    (interactive)
    (image-mode))

  (defun svg-mode--auto-open (buf)
    "Открыть предпросмотр для BUF, когда буфер уже показан в окне (вызывается таймером)."
    (when (and (buffer-live-p buf) (get-buffer-window buf)
               (display-graphic-p) (image-type-available-p 'svg))
      (with-current-buffer buf
        (when (and (derived-mode-p 'svg-mode)
                   (not (buffer-live-p svg-mode--preview))
                   (< (buffer-size) svg-mode-big-size))
          (with-demoted-errors "svg-mode: предпросмотр: %S"
            (svg-mode-preview))))))

  (define-derived-mode svg-mode nxml-mode "SVG"
    "XML-режим для SVG с живым предпросмотром."
    ;; nxml по умолчанию проверяет SVG по схеме RELAX NG: на реальных файлах это очень
    ;; медленно и подвешивает Emacs. Проверку выключаем (flymake/предпросмотр и так покажут ошибку).
    (setq-local rng-nxml-auto-validate-flag nil)
    (add-hook 'after-change-functions #'svg-mode--schedule nil t)
    (svg-mode--update-name)
    (add-hook 'kill-buffer-hook
              (lambda ()
                (when (buffer-live-p svg-mode--preview)
                  (when-let ((w (get-buffer-window svg-mode--preview))) (delete-window w))
                  (kill-buffer svg-mode--preview)))
              nil t)
    ;; предпросмотр — не сейчас, а когда буфер уже показан в окне (иначе размер окна неизвестен,
    ;; а в демоне кадра может ещё не быть)
    (run-with-idle-timer 0.3 nil #'svg-mode--auto-open (current-buffer)))

  (add-hook 'svg-mode-hook
            (lambda ()
              ;; хуки родителя nxml-mode выполняются раньше этого — отключаем проверку после них
              (when (and (boundp 'rng-validate-mode) rng-validate-mode)
                (rng-validate-mode -1))
              (when (< (buffer-size) svg-mode-big-size)
                (rainbow-mode 1))))

  (define-key svg-mode-map (kbd "C-c C-p") #'svg-mode-preview)
  (define-key svg-mode-map (kbd "C-c C-b") #'svg-mode-cycle-background)
  (define-key svg-mode-map (kbd "C-c C-c") #'svg-mode-view-image)
  (define-key svg-mode-map (kbd "C-c C-w") #'svg-mode-toggle-wrap)
  (define-key svg-mode-map (kbd "C-c C-a") #'svg-mode-set-wrap-attrs)
  (define-key svg-mode-map (kbd "C-c C-u") #'svg-mode-unescape)
  (define-key svg-mode-map (kbd "C-c C-+") #'svg-mode-zoom-in)
  (define-key svg-mode-map (kbd "C-c C-=") #'svg-mode-zoom-in)
  (define-key svg-mode-map (kbd "C-c C--") #'svg-mode-zoom-out)
  (define-key svg-mode-map (kbd "C-c C-0") #'svg-mode-zoom-reset)

  (add-to-list 'auto-mode-alist '("\\.svgz?\\'" . svg-mode))
  ;; #+begin_src svg в org подсвечивается этим же режимом
  (with-eval-after-load 'org
    (setf (alist-get "svg" org-src-lang-modes nil nil #'equal) 'svg))

  (provide 'plugins)
