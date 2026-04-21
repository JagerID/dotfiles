(setq gc-cons-threshold most-positive-fixnum)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq frame-inhibit-implied-resize t)

(setq-default inhibit-redisplay t
	      inhibit-message t)

(add-hook 'window-setup-hook (lambda () (setq-default inhibit-redisplay nil
						      inhibit-message nil)
			       (redisplay)))
