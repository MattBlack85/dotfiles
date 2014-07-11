; EMACS conf

(add-to-list 'load-path "~/.emacs.d/")

;;; Yaml mode
(require 'yaml-mode)

;;;Erlang Mode
(setq load-path (cons  "/usr/lib64/erlang/lib/tools-2.6.13/emacs" load-path))
(setq erlang-root-dir "/usr/lib64/erlang")
(setq exec-path (cons "/usr/lib64/erlang/bin" exec-path))
(require 'erlang-start)

;;; Theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-deep-blue)

;;; Melpa repo
(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/")t)

;;; Line numbers
(global-linum-mode t)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil) ;; for vertical windows

;;; Show trailing whitespace.
(setq-default show-trailing-whitespace t)

;; Whitespace killah
(setq-default indicate-empty-lines t)
(setq-default indicate-unused-lines t)

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
