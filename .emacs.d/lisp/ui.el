;;; ui.el --- ui settings  -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:
;; Modeline
(use-package doom-modeline
  :custom
  (doom-modeline-checkers t)
  (doom-modeline-lsp t)
  (doom-modeline-indent-info t)
  (doom-modeline-github t)
  (doom-modeline-icon-set 'nerd-icons)
  (doom-modeline-height 24)
  (doom-modeline-bar-width 4)
  (doom-modeline-minor-modes nil)
  :init
  (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Иконки
(use-package nerd-icons)
(use-package nerd-icons-completion ;; Для vertico
  :config
  (nerd-icons-completion-mode))

(use-package kind-icon ;; Для corfu
  :after corfu
  :custom
  (kind-icon-use-cache t)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package pulsar
  :bind
  ( :map global-map
    ("C-x l" . pulsar-pulse-line)
    ("C-x L" . pulsar-highlight-temporarily-dwim))
  :init
  (pulsar-global-mode 1)
  :config
  (setq pulsar-delay 0.055)
  (setq pulsar-iterations 5)
  (setq pulsar-face 'pulsar-green)
  (setq pulsar-region-face 'pulsar-yellow)
  (setq pulsar-highlight-face 'pulsar-magenta)

  (add-hook 'consult-after-jump-hook #'pulsar-recenter-top)
  (add-hook 'consult-after-jump-hook #'pulsar-reveal-entry))

;; Экранирующие символы и espace-последовательности
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

;; Менеджер файлов
(use-package dirvish
  :custom
  (dirvish-attributes '(nerd-icons file-size collapse git-msg))
  :config
  (setq dirvish-emerge-groups
	'(("Recent files" (predicate . recent-files-2h))
	  ("Documents" (extensions "pdf" "tex" "bib" "epub"))
	  ("Video" (extensions "mp4" "mkv" "webm"))
	  ("Pictures" (extensions "jpg" "png" "svg" "gif" "webp"))
	  ("Audio" (extensions "mp3" "flac" "wav" "ape" "aac"))
	  ("Archives" (extensions "gz" "rar" "zip"))))
  :bind
  (("C-x d" . dirvish)
   ("C-c f" . dirvish-side)
   :map dirvish-mode-map
   ("TAB" . dirvish-subtree-toggle)
   ("h" . dirvish-up-directory) ;; На уровень выше
   ("l" . dired-find-file) ;; На уровень ниже / войти в файл
   ("j" . dired-next-line) ;; Следующий файл
   ("k" . dired-previous-line) ;; Предыдущий
   ("s" . dirvish-setup-mode) ;; Меню настроек
   ("e" . dirvish-emerge-mode)
   ("M-e" . dirvish-emerge-menu)
   )
  :init
  (dirvish-override-dired-mode))

(use-package which-key
  :custom
  (which-key-idle-delay 0.7)
  :init
  (which-key-mode 1))

;; Подсветка цветов (hex, rgba etc)
(use-package colorful-mode
  :config
  (setq colorful-use-prefix t)
  (global-colorful-mode 1))

(use-package cognitive-complexity
  :hook (prog-mode . cognitive-complexity-mode))

(use-package helpful
  :config
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-h x") #'helpful-command)
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)
  (global-set-key (kbd "C-h F") #'helpful-function))

(use-package diff-hl
  :config
  (global-diff-hl-mode 1)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (diff-hl-dired-mode))

(use-package ultra-scroll
  :init
  (setq scroll-conservatively 101
	scroll-margin 0)
  :config
  (ultra-scroll-mode 1))

(use-package disproject
  :bind (("C-c p p" . disproject-dispatch)))

(provide 'ui)
;;; ui.el ends here
