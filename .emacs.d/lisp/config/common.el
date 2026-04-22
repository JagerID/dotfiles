(setq inhibit-startup-screen t
	  initial-scratch-message nil
	  sentence-end-double-space nil
	  ring-bell-function 'ignore
	  history-length 32
	  create-lockfiles nil
	  select-enable-clipboard t)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(setq scroll-conservatively 101
	  scroll-margin 0
	  scroll-step 1
	  mouse-wheel-scroll-amount '(2 ((shift) . 1))
	  mouse-wheel-progressive-speed t)

(if (fboundp 'pixel-scroll-precision-mode)
	(pixel-scroll-precision-mode 1))

(global-display-line-numbers-mode -1)

(setq-default indent-tabs-mode t
			  tab-width 4
			  display-line-numbers-type 'relative
			  display-line-numbers-current-absolute t)

(column-number-mode 1)
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(set-fringe-mode 0)

(setq electric-pair-preserve-balance t
	  electric-pair-delete-adjacent-pairs t
	  electric-pair-open-newline-between-pairs nil)

(setq electric-pair-inhibit-predicate
      (lambda (c)
        (if (char-after)
            (not (looking-at-p "[ \t\n\r]"))
          nil)))

(fset 'yes-or-no-p 'y-or-n-p)

(set-face-attribute 'default nil
                    :family "Iosevka Nerd Font"
                    :height 110
                    :weight 'regular)

(add-hook 'emacs-startup-hook
		  (lambda () (setq gc-cons-threshold (* 100 1024 1024)
						   file-name-handler-alist default-file-name-handler-alist)))

(provide 'common)
