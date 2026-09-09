;;; -*- lexical-binding: t; -*-

(setq inhibit-startup-screen t)
(setq frame-inhibit-implied-resize t)
(setq ring-bell-function 'ignore)
(setq debug-on-error t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq gc-cons-threshold (* 1024 1024 1024))
(add-hook 'emacs-startup-hook
	  (lambda () (setq gc-cons-threshold (* 1024 1024 1024))))
