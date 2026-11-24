;;; morg-templates.el --- generated from config.org -*- lexical-binding: t -*-

(defvar books-dir)           ; задаётся в morg.el
(defvar org-roam-directory)  ; задаётся в morg.el

(defun morg-book-file (_node)
  "Спросить файл книги и вернуть его путь для ссылки."
  (abbreviate-file-name
   (read-file-name "Файл книги: " (file-name-as-directory books-dir))))

;; --- структура папки заметок -----------------------------------------------------
;;   notes/            постоянные заметки, проекты, справка, карты тем — всё в корне,
;;                     различается тегами (#+filetags);
;;   notes/inbox/      входящее: быстро записал, потом разобрал (C-c n x);
;;   notes/daily/      дневник: одна заметка на день.
;; Тип заметки — это тег: draft/review/done (статус), project, ref, moc, question,
;; source, inbox, daily.
(defconst morg--stamp "%<%Y%m%d%H%M%S>-${slug}.org"
  "Имя файла заметки: время создания + заголовок.")

(defvar morg-roam-capture-templates
  `(("n" "заметка" plain "%?"
     :target (file+head ,morg--stamp
                        "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :draft:\n")
     :unnarrowed t)

    ;; быстрый захват: пишется в inbox/, разбирается позже (C-c n x)
    ("i" "входящее" plain "%?"
     :target (file+head ,(concat "inbox/" morg--stamp)
                        "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :inbox:\n")
     :unnarrowed t)

    ;; заглушка: создаётся сразу, без перехода в заметку (удобно из C-c n i)
    ("s" "заглушка" plain ""
     :target (file+head ,morg--stamp
                        "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :draft:\n")
     :immediate-finish t
     :unnarrowed t)

    ("p" "проект" plain
     "* Цель\n%?\n* Решения\n(дата — что выбрали и почему)\n* Открытые вопросы\n* Задачи\n"
     :target (file+head ,morg--stamp
                        "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :project:\n")
     :unnarrowed t)

    ("r" "справка" plain "* Описание\n%?\n* Пример\n"
     :target (file+head ,morg--stamp
                        "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :ref:\n")
     :unnarrowed t)

    ;; термин: короткая заметка в terms/ (имя файла — просто название, без даты)
    ("t" "термин" plain "* Определение\n%?\n* Пример\n"
     :target (file+head "terms/${slug}.org"
                        "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :term:\n")
     :unnarrowed t)

    ;; карта темы: оглавление из ссылок на заметки по одной теме
    ("m" "карта темы" plain "* Заметки по теме\n%?\n"
     :target (file+head ,morg--stamp
                        "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :moc:\n")
     :unnarrowed t)

    ("q" "вопрос" plain "%?"
     :target (file+head ,morg--stamp
                        "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :question:\n")
     :unnarrowed t)

    ("b" "книга" plain "* Конспект\n%?\n* Цитаты\n"
     :target (file+head ,morg--stamp
                        "#+title: ${title}\n#+author: ${author}\n#+year: ${year}\n#+filetags: :source:book:\n#+date: %<%Y-%m-%d>\n\nФайл: [[file:${morg-book-file}]]\n")
     :unnarrowed t)))

;; дневник: файл на день в notes/daily/, записи с временем
(defvar morg-roam-dailies-capture-templates
  '(("d" "запись в дневник" entry "* %<%H:%M> %?"
     :target (file+head "%<%Y-%m-%d>.org"
                        "#+title: %<%Y-%m-%d>\n#+filetags: :daily:\n"))))

(provide 'morg-templates)
