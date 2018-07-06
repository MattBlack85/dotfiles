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
	     '("melpa" . "http://melpa.milkbox.net/packages/")t)
(package-refresh-contents)

;; list of package that have to be installed
(defvar local-packages '(yaml-mode go-mode flycheck-pyflakes apib-mode slime jedi py-autopep8 magit color-theme fill-column-indicator))

;; function that from a list of packages return the uninstalled packages
(defun uninstalled-packages (packages)
  (delq nil
	(mapcar (lambda (p) (if (package-installed-p p nil) nil p)) packages)))

;; function that install uninstalled packages.
(let ((need-to-install (uninstalled-packages local-packages)))
  (when need-to-install
    (progn
      (package-refresh-contents)
      (dolist (p need-to-install)
(package-install p)))))

;;; Flake8
(require 'flycheck)
(global-flycheck-mode)

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

(add-hook 'python-mode-hook 'jedi:setup)
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (yaml-mode go-mode flycheck-pyflakes apib-mode slime jedi py-autopep8 magit color-theme fill-column-indicator))))
'(backup-directory-alist (quote (("." . "~/.emacs.d/backup"))))

;;; .emacs ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
