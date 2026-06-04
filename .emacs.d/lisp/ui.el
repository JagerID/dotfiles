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
  :config (vertico-mode 1))

;; Сохранение истории ввода
(use-package savehist
  :config (savehist-mode 1))

;; Описание команд в минибуффере
(use-package marginalia
  :config (marginalia-mode 1))

;; Отображение подсказок по хоткеям
(use-package which-key
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
  :bind ("C-c p" . projectile-command-map)
  :config (projectile-mode 1))

(provide 'ui)
