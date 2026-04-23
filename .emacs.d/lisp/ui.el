;; Встроенные настройки
(setq-default display-line-numbers-type 'relative)
(setq-default display-line-numbers-current-absolute t)
(setq-default cursor-type 'bar)
(setq-default display-line-numbers-width 3)
(setq-default display-line-numbers-grow-only t)

(setq ring-bell-function 'ignore)
(setq inhibit-startup-screen t)

(global-display-line-numbers-mode 1)
(blink-cursor-mode -1)
(global-hl-line-mode 1)
(pixel-scroll-precision-mode 1)

(set-face-attribute 'default nil
		    :height 110
		    :font "Iosevka Nerd Font")

(set-window-fringes nil 0 0)

;; Пакеты
(use-package nerd-icons)

(use-package doom-themes
  :config
  (load-theme 'doom-molokai t))

(use-package pulsar
  :bind (:map global-map
              ("C-x l" . pulsar-pulse-line)
              ("C-x L" . pulsar-highlight-permanently-dwim))
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
