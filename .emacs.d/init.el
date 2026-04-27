;; Подключение папок с конфигами
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(setq use-package-always-ensure t)
(unless package-archive-contents
  (package-refresh-contents))

(require 'theme)
(require 'common)
(require 'editing)
(require 'ui)

;; Возобновление работы GC и обработчиков имен файлов
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq file-name-handler-alist temp-file-name-handler-alist)
	    (setq gc-const-threshold (* 16 1024 1024))
	    (makunbound 'temp-file-name-handler-alist) ;; Очистка временной переменной
	    ;; Опционально: выводим время загрузки в сообщения
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2fs" (float-time (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; (custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
'(custom-safe-themes
  '("0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1"
    default))
'(package-selected-packages
  '(apheleia cape colorful-mode consult corfu dirvish doom-modeline
	     doom-themes embark embark-consult ember-theme
	     ember-twilight-theme kind-icon magit marginalia
	     nerd-icons nerd-icons-completion nerd-icons-corfu
	     orderless pulsar solo-jazz-theme treesit treesit-auto
	     vertico))
'(package-vc-selected-packages
  '((ember-theme :url "https://github.com/ember-theme/emacs")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("19d62171e83f2d4d6f7c31fc0a6f437e8cec4543234f0548bad5d49be8e344cd"
     "0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1"
     "3613617b9953c22fe46ef2b593a2e5bc79ef3cc88770602e7e569bbd71de113b"
     default))
 '(package-selected-packages
   '(apheleia avy cape colorful-mode corfu dirvish doom-modeline
	      embark-consult ember-theme ember-twilight-theme evil
	      flycheck-posframe kind-icon magit marginalia
	      nerd-icons-completion nerd-icons-corfu orderless popup
	      projectile pulsar rainbow-delimiters solo-jazz-theme
	      svelte-mode treesit-auto vertico vterm web-mode)))
