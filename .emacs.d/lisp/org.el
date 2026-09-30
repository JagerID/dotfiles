;;; -*- lexical-binding: t -*-

(use-package org
  :custom
  (org-directory "~/org/")
  (org-default-notes-file "~/org/inbox.org")
  (org-agenda-files '("~/org/"))
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-ellipsis " ▾")
  (org-log-done 'time)
  (org-todo-keywords
   '((sequence "TODO(t)" "DOING(s)" "|" "DONE(d)" "CANCELED(c)")))
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation t)
  (org-edit-src-content-indentation 0))

(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda)))

(provide 'org)
