;; -*- lexical-binding: t; -*

(setq make-backup-files nil)
(setq create-lockfiles nil)

(fset 'yes-or-no-p 'y-or-n-p)
(setq-default indent-tabs-mode t)

(global-set-key (kbd "<backspace>") 'backward-delete-char)
(global-set-key (kbd "TAB") 'self-insert-command)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

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

(provide 'other)
