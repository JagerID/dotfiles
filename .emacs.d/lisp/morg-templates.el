;;; morg-templates.el --- generated from config.org -*- lexical-binding: t -*-

(defvar books-dir)           ; задаётся в morg.el
  (defvar org-roam-directory)  ; задаётся в morg.el

  (defun morg-book-file (_node)
    "Спросить файл книги и вернуть его путь для ссылки."
    (abbreviate-file-name
     (read-file-name "Файл книги: " (file-name-as-directory books-dir))))

  (defun morg--topic-dirs (&optional rel)
    "Рекурсивный список тем относительно `org-roam-directory'.
Для boba с подпапками bik и kib вернёт (\"boba\" \"boba/bik\" \"boba/kib\").
Скрытые папки пропускаются; sources и daily пропускаются в корне."
    (let ((base (expand-file-name (or rel "") org-roam-directory)))
      (mapcan
       (lambda (d)
         (let ((r (if rel (concat rel "/" d) d)))
           (when (and (file-directory-p (expand-file-name r org-roam-directory))
                      (not (string-prefix-p "." d))
                      (not (and (null rel) (member d '("sources" "daily")))))
             (cons r (morg--topic-dirs r)))))
       (directory-files base nil directory-files-no-dot-files-regexp))))

  (defun morg-topic-prefix ()
    "Спросить тему заметки. Пусто = корень roam, иначе подпапка.
Можно выбрать из списка или ввести новый путь (например boba/bik).
Возвращает \"тема/\" или пустую строку. Новая папка создаётся сама."
    (let* ((dirs (morg--topic-dirs))
           (topic (string-trim
                   (completing-read "Тема (пусто = корень): " dirs nil nil))))
      (if (string-empty-p topic)
          ""
        (make-directory (expand-file-name topic org-roam-directory) t)
        (file-name-as-directory topic))))

  (defvar morg-roam-capture-templates
    '(("d" "заметка" plain "%?"
       :target (file+head "%(morg-topic-prefix)%<%Y%m%d%H%M%S>-${slug}.org"
                          "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :draft:\n")
       :unnarrowed t)

      ;; заглушка: создаётся сразу, без перехода в заметку (удобно из C-c n i)
      ("s" "заглушка" plain ""
       :target (file+head "%(morg-topic-prefix)%<%Y%m%d%H%M%S>-${slug}.org"
                          "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :draft:\n")
       :immediate-finish t
       :unnarrowed t)

      ("q" "вопрос" plain "%?"
       :target (file+head "%(morg-topic-prefix)%<%Y%m%d%H%M%S>-${slug}.org"
                          "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :question:\n")
       :unnarrowed t)

      ("b" "книга" plain "* Конспект\n%?\n* Цитаты\n"
       :target (file+head "sources/%<%Y%m%d%H%M%S>-${slug}.org"
                          "#+title: ${title}\n#+author: ${author}\n#+year: ${year}\n#+filetags: :source:book:\n#+date: %<%Y-%m-%d>\n\nФайл: [[file:${morg-book-file}]]\n")
       :unnarrowed t)))

  (defvar morg-roam-dailies-capture-templates
    '(("d" "ежедневная заметка" entry "* %<%H:%M> %?"
       :target (file+head "%<%Y-%m-%d>.org"
                          "#+title: %<%Y-%m-%d>\n"))))

  (provide 'morg-templates)
