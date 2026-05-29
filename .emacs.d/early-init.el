;; -*- lexical-binding: t; -*-

;; Повышение порога для GC
(setq gc-cons-threshold most-positive-fixnum)

;; Отключение UI элементов
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Отключение расчета размера окна перед запуском
(setq frame-inhibit-implied-resize t)

;; Оптимизация компиляции плагинов
(setq native-comp-speed 3)
