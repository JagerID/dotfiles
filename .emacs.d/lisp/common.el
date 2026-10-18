;;; early-init.el --- generated from config.org -*- lexical-binding: t -*-

(defun make-missing-dirs ()
  (when buffer-file-name
    (let ((dir (file-name-directory buffer-file-name)))
      (when (and dir (not (file-exists-p dir)))
	(make-directory dir t)))))


(defun trim-whitespace ()
  (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))

(use-package emacs
  :ensure nil
  :custom
  (cursor-type				'bar)
  (truncate-lines				t)
  (indent-tabs-mode				t)
  (tab-width					8)
  (history-length				50)
  (use-short-answer				t)
  (confirm-kill-emacs				'y-or-n-p)

  (save-interprogram-paste-before-kill	t)

  (create-lockfiles				nil)
  (make-backup-files				nil)
  (auto-save-default				nil)
  (auto-revert-use-notify			nil)
  (auto-revert-verbose			nil)
  (global-auto-revert-non-file-buffers	t)

  (custom-file		(expand-file-name "custom.el" user-emacs-directory))
  
  (read-process-output-max	(* 1024 1024))
  :hook
  ((after-init	.	show-paren-mode)
   (after-init	.	delete-selection-mode)
   (after-init	.	global-auto-revert-mode)
   (after-init	.	global-hl-line-mode)
   (after-init	.	column-number-mode)
   (after-init	.	save-place-mode)
   (after-init	.	savehist-mode)
   (after-init	.	winner-mode)
   (after-init	.	global-so-long-mode)
   (before-save	.	make-missing-dirs)
   (prog-mode		.	display-line-numbers-mode)
   (prog-mode		.	trim-whitespace))
  :bind
  (("TAB"		.	self-insert-command))
  :config
  (load	custom-file 'noerror)
  (define-key	key-translation-map (kbd "ESC") (kbd "C-g")))

(provide 'common)
