(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)

  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts t)

  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)

  (setq dashboard-items '((recents . 5)
						  (projects . 5)
						  (bookmarks . 5)
						  (agenda . 5)))

  (setq dashboard-banner-logo-title "Welcome!")
  (setq dashboard-footer-icon (nerd-icons-faicon "nf-fa-rocket" :height 1.1 :v-adjust -0.05))

  (add-hook 'server-after-make-frame-hook 'dashboard-open))

(provide 'welcome)
