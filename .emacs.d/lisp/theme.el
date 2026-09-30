;;; -*- lexical-binding: t; -*-

(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-tokyo-night t))

(set-face-attribute 'default nil
                    :family "Iosevka Nerd Font"
                    :height 120)

(provide 'theme)
