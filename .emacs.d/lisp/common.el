;;; -*- lexical-binding: t; -*-

(setq-default cursor-type 'bar)

;; Режимы
(show-paren-mode)
(delete-selection-mode)
(global-auto-revert-mode)
(setq auto-revert-use-notify nil)
(setq global-auto-revert-non-file-buffers t)
(global-display-line-numbers-mode)
(global-visual-line-mode)
(setq auto-revert-verbose nil)
(global-hl-line-mode)
(column-number-mode)
(save-place-mode)
(savehist-mode)
(winner-mode)
;; (electric-pair-mode 1)
(setq history-length 50)
(setq warning-minimum-level :error)

;; Буфер обмена
(setq select-enable-clipboard t)
(setq save-interprogram-paste-before-kill t)

;; Табы
(setq-default indent-tabs-mode t)
(setq-default tab-width 8)

;; Подтверждение
(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-emacs 'y-or-n-p)

;; Бэкапы
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Кейбинды
(global-set-key (kbd "TAB") #'self-insert-command)
(global-set-key (kbd "<backspace>") #'backward-delete-char)
(global-set-key (kbd "RET") #'newline-and-indent)

;; Создание отсутствующих папок при сохранении файла (mkdir -p)
(add-hook 'before-save-hook
	  (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and dir (not (file-exists-p dir)))
                  (make-directory dir t))))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(provide 'common)
