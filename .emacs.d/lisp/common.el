;; Отключение лишних элементов интерфейса

(set-fringe-mode 0) ;; Размер отступов по краям

(setq ring-bell-function 'ignore) ;; Отключение звука
(setq-default cursor-type 'bar)

;; Номера строк
(setq-default display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(line-number-mode 1)
(setq display-line-numbers-grow-only t)
(setq display-line-numbers-width-start t)

(delete-selection-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(winner-mode 1)
(global-hl-line-mode 1)
(setq create-lockfiles nil)

;; Скобки
(electric-pair-mode 1)
(setq electric-pair-preserve-balance t)

;; Файлы
(setq make-backup-files nil) ;; Отключение бекап-файлов (file.el~)
(setq auto-save-default nil) ;; Отключение автосейвов (#file.el#)
(setq create-lockfiles nil)
(global-auto-revert-mode 1) ;; Обновлять буфер, если файл был изменен
(setq global-auto-revert-non-file-buffers t) ;; .. dired (dirvish в том числе)

;; Стили колонки с номерами строк
(set-face-attribute 'line-number nil
		    :background 'unspecified
		    :foreground "#555555")

(set-face-attribute 'line-number-current-line nil
		    :background 'unspecified
		    :foreground "#ffaa00"
		    :weight 'bold)

(set-face-attribute 'fringe nil
		    :background 'unspecified)

(provide 'common)
