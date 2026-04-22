(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-monokai-classic t))

(with-eval-after-load 'doom-themes
  (set-face-attribute 'line-number nil
					  :background 'unspecified)
  (set-face-attribute 'line-number-current-line nil
					  :background 'unspecified)
  (set-face-attribute 'fringe nil
					  :background 'unspecified))

(provide 'theme)
