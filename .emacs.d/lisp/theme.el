;;; -*- lexical-binding: t; -*-

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (with-eval-after-load 'breadcrumb
  (set-face-attribute 'header-line nil
                      :background 'unspecified
                      :foreground "#bbc2cf"
                      :box nil))

(set-face-attribute 'default nil
		    :family "Iosevka Nerd Font"
		    :height 120)

(provide 'theme)
