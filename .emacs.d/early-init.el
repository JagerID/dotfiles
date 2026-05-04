;;; -*- lexical-binding: t; -*-

;; Повышение порога для GC (фактиччески отключение GC на старте)
(setq gc-cons-threshold most-positive-fixnum)

;; Отключение проверки magic numbers файлов
(defvar temp-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Отключение UI элементов перед запуском
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Отключение расчета размера окна при запуске
(setq frame-inhibit-implied-resize t)

(setq native-comp-speed 2)
