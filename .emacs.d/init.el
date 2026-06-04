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
   '("be0d9f0e72a4ebc4a59c382168921b082b4dc15844bdaf1353c08157806b3321"
     default))
 '(package-selected-packages
   '(apheleia cape citre colorful-mode consult consult-flycheck corfu
	      diff-hl dirvish doom-themes drag-stuff flycheck-posframe
	      gcmh kanagawa-themes kind-icon magit-todos marginalia
	      orderless projectile rainbow-delimiters smartparens
	      undo-fu vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
