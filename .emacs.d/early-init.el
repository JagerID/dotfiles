;; Отключение очистки памяти с помощью GC до старта
(setq gc-cons-threshold most-positive-fixnum)

;; Отключение проверки magic numbers
(setq file-name-handler-alist nil)

;; Отключение лишних UI элементов
(setq-default tool-bar-mode nil)
(setq-default menu-bar-mode nil)
(setq-default scroll-bar-mode nil)

;; Отключение расчета размера окна при запуске
(setq frame-inhibit-implied-resize t)

;; Отключение чтения .Xresources
(setq inhibit-x-resources t)
