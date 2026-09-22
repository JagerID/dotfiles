;;; -*- lexical-binding: t; -*-

(use-package treesit
  :ensure nil
  :config
  (setq major-mode-remap-alist
	'((c-mode	.	c-ts-mode)
	  (c++-mode	.	c++-ts-mode)
	  (lua-mode	.	lua-ts-mode))))

(use-package eglot
  :ensure nil
  :hook
  ((c-ts-mode		. eglot-ensure)
   (c++-ts-mode		. eglot-ensure)
   (lua-ts-mode		. eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect nil)
  (eglot-ignored-server-capabilities
   '(:documentOnTypeFormattingProvider
     :documentRangeFormattingProvider)))

(use-package eldoc-box
  :hook (eldoc-mode	. eldoc-box-hover-mode))

(defun my/format-before-save ()
  (when (eglot-managed-p)
    (eglot-format-buffer)))

(add-hook 'c-ts-mode-hook
	  (lambda ()
	    (setq c-ts-mode-indent-style 'k&r)
	    (setq c-ts-mode-indent-offset 8)
	    (add-hook 'before-save-hook #'my/format-before-save nil t)))

(add-hook 'lua-ts-mode-hook
	  (lambda ()
	    (setq lua-ts-indent-offset 8)))

(provide 'langs)
