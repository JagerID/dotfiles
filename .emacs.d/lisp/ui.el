;; -*- lexical-binding: t; -*-

(setq-default display-line-numbers-type 'relative)
(setq display-line-numbers-grow-only t)
(setq display-line-numbers-width-start t)

(global-display-line-numbers-mode 1)
(column-number-mode 1)
(line-number-mode 1)
(delete-selection-mode 1)
(winner-mode 1)
(global-hl-line-mode 1)

(set-fringe-mode 7) ;; Отступы по краям

(setq-default cursor-type 'bar)

;; Git клиент
(use-package magit
  :bind ("C-x g" . magit-status))

;; Отображение TODOs в magit
(use-package magit-todos
  :after magit
  :config (magit-todos-mode 1))

(use-package hl-todo
  :config
  (with-eval-after-load 'magit
    (add-hook 'magit-log-wash-summary-hook
              #'hl-todo-search-and-highlight t)
    (add-hook 'magit-revision-wash-message-hook
              #'hl-todo-search-and-highlight t))
  (hl-todo-mode 1))

;; TODO:

;; Разноцветные скобки
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Подсветка цветов (hex, rgba, etc.)
(use-package colorful-mode
  :config (global-colorful-mode 1))

;; Подсветка измененных строк (git)
(use-package diff-hl
  :config
  (global-diff-hl-mode 1)
  (diff-hl-dired-mode 1))

(use-package dirvish
  :config (dirvish-override-dired-mode 1))

;; Вертикальный список вариантов
(use-package vertico
  :custom (vertico-cycle 1)
  :config (vertico-mode 1))

;; (use-package vertico-multiform
;;   :ensure nil
;;   :after vertico
;;   :config (vertico-multiform-mode 1))

;; (use-package vertico-posframe
;;   :after vertico
;;   :config (vertico-posframe-mode 1))

;; Сохранение истории ввода
(use-package savehist
  :config (savehist-mode 1))

;; Описание команд в минибуффере
(use-package marginalia
  :config (marginalia-mode 1))

;; Отображение подсказок по хоткеям
(use-package which-key
  :init
  (setq which-key-allow-regexps nil)
  :config (which-key-mode 1))

(use-package consult-flycheck
  :bind ("C-S-m" . consult-flycheck))

;; Улучшенные команды поиска, переключения буффера и т.п.
(use-package consult
  :bind (("C-f" . consult-line) ;; Поиск внутри текущего файла (с предпросмотром)
	 ("C-S-f" . consult-ripgrep) ;; Поиск текста во всем проекте
	 ("C-p" . projectile-find-file) ;; Поиск файла
	 ("C-S-o" . consult-outline))
  :init
  (setq consult-ripgrep-command
	"rg --null --hidden --smart-case --no-heading --line-number --color=always -e ARG OPTS")
  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref)
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-function (lambda (_) (projectile-project-root))))

(use-package consult-dir
  :ensure t
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(use-package consult-jq
  :ensure nil)

;; Умные скобки
(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config (require 'smartparens-config))

;; Автодополнения
(use-package corfu
  :bind ("C-SPC" . completion-at-point)
  (:map corfu-map
	("TAB" . corfu-next)
	([tab] . corfu-next)
	("S-TAB" . corfu-previous)
	([backtab] . corfu-previous)
	("M-SPC" . corfu-insert-separator))
  :init
  (global-corfu-mode 1)
  (corfu-history-mode 1)
  (corfu-popupinfo-mode 1)
  (corfu-indexed-mode 1)
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.25)
  (corfu-auto-prefix 2)
  (corfu-popupinfo-delay nil))

;; Источники данных для автодополнения corfu
(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-file) ;; Пути к файлам
  (add-to-list 'completion-at-point-functions #'cape-dabbrev) ;; Слова из текущего буфера
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-elisp-symbol)) ;; Ключевые слова языка

;; Без учета позиции слов в поиске
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  (completion-pcm-leading-wildcard t))

;; Отображение текста ошибки во всплыващем окне
(use-package flycheck
  :config
  (global-flycheck-mode 1)
  (setq eldoc-echo-area-use-multiline-p nil)
  (setq eldoc-documentation-strategy #'eldoc-documentation-default))

(use-package flycheck-posframe
  :after flycheck
  :hook (flycheck-mode . flycheck-posframe-mode))

;; Иконки для автодополнения
(use-package kind-icon
  :after corfu
  :config (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Проекты
(use-package projectile
  :bind (
	 ("C-c p" . projectile-command-map)
	 ("M-?" . projectile-find-references))
  :config (projectile-mode 1))

;; Modeline
(use-package sleek-modeline
  :config (sleek-modeline-mode 1))

(use-package whitespace
  :hook (prog-mode . whitespace-mode)
  :config
  (setq whitespace-style
	'(face
	  tabs
	  spaces
	  trailing
	  newline
	  tab-mark
	  newline-mark))
  (setq whitespace-display-mappings
	'((tab-mark ?\t [?> ?\t])
          (newline ?\n [?↲ ?\n])
          (space-mark ?\xA0 [?␣]))))

(provide 'ui)
