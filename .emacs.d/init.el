(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp/config/")
(add-to-list 'load-path "~/.emacs.d/lisp/plugins/")

(add-hook 'emacs-startup-hook
		  (lambda () (setq gc-cons-threshold (* 100 1024 1024))))

(require 'common)
(require 'theme)
(require 'helpers)
(require 'cursor)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(doom-themes pulsar)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
