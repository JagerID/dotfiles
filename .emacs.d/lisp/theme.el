;;; theme.el --- theme settings  -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

;; Тема
;; (add-to-list 'custom-theme-load-path "~/.config/doom/themes/ember/")
;; (load-theme 'ember t)

;;; Code:
(use-package doom-themes
  :config
  (load-theme 'doom-molokai t))

(defun customize-theme ()
  ;; (set-face-attribute 'whitespace-tab nil
  ;; 		      :foreground "#525252")
  ;; (set-face-attribute 'whitespace-newline nil
  ;; 		      :foreground "#525252")
  )

(customize-theme)
(advice-add 'load-theme :after (lambda (&rest _) (customize-theme)))

(provide 'theme)
;;; theme.el ends here
