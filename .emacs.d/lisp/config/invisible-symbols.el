(use-package whitespace
	:ensure nil
	:hook (prog-mode . whitespace-mode)
	:config

	(setq whitespace-style '(face
											     tabs
											     spaces
											     trailing
											     newline
											     tab-mark
											     newline-mark))

	(setq whitespace-display-mappings
				'(
				  (tab-mark ?\t [?> ?\t])
				  (newline-mark ?\n [?↲ ?\n])
			    (space-mark ?\xA0 [?␣])
				  ))

  (unless standard-display-table
		(setq standard-display-table (make-display-table)))

  (set-display-table-slot standard-display-table 'truncation (make-glyph-code ?→))
  (set-display-table-slot standard-display-table 'wrap (make-glyph-code ?←))

	(global-whitespace-mode 1))

(custom-set-faces
 '(whitespace-newline ((t (:foreground "gray30")))) ;; Цвет для ↲
 '(whitespace-tab ((t (:foreground "gray30"))))     ;; Цвет для >
 '(whitespace-trailing ((t (:background "gray30"))))) ;; Цвет хвостов

(provide 'invisible-symbols)
