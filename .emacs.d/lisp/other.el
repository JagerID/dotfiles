;; -*- lexical-binding: t; -*

(setq make-backup-files nil)
(setq create-lockfiles nil)
(setq auto-save-default nil)

(fset 'yes-or-no-p 'y-or-n-p)
(setq-default indent-tabs-mode t)
(add-hook 'prog-mode-hook (lambda () (flymake-mode nil)))

(global-eldoc-mode -1)
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(electric-indent-mode 1)
(cua-mode 1)

(global-set-key (kbd "<backspace>") 'backward-delete-char)
(global-set-key (kbd "TAB") 'self-insert-command)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq-default toggle-truncate t)
(setq-default truncate-lines t)

(setq-default display-line-numbers-grow-only t)
(setq-default display-line-numbers-width 3)
(setq-default long-line-threshold 1000)

;; Нормальные undo / redo
(use-package undo-fu
  :bind(
	("C-/" . undo-fu-only-undo)
	("C-S-/" . undo-fu-only-redo)))

;; Хак для GC
(use-package gcmh
  :config (gcmh-mode 1))

;; Перемещение строк
(use-package drag-stuff
  :bind (
	 ("M-<up>" . drag-stuff-up)
	 ("M-<down>" . drag-stuff-down))
  :config (drag-stuff-global-mode 1))

(use-package multiple-cursors
  :bind (
	 ("C-d" . mc/mark-next-like-this-word)
	 ("C-S-d" . mc/mark-previous-like-this-word)
	 ("C-c C-<" . mc/mark-all-like-this)

	 ;; :map mc/keymap
	 ;; ("<escape>" . mc/keyboard-quit)
	 ;; ("<return>" . nil)
	 )
  :config
  (setq mc/always-run-for-all t))

(provide 'other)
