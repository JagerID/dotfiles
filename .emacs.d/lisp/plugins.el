;;; -*- lexical-binding: t; -*-

(use-package vertico
  :custom
  (vertico-count	10)
  (vertico-cycle	t)
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles				'(orderless basic))
  (completion-category-defaults		nil)
  (completion-category-overrides	'((file (styles partial-completion)))))

(use-package consult
  :bind
  (("C-f"	.	consult-line)
   ("C-S-f"	.	consult-ripgrep)
   ("C-S-o"	.	consult-outline))
  :config
  (global-set-key (kbd "C-p") #'project-find-file)
  (global-set-key (kbd "C-S-p") #'project-switch-project))

(use-package marginalia
  :init (marginalia-mode))

(use-package magit
  :bind ("C-x g"	.	magit-status))

(use-package breadcrumb
  :init (breadcrumb-mode 1))

(use-package undo-fu
  :bind
  ("C-z"	.	undo-fu-only-undo)
  ("C-S-z"	.	undo-fu-only-redo))

(use-package corfu
  :bind
  ("C-SPC" . completion-at-point)
  (:map corfu-map
		("TAB"		.	corfu-next)
		([tab]		.	corfu-next)
		("S-TAB"	.	corfu-previous)
		([backtab]	.	corfu-previous))
  :custom
  (corfu-auto			t)
  (corfu-cycle			t)
  (corfu-auto-prefix	2)
  (corfu-quit-no-match	t)
  (corfu-auto-delay		0.25)
  (setq corfu-popupinfo-delay 0.5)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-history-mode))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package smartparens
  :config
  (require 'smartparens-config)
  (sp-pair "(" ")" :unless '(sp-point-after-word-p sp-point-before-word-p))
  (setq sp-pair-overlay-mode nil)
  (setq sp-cancel-autoskip-on-backward-movement t)
  :hook (prog-mode . smartparens-mode))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(defun my/mc-mark-next-dwim ()
  "Выделить слово под курсором или добавить следующее вхождение."
  (interactive)
  (if (region-active-p)
      (mc/mark-next-like-this 1)
    ;; Если регион не активен, выделяем только слово
    (let ((bounds (bounds-of-thing-at-point 'word)))
      (if bounds
          (progn
	    (goto-char (car bounds))
            (set-mark (cdr bounds))
            (activate-mark))
        ;; Если курсор не на слове, просто подаем сигнал
        (message "No symbol at point")))))

(use-package multiple-cursors
  :bind
  (("C-d"		.	my/mc-mark-next-dwim)
   ("C-S-d"		.	mc/unmark-next-like-this)
   ("C-c C-d"	.	mc/mark-all-like-this))
  :config
  (with-eval-after-load 'multiple-cursors
  (add-to-list 'mc/cmds-to-run-for-all 'corfu-next)
  (add-to-list 'mc/cmds-to-run-for-all 'corfu-previous)))

(use-package drag-stuff
  :bind (
	 ("M-<up>" . drag-stuff-up)
	 ("M-<down>" . drag-stuff-down))
  :config (drag-stuff-global-mode))

(use-package nerd-icons)
(use-package nerd-icons-corfu
  :after corfu
  :init (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-completion
  :after vertico
  :config (nerd-icons-completion-mode))

(use-package colorful-mode
  :config (global-colorful-mode))

(use-package embark
  :bind
  (("C-`"	.	embark-act)
   ("C-;"	.	embark-dwim)
   ("C-h B"	.	embark-bindings)))

;; (use-package diff-hl
;;   :init (global-diff-hl-mode))

(use-package dap-mode
  :hook (lsp-mode	. dap-mode)
  :config
  (require 'dap-gdb-lldb)
  (dap-auto-configure-mode)
  (require 'dap-ui)
  (dap-ui-mode)
  (dap-tooltip-mode)
  (tooltip-mode)
  (dap-ui-controls-mode))

;; (use-package whitespace
;;   :hook (prog-mode . whitespace-mode)
;;   :config
;;   (setq whitespace-style
;; 	'(face
;; 	  tabs
;; 	  spaces
;; 	  trailing
;; 	  newline
;; 	  tab-mark
;; 	  newline-mark))
;;   (setq whitespace-display-mappings
;; 	'((tab-mark ?\t [?> ?\t])
;;           (newline ?\n [?↲ ?\n])
;;           (space-mark ?\xA0 [?␣]))))

(use-package embark-consult)

(use-package zoom
  :config
  (setq zoom-size '(0.618 . 0.618))
  :init (zoom-mode))

(provide 'plugins)
