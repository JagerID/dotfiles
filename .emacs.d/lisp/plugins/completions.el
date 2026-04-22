(use-package corfu
  :ensure t
  :bind
  (("C-SPC" . completion-at-point)
   :map corfu-map
   ("TAB" . corfu-next)
   ([tab] . corfu-next)
   ("S-TAB" . corfu-previous)
   ([backtab] . corfu-previous))
  :custom
  ((corfu-auto t)
   (corfu-auto-delay 0.1)
   (corfu-auto-prefix 2)
   (corfu-cycle t)
   (corfu-preselect 'prompt)
   (corfu-quit-at-boundary 'separator)
   (corfu-quit-no-match t)
   (corfu-preview-current 'insert))
  :config
  (setq corfu-popupinfo-delay 0.2)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-style
   '(:padding -0.1 :stroke 0 :margin 0 :radius 0 :height 0.75 :scale 1.0))
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package emacs
  :custom
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p))

(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'prog-mode-hook 'eglot-ensure)

(provide 'completions)
