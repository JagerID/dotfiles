;;; early-init.el --- generated from config.org -*- lexical-binding: t -*-

(setq inhibit-startup-screen		t
      frame-inhibit-implied-resize	t
      ring-bell-function		'ignore
      debug-on-error			t)

(menu-bar-mode		-1)
(tool-bar-mode		-1)
(scroll-bar-mode	-1)

(setq gc-cons-threshold (* 1024 1024 1024))
(add-hook 'emacs-startup-hook
	  (lambda () (setq gc-cons-threshold (* 1024 1024 1024))))
