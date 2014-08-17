;;------------------------------------------------------------------------------
;; Provide go mode, managed by MELPA.  Serveral methods in go-mode needs go
;; related binaries be properly set, e.g. godoc, dodef, etc.  For my configs,
;; all these binaries are installed under ~/code/source/go-workspace/bin, refer
;; to ~/.unixrc/install.sh. The go environment variables are set in .zshrc.
;;
;; Feature:
;;   go-autocomplete: Provide context sensitive auto completion for Go. The
;;     feature needs auto-complete be set up first; also, it needs gocode
;;     installed on the system (gocode in PATH).
;;
;; Usage:
;;   M-x godoc  ; give a package name, show docs in view-mode.
;;   M-x gofmt  ; format current go buffer.
;;   M-.        ; jump to the definition of symbol.
;;   M-*        ; jump back.
;;------------------------------------------------------------------------------
(require-package 'go-mode)
(require 'go-mode)

(require-package 'go-autocomplete)
(require 'go-autocomplete)


(defun go-mode-custom-hook ()
  (local-set-key (kbd "M-.") 'godef-jump))

(add-hook 'go-mode-hook 'go-mode-custom-hook)


(provide 'init-go-mode)