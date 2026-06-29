;;; -*- lexical-binding: t; -*-

;; Remap дефолтных режимов на treesit
(use-package treesit
  :ensure nil
  :config

  (add-to-list 'treesit-language-source-alist
	       '(yuck "https://github.com/tree-sitter-grammars/tree-sitter-yuck"))

  (setq major-mode-remap-alist
	'((c-mode		.	c-ts-mode)
	  (c++-mode		.	c++-ts-mode)
	  (c-or-c++-mode	.	c-or-c++-ts-mode)
	  (lua-mode		.	lua-ts-mode)))

  (add-hook 'c-ts-mode-hook
	    (lambda ()
	      (setq c-ts-mode-indent-offset 8)
	      (setq c-ts-mode-indent-style 'linux)))

  (add-hook 'lua-ts-mode-hook
	    (lambda ()
	      (setq lua-ts-indent-level 8)
	      (setq lua-ts-indent-offset 8)
	      (setq apheleia-inhibit t))))

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
  :hook (
	 (c-ts-mode . eglot-ensure)
	 (lua-ts-mode . eglot-ensure))
  :init
  (setq eglot-events-buffer-config '(:size 0 :format full))
  (global-unset-key (kbd "C-S-r"))
  :bind (:map eglot-mode-map
	      ("C-S-r"	.	xref-find-references)
	      ("M-."	.	xref-find-definitions))
  :config
  (setq eglot-ignored-server-capabilities '(:documentOnTypeFormattingProvider :hoverProvider))
  (setq xref-prompt-for-identifier nil)
  (set-face-attribute 'eglot-highlight-symbol-face nil
		      :background "#3e4451"
		      :underline t)
  (setq-default eglot-workspace-configuration
		'(:clangd (:fallbackFlags ["--style=file" "--style=file:/home/jager/.emacs.d/.clang-format-fallback"]))))

(with-eval-after-load 'semantic/symref/grep
  (add-to-list 'semantic-symref-filepattern-alist '(c-ts-mode "*.c" "*.h"))
  (add-to-list 'semantic-symref-filepattern-alist '(lua-ts-mode "*.lua")))


(provide 'prog)
