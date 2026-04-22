(use-package pulsar
  :ensure t
  :bind
  ( :map global-map
    ("C-x l" . pulsar-pulse-line)
    ("C-x L" . pulsar-highlight-permanently-dwim))
  :init
  (pulsar-global-mode 1)
  :config
  (setq pulsar-delay 0.055)
  (setq pulsar-iterations 5)
  (setq pulsar-face 'pulsar-green)
  (setq pulsar-region-face 'pulsar-magenta)
  (setq pulsar-highlight-face 'pulsar-cyan))

(provide 'cursor)
