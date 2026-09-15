;;; -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'pkg)
(require 'plugins)
(require 'common)
(require 'langs)
(require 'theme)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(breadcrumb cape colorful-mode corfu dap-mode diff-hl doom-themes
		drag-stuff embark-consult expand-region hl-todo
		info-colors magit marginalia multiple-cursors
		nerd-icons-completion nerd-icons-corfu orderless
		rainbow-delimiters realgud smartparens undo-fu vertico
		volatile-highlights)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
