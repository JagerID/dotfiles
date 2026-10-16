;;; -*- lexical-binding: t; -*-

(require 'morg-templates)

(defvar root-dir		(expand-file-name "~/syn"))
(defvar books-dir		(expand-file-name "books/"		root-dir))
(defvar org-dir			(expand-file-name "org/"		root-dir))
(defvar org-roam-dir		(expand-file-name "roam/"		org-dir))
(defvar org-notes-file		(expand-file-name "index.org"		org-dir))
(defvar org-attachments-dir	(expand-file-name "attachments/"	org-dir))
(defvar org-tasks-file		(expand-file-name "tasks.org"		org-dir))
(defvar org-agenda-fls		(list org-tasks-file))
(make-directory		books-dir		t)
(make-directory		org-roam-dir		t)
(make-directory		org-attachments-dir	t)

(defvar morg-capture-templates
  '(("t" "задача" entry
     (file+headline org-tasks-file "Inbox")		; всегда tasks.org → Inbox
     "* TODO %?\n")
    ("s" "задача с датой" entry
     (file+headline org-tasks-file "Inbox")
     "* TODO %?\nSCHEDULED: %^t\n")			; спросит дату, попадёт в agenda
    ("l" "задача со ссылкой" entry
     (file+headline org-tasks-file "Inbox")
     "* TODO %?\n%a\n")))

(defvar my/org-babel-languages
  '((shell	.	t)
    (python	.	t)
    (plantuml	.	t)
    (sql	.	t)
    (C		.	t)))

(defun my/split-ctrl-i ()
  "В GUI-фрейме сделать C-i отдельной клавишей, не равной TAB."
  (when (display-graphic-p)
    (define-key input-decode-map [?\C-i] [C-i])))

(defun my/org-toggle-emphasis (m)
  "Обернуть выделение (или слово у курсора) маркером M или снять его."
  (let* ((c (char-to-string m))
         (r (if (use-region-p)
                (cons (region-beginning) (region-end))
              (bounds-of-thing-at-point 'word))))
    (if (null r)
        (progn (insert c c) (backward-char))   ; нет слова: пустая пара
      (let ((b (car r)) (e (cdr r)))
        (save-excursion
          (if (and (eq (char-before b) m) (eq (char-after e) m))
              (progn (goto-char e) (delete-char 1)   ; маркеры снаружи: снять
                     (goto-char b) (delete-char -1))
            (goto-char e) (insert c)                 ; иначе обернуть
            (goto-char b) (insert c)))
        (deactivate-mark)))))

(defun my/org-bold ()   (interactive) (my/org-toggle-emphasis ?*))
(defun my/org-italic () (interactive) (my/org-toggle-emphasis ?/))
(defun my/org-code ()   (interactive) (my/org-toggle-emphasis ?~))

(my/split-ctrl-i)
(add-hook 'server-after-make-frame-hook #'my/split-ctrl-i)

(use-package org
  :bind (("C-c c"	.	org-capture)
	 ("C-c a"	.	org-agenda))
  :hook (org-babel-after-execute . org-link-preview-refresh)
  :custom
  (org-directory			org-dir)
  (org-default-notes-file		org-notes-file)
  (org-attach-dir			org-attachments-dir)

  (org-startup-indented			t)
  (org-hide-emphasis-markers		t)
  (org-pretty-entities			t)
  (org-link-descriptive			t)

  (org-startup-with-inline-images	t)
  (org-image-actual-width		'(500))

  (org-return-follows-link		t)
  (org-log-done				'time)
  (org-enforce-todo-dependencies	t)

  (org-image-max-width			'window)
  (org-image-align			'center)

  (org-refile-targets			'((org-agenda-files :maxlevel . 3)))
  (org-refile-use-outline-path		'file)
  (org-outline-path-complete-in-steps	nil)

  (org-agenda-files			org-agenda-fls)
  (org-capture-templates		morg-capture-templates)
  (org-todo-keywords			'((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "CANCEL(c)")))

  (org-plantuml-args
      (list "-headless"
            "-config" (expand-file-name "plantuml.cfg" user-emacs-directory))))

(use-package org-roam
  :bind (("C-c n f"	.	org-roam-node-find)
	 ("C-c n i"	.	org-roam-node-insert)
	 ("C-c n l"	.	org-roam-buffer-toggle)
	 ("C-c n c"	.	org-roam-capture)
	 ("C-c n r"	.	org-roam-ref-find)
	 ("C-c n d"	.	org-roam-dailies-capture-today)
	 ("C-c n t"	.	org-roam-dailies-goto-today)
	 :map org-mode-map
         ("C-b"   . my/org-bold)
         ("<C-i>" . my/org-italic))
  :custom
  (org-support-shift-select		t)
  (org-roam-complete-everywhere		t)
  (org-roam-directory			org-roam-dir)
  (org-roam-capture-templates		morg-roam-capture-templates)
  (org-roam-dailies-capture-templates	morg-roam-dailies-capture-templates)
  :config
  (org-roam-db-autosync-mode		1)

  (org-babel-do-load-languages		'org-babel-load-languages my/org-babel-languages)
  (setq org-confirm-babel-evaluate	nil
	org-src-fontify-natively	t
	org-src-tab-acts-natively	t
	org-src-content-indentation	0))

(use-package org-roam-ui
  :after org-roam
  :custom (org-roam-ui-follow t))

(use-package org-modern
  :hook (org-mode	.	org-modern-mode))

(use-package org-appear
  :hook (org-mode	.	org-appear-mode))

(provide 'morg)
