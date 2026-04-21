(use-package evil
  :ensure t
  :init
  ;; Эти настройки важны ДО загрузки evil
  (setq evil-want-integration t)    ;; Интеграция с другими пакетами
  (setq evil-want-keybinding nil)   ;; Нужно для evil-collection
  (setq evil-vsplit-window-right t) ;; Сплиты как в Vim
  (setq evil-split-window-below t)
  (setq evil-undo-system 'undo-fu)  ;; Правильный откат изменений
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; Быстрое комментирование по "gcc" (как в vim-commentary)
(use-package evil-commentary
  :ensure t
  :config
  (evil-commentary-mode))

;; Работа со скобками/кавычками: "cs'\"" (change surround ' to ")
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(provide 'vim-mode)
