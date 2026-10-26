;;; plugins.el --- generated from config.org -*- lexical-binding: t -*-

(use-package vertico
  :custom
  (vertico-count  10)
  (vertico-cycle  t)
  :init (vertico-mode))

(use-package marginalia
  :init (marginalia-mode))

(use-package embark
  :bind
  (("C-`"    . embark-act)
   ("C-;"    . embark-dwim)
   ("C-h B"  . embark-bindings)))

(use-package embark-consult)

(use-package orderless
  :custom
  (completion-styles            '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :bind
  (("C-f"    . consult-line)
   ("C-S-f"  . consult-ripgrep)
   ("C-S-o"  . consult-outline))
  :config
  (global-set-key (kbd "C-p")    #'project-find-file)
  (global-set-key (kbd "C-S-p")  #'project-switch-project))

(use-package corfu
  :bind
  ("C-SPC" . completion-at-point)
  (:map corfu-map
        ("TAB"      . corfu-next)
        ([tab]      . corfu-next)
        ("S-TAB"    . corfu-previous)
        ([backtab]  . corfu-previous))
  :custom
  (corfu-auto             t)
  (corfu-cycle            t)
  (corfu-auto-prefix      2)
  (corfu-quit-no-match    t)
  (corfu-auto-delay       0.25)
  (corfu-popupinfo-delay  0.5)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-history-mode))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'tempel-complete))

(use-package magit
  :custom (magit-diff-refine-hunk 'all)
  :bind ("C-x g" . magit-status))

(use-package docker
  :bind ("C-x d" . docker))

(use-package dirvish
  :custom
  (dirvish-quick-access-entries
   '(("h" "~/" "Home")
     ("d" "~/Downloads" "Downloads")
     ("p" "~/dev" "Projects")
     ("e" "~/.emacs.d/lisp" "Emacs config")))
  (dirvish-mode-line-format
   '(:left (sort symlink) :right (omit yank index)))
  (dirvish-attributes
   '(nerd-icons file-size collapse subtree-state vc-state git-msg))
  (dired-listing-switches
   "-l --almost-all --human-readable --group-directories-first --no-group")

  (dirvish-subtree-state-style 'nerd)
  (delete-by-moving-to-trash t)
  (dirvish-side-width 35)
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-auto-revert-buffer t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'top)
  (dired-create-destination-dirs 'ask)
  (dirvish-default-layout '(0 0.4 0.6))

  :bind
  (("C-c f"  . dirvish)
   ("C-c T"  . dirvish-side)
   :map dirvish-mode-map
   ("TAB"        . dirvish-subtree-toggle)   ; раскрыть / свернуть папку
   ("<backtab>"  . dirvish-subtree-up)       ; к родителю раскрытой папки
   ("h"          . dired-up-directory)       ; на уровень вверх
   ("l"          . dired-find-file)          ; войти в папку / открыть файл
   ("y"          . dirvish-yank-menu)        ; копировать / переместить / симлинк
   ("s"          . dirvish-quicksort))       ; сортировка
  :hook (dired-mode . dired-omit-mode)
  :init (dirvish-override-dired-mode))

(use-package vterm
  :commands vterm
  :custom
  (vterm-shell                  "/usr/bin/zsh")
  (vterm-max-scrollback         10000)
  (vterm-kill-buffer-on-exit    t)
  (vterm-always-compile-module  t)
  :bind (:map vterm-mode-map
              ("<escape>" . vterm-send-escape))   ; ESC уходит в шелл, а не в Emacs
  :config
  (add-to-list 'display-buffer-alist
               '("\\*vterm"
                 (display-buffer-at-bottom)
                 (window-height . 0.3))))

(use-package vterm-toggle
  :after vterm
  :bind ("C-c t" . vterm-toggle))

(use-package multi-vterm
  :after vterm
  :custom
  (multi-vterm-dedicated-window-height-percent 30)
  :bind (("C-t"    . multi-vterm-dedicated-toggle)   ; показать/спрятать терминал снизу
         ("C-S-t"  . multi-vterm)                    ; новый терминал
         :map vterm-mode-map
         ("C-t"    . multi-vterm-dedicated-toggle)
         ("C-S-t"  . multi-vterm)))

(use-package breadcrumb
  :init (breadcrumb-mode 1))

(use-package undo-fu
  :bind
  ("C-z"    . undo-fu-only-undo)
  ("C-S-z"  . undo-fu-only-redo))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package smartparens
  :config
  (require 'smartparens-config)
  (sp-pair "(" ")" :unless '(sp-point-after-word-p sp-point-before-word-p))
  (setq sp-pair-overlay-mode nil)
  (setq sp-cancel-autoskip-on-backward-movement t)
  :hook (prog-mode . smartparens-mode))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package drag-stuff
  :bind (("M-<up>"   . drag-stuff-up)
         ("M-<down>" . drag-stuff-down))
  :config (drag-stuff-global-mode))

(use-package nerd-icons)
(use-package nerd-icons-corfu
  :after corfu
  :init (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-completion
  :after vertico
  :config (nerd-icons-completion-mode))

(use-package colorful-mode
  :config (global-colorful-mode))

(use-package diff-hl
  :init
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode)
  (diff-hl-show-hunk-mouse-mode))

(use-package spacious-padding
  :custom
  (spacious-padding-widths
   '(:internal-border-width 12 :right-divider-width 20 :fringe-width 8))
  :config (spacious-padding-mode 1))

(use-package zoom
  :custom (zoom-size '(0.618 . 0.618))
  :init (zoom-mode))

(use-package ligature                   ; лигатуры (JetBrains Mono, Iosevka и др.)
  :config
  (ligature-set-ligatures 'prog-mode '("->" "=>" "!=" "==" ">=" "<=" "::" "&&" "||"))
  (global-ligature-mode t))

(use-package pulsar                     ; короткая подсветка строки при прыжках
  :custom
  (pulsar-pulse       t)
  (pulsar-delay       0.04)
  (pulsar-iterations  10)
  (pulsar-face        'pulsar-magenta)
  :init
  (pulsar-global-mode 1)
  :config
  (add-hook 'consult-after-jump-hook #'pulsar-pulse-line)
  (add-hook 'imenu-after-jump-hook   #'pulsar-recenter-top))

(use-package dimmer                     ; приглушает неактивные окна
  :custom
  (dimmer-fraction                0.25)
  (dimmer-watch-frame-focus-events nil)
  :config
  (dimmer-configure-org)
  (dimmer-configure-magit)
  (dimmer-mode 1))

(use-package helpful                    ; более подробная справка по функциям и переменным
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)))

(provide 'plugins)
