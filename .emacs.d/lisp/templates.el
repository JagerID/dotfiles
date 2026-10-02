;;; -*- lexical-binding: t -*-

(use-package tempel
  :bind (("M-+"		.	tempel-complete)
	 ("M-*"		.	tempel-insert)
	 :map tempel-map
	 ("TAB"		.	tempel-next)
	 ("S-TAB"	.	tempel-previous))
  :init
  (setq tempel-path (expand-file-name "templates/*.eld" user-emacs-directory)))

(defun my/header-guard ()
  "Имя include guard из имени файла: foo-bar.h -> FOO_BAR_H"
  (let ((name (file-name-nondirectory (or buffer-file-name (buffer-name)))))
    (upcase (replace-regexp-in-string "[^A-Za-z0-9]" "_" name))))

(provide 'templates)
