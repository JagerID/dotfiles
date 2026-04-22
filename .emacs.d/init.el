(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(add-to-list 'load-path "~/.emacs.d/lisp/config/")
(add-to-list 'load-path "~/.emacs.d/lisp/plugins/")

(require 'common)
(require 'theme)
(require 'helpers)
(require 'cursor)
(require 'git)
(require 'completions)
(require 'lsp)
(require 'invisible-symbols)
(require 'space)
(require 'welcome)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(apheleia centaur-tabs consult corfu dashboard doom-modeline
			  doom-themes kind-icon magit marginalia nerd-icons
			  no-littering orderless projectile pulsar vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-newline ((t (:foreground "gray30"))))
 '(whitespace-tab ((t (:foreground "gray30"))))
 '(whitespace-trailing ((t (:background "gray30")))))

(add-variable-watcher 'tab-width
                      (lambda (sym newval op where)
                        (message "DEBUG: tab-width changed to %S via %S in %S" 
                                 newval op where)))
