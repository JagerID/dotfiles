;; -*- lexical-binding: t; -*-

;; Возврат GC
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq gc-cons-threshold (* 2 1024 1024))))

;; Подключение папок с конфигами
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(setq use-package-verbose t)
(setq use-package-always-ensure t)
(unless package-archive-contents (package-refresh-contents))

(require 'theme)
(require 'ui)
(require 'other)
(require 'prog)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("a60b04e5c0fef30209f9576f04651938472b57cb1dae0375d80a53a78f515f69"
     "be0d9f0e72a4ebc4a59c382168921b082b4dc15844bdaf1353c08157806b3321"
     default))
 '(package-selected-packages
   '(apheleia cape colorful-mode consult-dir consult-flycheck consult-jq
	      corfu diff-hl dirvish doom-themes drag-stuff
	      flycheck-posframe gcmh kanagawa-themes kind-icon
	      magit-todos marginalia multiple-cursors orderless
	      projectile rainbow-delimiters sleek-modeline smartparens
	      undo-fu vertico))
 '(package-vc-selected-packages
   '((consult-jq :vc-backend Git :url
		 "https://github.com/bigbuger/consult-jq")
     (maple-modeline :vc-backend Git :url
		     "https://github.com/honmaple/emacs-maple-modeline")
     (emacs :vc-backend Git :url
	    "https://github.com/ember-theme/emacs")
     (ember-theme :url "https://github.com/ember-theme/emacs"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
