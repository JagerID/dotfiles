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
 '(package-selected-packages
   '(apheleia cape colorful-mode consult consult-projectile corfu diff-hl
	      dirvish drag-stuff flycheck-inline flycheck-posframe
	      gcmh kanagawa-themes kind-icon magit-todos marginalia
	      orderless projectile rainbow-delimiters smartparens
	      undo-fu vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
