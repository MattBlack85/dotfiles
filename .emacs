;;; .emacs --- my Emacs Init File

;;
;;    ___ _ __ ___   __ _  ___ ___
;;   / _ \ '_ ` _ \ / _` |/ __/ __|
;;  |  __/ | | | | | (_| | (__\__ \
;; (_)___|_| |_| |_|\__,_|\___|___/
;;

;;; Commentary:

;;  Citations
;;
;;     "Show me your ~/.emacs and I will tell you who you are."
;;                                                         [Bogdan Maryniuk]
;;
;;     "Emacs is like a laser guided missile.  It only has to be slightly
;;      mis-configured to ruin your whole day."
;;                                                         [Sean McGrath]
;;
;;     "While any text editor can save your files, only Emacs can save your
;;      soul."
;;                                                         [Per Abrahamsen]
;;

;;; Code:

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa") t)

;;; Melpa repo
(require 'package)
(package-initialize)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/")t)
;(package-refresh-contents)

;;; Flake8
(require 'flycheck)
(global-flycheck-mode)

;; Magic auto pep8 on saving
(require 'py-autopep8)
(setq py-autopep8-options '("--max-line-length=120"))
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

;;; Theme
(load-theme 'deep-blue t t)
(enable-theme 'deep-blue)

;;; Yaml mode
(require 'yaml-mode)

;;; Rust mode
(require 'rust-mode)
(require 'rustic)

(add-hook 'csharp-mode-hook 'omnisharp-mode)
(add-hook 'python-mode-hook 'jedi:setup)

(add-hook 'shell-mode-hook
	    (apply-partially 'with-editor-export-editor "GIT_EDITOR"))
(add-hook 'shell-mode-hook 'with-editor-export-git-editor)

(setq jedi:complete-on-dot t)

;;; JS indent
(setq js-indent-level 2)

;;; Line numbers
(global-linum-mode t)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil) ;; for vertical windows

;;; ipdb macro, drop ipdb within your code
(fset 'ipdb
   [?i ?m ?p ?o ?r ?t ?  ?i ?p ?d ?b ?\; return ?i ?p ?d ?b ?. ?s ?e ?t ?_ ?t ?r ?a ?c ?e ?\( ?\) return])

(global-set-key (kbd "C-c i") 'ipdb)

;;; Show trailing whitespace.
(setq-default show-trailing-whitespace t)

;; Whitespace killah
(setq-default indicate-empty-lines t)
(setq-default indicate-unused-lines t)

;; SLIME
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))

(setq lsp-rust-server 'rust-analyzer)
(setq lsp-enable-file-watchers nil)
(setq lsp-enable-completion-at-point t)
(setq lsp-enable-imenu t)
(setq lsp-rust-analyzer-cargo-watch-enable nil)

(setq rustic-analyzer-command '("rust-analyzer"))
(setq rustic-lsp-server 'rust-analyzer)
(setq rustic-format-on-save nil)
(setq rustic-lsp-format nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(yasnippet rustic elixir-mode protobuf-mode dhall-mode rust-auto-use rust-mode omnisharp csharp-mode lsp-mode pacmacs haskell-emacs arduino-mode flutter csv-mode dockerfile-mode ## markdown-mode py-autopep8 terraform-mode haskell-mode yaml-mode go-mode flycheck-pyflakes apib-mode slime jedi magit fill-column-indicator)))
'(backup-directory-alist (quote (("." . "~/.emacs.d/backup"))))

;;; .emacs ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
