;;; early-init.el --- generated from config.org -*- lexical-binding: t -*-

(setq inhibit-startup-screen    t
      frame-inhibit-implied-resize t
      ring-bell-function        'ignore)

(menu-bar-mode    -1)
(tool-bar-mode    -1)
(scroll-bar-mode  -1)

;; лёгкая прозрачность фона окна (Emacs 29+, pgtk/Wayland); текст остаётся чётким
(add-to-list 'default-frame-alist '(alpha-background . 95))

;; на время загрузки GC отключён, после старта возвращаем разумное значение
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 64 1024 1024))))
