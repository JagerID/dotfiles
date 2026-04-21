(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullcolumn-most-v1))
