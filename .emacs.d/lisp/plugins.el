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
   ("C-S-o"	.	consult-outline)))

(use-package marginalia
  :init (marginalia-mode))

(use-package magit
  :bind ("C-x g"	.	magit-status))

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
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-history-mode))

(use-package
  :config)

(provide 'plugins)
