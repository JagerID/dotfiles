;; -*- lexical-binding: t; -*-

;; Повышение порога GC
(setq gc-cons-threshold most-positive-fixnum)

;; Отключение UI элементов перед запуском
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

;; Отключение вычисления размера окна при запуске
(setq frame-inhibit-imlied-resize t)

;; Оптимизация компиляции пакетов (ускорение)
(setq native-comp-speed 3)
