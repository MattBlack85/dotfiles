;;; .emacs --- my Emacs Init File  -*- lexical-binding: t; -*-

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
	     '("melpa" . "https://melpa.org/packages/")t)

;; (setq package-selected-packages
;;   '(dart-mode lsp-mode lsp-dart lsp-treemacs flycheck company
;;     ;; Optional packages
;;     lsp-ui company hover))
;; (setq package-selected-packages
;;       '(flycheck py-autopep8 python-mode yaml-mode rust-mode rustic dart-mode
;; 		 color-theme-modern lsp-mode helm-lsp helm-ag company lsp-ui
;; 		 terraform-mode cmake-mode arduino-mode))
;; (when (cl-find-if-not #'package-installed-p package-selected-packages)
;;   (package-refresh-contents)
;;    (mapc #'package-install package-selected-packages))

;;; Enable line numbers displaying
(global-display-line-numbers-mode)

(require 'luffy-mode)

;; (use-package ellama
;;   :ensure t
;;   :init
;;   (require 'llm-ollama)
;;   :config
;;   (setq ellama-provider
;;         (make-llm-ollama
;;          :model "qwen2.5-coder:7b"
;;          :host "localhost"
;;          :port 11434))
;;   ;; Optional but nice: name your sessions
;;   (setq ellama-sessions-directory (expand-file-name "~/.emacs.d/ellama-sessions/"))
;;   ;; Language for responses
;;   (setq ellama-language "English"))

;;; Flake8
(require 'flycheck)
(global-flycheck-mode)

;; Magic auto pep8 on saving
;;  (require 'py-autopep8)
;; (setq py-autopep8-options '("--max-line-length=120"))
;; (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

;;; Theme
(load-theme 'deep-blue t t)
(enable-theme 'deep-blue)

;;; Rust mode
(use-package rustic)
(setq lsp-rust-server 'rust-analyzer)
(setq lsp-enable-file-watchers nil)
(setq lsp-enable-completion-at-point t)
(setq lsp-enable-imenu t)
(setq lsp-rust-analyzer-cargo-watch-enable nil)

(setq rustic-analyzer-command '("rust-analyzer"))
(setq rustic-lsp-server 'rust-analyzer)
(setq rustic-format-on-save nil)
(setq rustic-lsp-format nil)

(defun rustic-mode-auto-save-hook ()
  "Enable auto-saving in rustic-mode buffers."
  (when buffer-file-name
    (setq-local compilation-ask-about-save nil)))
(add-hook 'rustic-mode-hook 'rustic-mode-auto-save-hook)

(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'shell-mode-hook
	    (apply-partially 'with-editor-export-editor "GIT_EDITOR"))
(add-hook 'shell-mode-hook 'with-editor-export-git-editor)
(add-hook 'dart-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024))

;;; Line numbers
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil) ;; for vertical windows

(setq indent-tabs-mode nil)

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
(setq slime-contribs '(slime-fancy))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(deep-blue))
 '(package-selected-packages
   '(## arduino-mode auto-package-update cmake-mode color-theme
	color-theme-modern company dap-mode dart-mode dockerfile-mode
	ellama flycheck go-mode haskell-mode helm-ag helm-lsp
	helm-mode-manager jedi lsp-mode lsp-ui magit matlab-mode
	pkgbuild-mode protobuf-mode python-environment python-mode
	rustic slime slint-mode terraform-mode toml-mode yaml-mode
	yasnippet)))
'(backup-directory-alist (quote (("." . "~/.emacs.d/backup"))))

;;; .emacs ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
