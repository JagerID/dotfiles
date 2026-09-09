;;; -*- lexical-binding: t; -*-

;; Режимы
(show-paren-mode)
(delete-selection-mode)
(global-auto-revert-mode)
(setq global-auto-revert-non-file-buffers t)
(global-display-line-numbers-mode)
(global-visual-line-mode)
(global-auto-revert-mode)
(setq auto-revert-verbose nil)
(global-hl-line-mode)
(column-number-mode)
(save-place-mode)
(savehist-mode)
(winner-mode)
;; (electric-pair-mode 1)
(setq history-length 50)

;; Буфер обмена
(setq select-enable-clipboard t)
(setq save-interprogram-paste-before-kill t)

;; Табы
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)

;; Подтверждение
(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-emacs 'y-or-n-p)

;; Бэкапы
(defvar emacs-backup-dir (expand-file-name "backups/" user-emacs-directory))
(setq backup-directory-alist `(("." . ,emacs-backup-dir))
	  backup-by-copying t
	  version-control t
	  kept-old-versions 2
	  kept-new-versions 5
	  delete-old-versions t)
(setq create-lockfiles nil)

;; Автогенерируемые emacs'ом файлы
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Скролл
(setq scroll-step 1
      scroll-conservatively 101
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil)

;; Создание отсутствующих папок при сохранении файла (mkdir -p)
(add-hook 'before-save-hook
		  (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and dir (not (file-exists-p dir)))
                  (make-directory dir t))))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(provide 'common)
