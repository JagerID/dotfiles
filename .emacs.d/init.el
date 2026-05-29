;; -*- lexical-binding: t; -*-

;; Подключение папок с конфигами
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq use-package-always-ensure t)
(unless package-archive-contents (package-refresh-contents))

(require 'theme)
(require 'ui)
