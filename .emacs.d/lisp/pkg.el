;;; -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(setq use-package-verbose t)
(setq use-package-always-ensure t)
(unless package-archive-contents (package-refresh-contents))

(provide 'pkg)
