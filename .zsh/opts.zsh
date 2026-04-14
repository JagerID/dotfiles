setopt EXTENDED_HISTORY       # Добавить время выполнения команды в историю
setopt HIST_EXPIRE_DUPS_FIRST # Удалить старые дубликаты из истории, когда лимит достигнут
setopt HIST_IGNORE_DUPS       # Игнорировать дубликат предыдущей команды
setopt HIST_IGNORE_ALL_DUPS   # Если в истории есть данная команда, удалить ее и переместить в конец
setopt HIST_IGNORE_SPACE      # Игнорировать команды, начинающиеся с пробела
setopt HIST_REDUCE_BLANKS     # trim перед записью в историю
setopt INC_APPEND_HISTORY     # Записывать команду в историю не дожидаясь закрытия сессии
setopt SHARE_HISTORY          # Общая история для всех открытых терминалов

setopt CORRECT
setopt COMPLETE_IN_WORD
setopt NO_BEEP
setopt AUTO_LIST
setopt MENU_COMPLETE

setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
