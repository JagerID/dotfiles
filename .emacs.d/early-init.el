;;; early-init.el --- generated from config.org -*- lexical-binding: t -*-

(setq inhibit-startup-screen    t
      frame-inhibit-implied-resize t
      ring-bell-function        'ignore)

(menu-bar-mode    -1)
(tool-bar-mode    -1)
(scroll-bar-mode  -1)

;; лёгкая прозрачность фона окна (Emacs 29+, pgtk/Wayland); текст остаётся чётким
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; на время загрузки GC отключён, после старта возвращаем разумное значение
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 64 1024 1024))))

;; --- ускорение запуска ------------------------------------------------------
;; пока идёт загрузка, обработчики имён файлов (tramp, архивы и т. п.) не нужны
(defvar my/saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist
                  (delete-dups (append file-name-handler-alist
                                       my/saved-file-name-handler-alist)))))

;; список автозагрузок всех пакетов одним файлом (обновляется сам при установке;
;; вручную: M-x package-quickstart-refresh)
(setq package-quickstart t)

;; не пересчитывать кеши шрифтов (Nerd Font с иконками иначе заметно тормозит)
(setq inhibit-compacting-font-caches t)

;; если рядом лежат .el и .elc, брать более свежий (нужно после M-x my/compile-config)
(setq load-prefer-newer t)
