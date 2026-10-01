;;; -*- lexical-binding: t -*-

(use-package org
  :bind (("C-c a"	. org-agenda)
	 ("C-c c"	. org-capture))
  :custom
  (org-directory "~/org/")
  (org-default-notes-file (concat org-directory "inbox.org"))
  (org-agenda-files (list org-directory))
  (org-support-shift-select t)
  (org-startup-indented t)
  (org-log-done 'time))

(use-package org-modern
  :hook ((org-mode		. org-modern-mode)
	 (org-agenda-finalize	. org-modern-agenda)))

(provide 'morg)
