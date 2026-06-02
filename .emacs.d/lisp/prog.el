;;; -*- lexical-binding: t; -*-

;; Git клиент
(use-package magit
  :bind ("C-x g" . magit-status))

;; Отображение TODOs в magit
(use-package magit-todos
  :after magit
  :config (magit-todos-mode 1))

;; Умные скобки
(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config (require 'smartparens-config))

;; Автодополнения
(use-package corfu
  :bind ("C-SPC" . completion-at-point)
  (:map corfu-map
	("TAB" . corfu-next)
	([tab] . corfu-next)
	("S-TAB" . corfu-previous)
	([backtab] . corfu-previous)
	("M-SPC" . corfu-insert-separator))
  :config
  (global-corfu-mode 1)
  (corfu-history-mode 1)
  (corfu-popupinfo-mode 1)
  (corfu-indexed-mode 1))

;; Источники данных для автодополнения corfu
(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-file) ;; Пути к файлам
  (add-to-list 'completion-at-point-functions #'cape-dabbrev) ;; Слова из текущего буфера
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-elisp-symbol)) ;; Ключевые слова языка

;; Remap дефолтных режимов на treesit
(use-package treesit
  :ensure nil
  :config
  (setq major-mode-remap-alist
	'((c-mode		.	c-ts-mode)
	  (c++-mode		.	c++-ts-mode)
	  (c-or-c++-mode	.	c-or-c++-ts-mode)))

  (add-hook 'c-ts-mode-hook
	    (lambda ()
	      (setq c-ts-mode-indent-offset 8)
	      (setq c-ts-mode-indent-style 'linux))))

;; Форматтер
(use-package apheleia
  :config
  (apheleia-global-mode 1)
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
	    "AlignArrayOfStructures: Left, "
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
	    "BinPackArguments: false, "
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
	`("clang-format" "-assume-filename" filepath ,(concat "-style=" clang-format-style))))

;; LSP
(use-package eglot
  :ensure nil
  :hook (prog-mode . eglot-ensure)
  :bind (:map eglot-mode-map
	      ("M-?"	.	xref-find-references)
	      ("M-."	.	xref-find-definitions))
  :config
  (setq xref-prompt-for-identifier nil)
  (set-face-attribute 'eglot-highlight-symbol-face nil
		      :background "#3e4451"
		      :underline t)
  (setq-default eglot-workspace-configuration
		`((:clangd . (:fallbackFlags ("--style=file"
					      ,(concat "--style=file:" (expand-file-name ".clang-format-fallback" user-emacs-directory))))))))

(provide 'prog)
