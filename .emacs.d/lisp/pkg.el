;;; pkg.el --- generated from config.org -*- lexical-binding: t -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(setq use-package-verbose            nil  ; сообщения о каждом пакете замедляют старт;
                                          ; время загрузки — в M-x use-package-report
      use-package-always-ensure      t
      use-package-compute-statistics t)   ; M-x use-package-report — время загрузки пакетов
(unless package-archive-contents (package-refresh-contents))

;; профиль запуска: M-x benchmark-init/show-durations-tree (или -tabulated).
;; Стоит как можно раньше, чтобы увидеть всё, что грузится дальше.
(use-package benchmark-init
  :demand t
  :config
  (add-hook 'after-init-hook #'benchmark-init/deactivate))

(provide 'pkg)
