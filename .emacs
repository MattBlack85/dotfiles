;;; EMACS conf

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa") t)

;;; Melpa repo
(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/")t)

;; Magic auto pep8 on saving
(require 'py-autopep8)
(setq py-autopep8-options '("--max-line-length=100"))
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

;;; Theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-deep-blue)

;;; Yaml mode
(require 'yaml-mode)

;; SLIME
(add-to-list 'load-path "~/repos/slime")
(require 'slime-autoloads)
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))

;;; Line numbers
(global-linum-mode t)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil) ;; for vertical windows

;;; Show trailing whitespace.
(setq-default show-trailing-whitespace t)

;; Whitespace killah
(setq-default indicate-empty-lines t)
(setq-default indicate-unused-lines t)
(setq whitespace-style '(face tabs empty trailing lines-tail))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
 '(backup-directory-alist (quote (("." . "~/.emacs.d/backup"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
