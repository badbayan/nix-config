;;; early-init.el --- pre-initialisation file -*- lexical-binding: t -*-

;;; Commentary:
;; `early-init.el'

;;; Code:

(setq-default
 default-frame-alist
 '((internal-border-width . 10)
   (menu-bar-lines . 0)
   (tool-bar-lines . 0)
   (horizontal-scroll-bars)
   (vertical-scroll-bars))
 inhibit-default-init t
 package-enable-at-startup nil
 site-run-file "site-start")

(provide 'early-init)

;;; early-init.el ends here
