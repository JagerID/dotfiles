;; -*- lexical-binding: t -*-

;; Отступы по бокам (для git diff например)
(set-fringe-mode 10)

;; Использовать табы
(setq-default indent-tabs-mode t)
(setq-default tabs-width 4)

(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(setq column-number-mode t)

;; Удалять выделенный текст при печати
(setq column-number-mode t)

(provide 'ui)
