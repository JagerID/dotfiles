;;; -*- lexical-binding: t; -*-

(defun morg-book-file (_node)
  "Спросить файл книги и вернуть его путь для ссылки."
  (abbreviate-file-name
   (read-file-name "Файл книги: " (file-name-as-directory books-dir))))

(defvar morg-roam-capture-templates
  '(("d" "заметка" plain "%?"
     :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
			"#+title: ${title}\n#+date: %<%Y-%m-%d>\n")
     :unnarrowed t)


    ("b" "книга" plain "* Конспект\n%?\n* Цитаты\n"
     :target (file+head "sources/%<%Y%m%d%H%M%S>-${slug}.org"
			"#+title: ${title}\n#+author: ${author}\n#+year: ${year}\n#+filetags: :source:book:\n#+date: %<%Y-%m-%d>\n\nФайл: [[file:${morg-book-file}]]\n")
     :unnarrowed t)
    ))

(defvar morg-roam-dailies-capture-templates
  '(("d" "ежедневная заметка" entry "* %<%H:%M> %?"
     :target (file+head "%<%Y-%m-%d>.org"
			"#+title: %<%Y-%m-%d>\n"))))

(provide 'morg-templates)
