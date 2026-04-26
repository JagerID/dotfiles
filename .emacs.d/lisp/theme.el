;; Тема
;; (add-to-list 'custom-theme-load-path "~/.config/doom/themes/ember/")
;; (load-theme 'ember t)

;;; Code:
(use-package doom-themes
  :config
  (load-theme 'doom-bluloco-light t))

(defun customize-theme ()
  (set-face-attribute 'font-lock-keyword-face nil
		      :foreground "#ff79c6"
		      :background nil)
  (set-face-attribute 'font-lock-function-name-face nil
		      :foreground "#50fa7b"
		      :weight 'bold)
  (set-face-attribute 'font-lock-function-call-face nil
		      :foreground "#8be9fd")
  (set-face-attribute 'font-lock-builtin-face nil
		      :foreground "#ea9e8d")
  (set-face-attribute 'font-lock-type-face nil
		      :foreground "#8be8c8")
  (set-face-attribute 'font-lock-variable-name-face nil
		      :foreground "#82d173")
  )

(customize-theme)
(advice-add 'load-theme :after (lambda (&rest _) (customize-theme)))

(provide 'theme)
;;; theme.el ends here
