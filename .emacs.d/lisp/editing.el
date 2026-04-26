;; Git
(use-package magit
  :bind
  ("C-x g" . magit-status))

;; Minibuffer
(use-package vertico
  :custom
  (vertico-count 5)
  (vertico-resize 1)
  (vertico-cycle 1)
  :init
  (vertico-mode 1))

(use-package savehist
  :init
  (savehist-mode 1))

;; Поиск в любом порядке
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  ;; (completion-category-defaults nil)
  ;; (completion-pcm-leading-wildcard t)
  (completion-category-overrides '((file (styles partial-completion)))))

;; Пояснения для команд в списке выбора
(use-package marginalia
  :init
  (marginalia-mode 1))

;; Контекстные действия (Emacs Mini-Buffer Actions Rooted in Keymaps)
(use-package embark
  :bind (
	 ("C-." . embark-act)
	 ("M-." . embark-dwim)))

;; Интеграция с consult
(use-package embark-consult)

;; Улучшенные команды помска, переключения буфера и т.д.
(use-package consult
  :bind (
	 ("C-s" . consult-line) ;; Поиск внутри текущего файла (с предпросмотром)
	 ("C-x b" . consult-buffer) ;; Переключение буферов
	 ("M-y" . consult-yank-pop) ;; Буфер обмена
	 ("M-g g" . consult-goto-line) ;; Переход на строку

	 ("M-s r" . consult-ripgrep) ;; Поиск текста во всем проекте
	 ("M-s f" . consult-find) ;; Поиск файла
	 ("M-s s" . consult-eglot-symbols)
	 ("M-s e" . consult-flymake)
	 ("M-s l" . consult-line)
	 ))

;; LSP
(use-package treesit
  :config
  (setq treesit-language-source-alist
        '((bash "https://github.com/tree-sitter/tree-sitter-bash")
          (c "https://github.com/tree-sitter/tree-sitter-c")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (cmake "https://github.com/uyha/tree-sitter-cmake")
          (css "https://github.com/tree-sitter/tree-sitter-css")
          (go "https://github.com/tree-sitter/tree-sitter-go")
          (html "https://github.com/tree-sitter/tree-sitter-html")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (make "https://github.com/alemuller/tree-sitter-make")
          (python "https://github.com/tree-sitter/tree-sitter-python")
          (rust "https://github.com/tree-sitter/tree-sitter-rust")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

  (add-hook 'typescript-ts-mode-hook #'treesit-font-lock-enable)

  (setq major-mode-remap-alist
        '((c-mode          . c-mode)
          (c++-mode        . c++-mode)
          (bash-mode       . bash-ts-mode)
          (python-mode     . python-ts-mode)
          (js-mode         . js-ts-mode)
	  (javascript-mode . js-ts-mode)
          (json-mode       . json-ts-mode)
          (css-mode        . css-ts-mode)))

  (setq treesit-font-lock-level 4))

;; Форматтер
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

  (setf (alist-get 'prettier apheleia-formatters)
	'("npx" "prettier" "--stdin-filepath" filepath))

  (setf (alist-get 'c-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c++-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c-ts-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c++-ts-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'js-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'typescript-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'tsx-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'css-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'json-ts-mode apheleia-mode-alist) 'prettier))

(use-package eglot
  :ensure nil
  :hook (
         (c-mode          . eglot-ensure)
         (c++-mode        . eglot-ensure)
         (rust-ts-mode       . eglot-ensure)
         (javascript-ts-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode        . eglot-ensure)
         (python-ts-mode     . eglot-ensure))
  :config
  (setq eldoc-idle-delay 0.5))

;; Автодополнения
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match t) ;; Закрывать, если ничего не найдено
  (corfu-preview-current nil)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-count 10)
  (corfu-scroll-margin 2)
  :bind (
	 "C-SPC" . completion-at-point)
  (:map corfu-map
	("SPC" . corfu-insert-separator)
	("TAB" . corfu-next)
	([tab] . corfu-next)
	("S-TAB" . corfu-previous)
	([backtab] . corfu-previous)
	("M-SPC" . corfu-insert-separator))
  :init
  (global-corfu-mode 1)
  (corfu-history-mode 1)
  (corfu-popupinfo-mode 1)
  (corfu-indexed-mode 1))

(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package emacs
  :custom
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p))

;; Проекты
(use-package projectile
  :init
  (projectile-mode 1)
  :bind
  ("C-c p" . projectile-command-map))

;; Терминал
(use-package vterm)

;; Отображение текста ошибки во всплывающем меню, а не в minibuffer
(use-package flycheck
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package flycheck-posframe
  :after flycheck
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))

(provide 'editing)
