(setq-default indent-tabs-mode t)
(setq-default tab-always-indent nil)
(setq-default tab-width 4)
(setq-default backward-delete-char-untabify-method nil)

(setq recentf-max-saved-items 10)
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory))))
(setq next-line-add-newlines nil)
(setq line-spacing 0)
(setq show-paren-delay 0)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq backward-delete-char-untabify nil)

(show-paren-mode 1)
(electric-pair-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)
(delete-selection-mode 1)
(recentf-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'prog-mode-hook (lambda () (setq indent-tabs-mode t)))

;; Пакеты

(use-package corfu ;; Автодополнения в буфере
  ;; :init До загрузки пакета
  ;; Включаем сразу, т.к. это ui элемент
  :bind
  (("C-SPC" . completion-at-point)
   :map corfu-map
   ("TAB" . corfu-next)
   ([tab] . corfu-next)
   ("S-TAB" . corfu-previous)
   ([backtab] . corfu-previous))
  :custom ;; Для setq с проверкой (customize-set-variable)
  (corfu-auto 1)
  (corfu-auto-delay 0.2)
  (corfu-popupinfo-delay 0.5)
  (corfu-auto-prefix 2) ;; Минимальное кол-во символов для автоматического открытия corfu
  (corfu-cycle 1) ;; Возврат в начало после конца списка
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match 'separator)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match 'insert)
  (corfu-count 10)
  :config
  (corfu-popupinfo-mode 1)
  (global-corfu-mode 1)
  (corfu-indexed-mode 1)
  (setq debug-on-error nil))

(use-package cape ;; Объединяет подсказки из разных источников
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(use-package eglot ;; LSP
  :hook ((c-mode . eglot-ensure)
		 (c++-mode . eglot-ensure))
  :config
  (setq eglot-extend-to-xref t)
  (setq eglot-ignored-server-capabilities '(:autoHoverCapability))
  (setq eglot-events-buffer-size 0)
  (setq-default eglot-autoshutdown t))

(use-package emacs
  :custom
  (tab-always-indent nil)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p)

  (context-menu-mode 1)
  (enable-recursive-minibuffers 1)
  (minibuffer-prompt-properties
   '(read-only 1 cursor-intangible 1 face minibuffer-prompt)))

(use-package orderless
  :custom
  (completion-styles '(orderless basic)) ;; basic - fallback (запасной вариант)
  (completion-category-defautls -1)
  (completion-pcm-leading-wildcard 1)
  (orderless-matching-styles '(orderless-literal
                               orderless-regexp
                               orderless-initialism))
  (completion-category-overrides '((file (styles partial-completion))))) ;; Для поиска по файлам иной стиль дополнений

(use-package vertico ;; Автодополнения в minibuffer
  :init
  (vertico-mode 1)
  :custom
  (vertico-count 10)
  (vertico-cycle 1)
  (vertico-resize -1))

(use-package savehist :init (savehist-mode 1))

(use-package marginalia :init (marginalia-mode 1))

(use-package consult
  :bind (
         ("C-x b" . consult-buffer)
         ("C-s" . consult-line)
         ("M-y" . consult-yank-pop)
         ("M-g t" . consult-imenu)))

(use-package magit ;; Git
  :bind ("C-x g" . magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

(use-package projectile ;; Управление проектами
  :init
  (projectile-mode 1)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :custom
  (projectile-indexing-methid 'hybrid))

(use-package apheleia
  :hook (prog-mode . apheleia-mode)
  :config
  (defvar clang-format-style
    (concat "{"
			"IndentWidth: 8, "
			"TabWidth: 8, "
			"UseTab: ForIndentation, "
			"IndentCaseBlocks: true, "
			"ColumnLimit: 0, "
			"AlignAfterOpenBracket: DontAlign, "
			"ContinuationIndentWidth: 8, "
			"IndentPPDirectives: BeforeHash, "
			"MaxEmptyLinesToKeep: 1, "
			"IncludeBlocks: Regroup, "
			"SeparateDefinitionBlocks: Always, "
			"AlignArrayOfStructures: Right, "
			"BreakBeforeBraces: Custom, "
			"BraceWrapping: {"
			"AfterFunction: true, AfterStruct: false, AfterUnion: false, "
			"AfterEnum: false, AfterClass: false, AfterExternBlock: false, "
			"AfterCaseLabel: false, AfterControlStatement: Never, "
			"BeforeElse: false, IndentBraces: false"
			"}, "
			"AllowShortFunctionsOnASingleLine: Empty, "
			"AllowShortIfStatementsOnASingleLine: Never, "
			"AllowShortLoopsOnASingleLine: false, "
			"AllowShortLambdasOnASingleLine: All, "
			"AllowShortBlocksOnASingleLine: Empty, "
			"AllowShortCaseLabelsOnASingleLine: true, "
			"AlignConsecutiveAssignments: {Enabled: true, AcrossEmptyLines: false, AcrossComments: true}, "
			"AlignConsecutiveDeclarations: {Enabled: true, AcrossEmptyLines: false, AcrossComments: true}, "
			"SpacesInCStyleCastParentheses: true, "
			"SpaceAfterCStyleCast: true, "
			"SpacesInParens: Custom, "
			"SpacesInParensOptions: {"
			"InConditionalStatements: true, "
			"InCStyleCasts: true, "
			"InEmptyParentheses: false, "
			"Other: true"
			"}, "
			"SpacesInContainerLiterals: true, "
			"SpaceBeforeSquareBrackets: true, "
			"SpacesInSquareBrackets: true, "
			"AlignTrailingComments: true, "
			"SortIncludes: CaseSensitive, "
			"PointerAlignment: Right, "
			"DerivePointerAlignment: false, "
			"KeepEmptyLinesAtTheStartOfBlocks: false, "
			"SpaceBeforeParens: Custom, "
			"SpaceBeforeParensOptions: {"
			"AfterControlStatements: true, "
			"AfterFunctionDefinitionName: true, "
			"AfterFunctionDeclarationName: true, "
			"BeforeNonEmptyParentheses: true"
			"}"
			"}"))

  (setf (alist-get 'clang-format apheleia-formatters)
        `("clang-format" "-assume-filename" filepath ,(concat "-style=" clang-format-style)))

  (setf (alist-get 'c-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c++-mode apheleia-mode-alist) 'clang-format)

  (setq-default tab-width 8)
  (setq-default indent-tabs-mode t)
  (add-hook 'c-mode-hook (lambda () (setq c-basic-offset 8))))

(provide 'editing)
