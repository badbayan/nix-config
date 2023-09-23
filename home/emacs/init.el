;;; init.el --- initialization file -*- lexical-binding: t -*-

;;; Commentary:
;; `init.el'

;;; Code:

(let ((normal-gc-cons-threshold (* 20 1024 1024)))
  (setq gc-cons-threshold most-positive-fixnum)
  (add-hook 'emacs-startup-hook
            (lambda ()
              (setq gc-cons-threshold normal-gc-cons-threshold)
              (message "%s" (emacs-init-time)))))
(fset 'display-startup-echo-area-message 'ignore)

(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'tooltip-mode) (tooltip-mode -1))

(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(setq-default
 auto-save-default nil
 backup-inhibited t
 column-number-mode t
 completion-category-defaults nil
 completion-category-overrides '((file (styles partial-completion)))
 completion-styles '(basic flex partial-completion)
 create-lockfiles nil
 custom-file (locate-user-emacs-file "custom.el")
 default-input-method "russian-computer"
 display-line-numbers-type 't
 ediff-split-window-function 'split-window-sensibly
 ediff-window-setup-function 'ediff-setup-windows-plain
 epa-pinentry-mode 'loopback
 font-use-system-font t
 indent-tabs-mode nil
 indicate-empty-lines t
 inhibit-startup-buffer-menu t
 inhibit-startup-screen t
 initial-scratch-message nil
 kill-buffer-query-functions nil
 make-backup-files nil
 ;; mode-line-compact 'long
 mouse-wheel-flip-direction t
 mouse-wheel-follow-mouse t
 mouse-wheel-progressive-speed nil
 mouse-wheel-scroll-amount '(3 ((shift) . hscroll))
 mouse-wheel-tilt-scroll nil
 recentf-max-saved-items 200
 require-final-newline t
 scroll-conservatively 10000
 scroll-margin 5
 select-enable-clipboard nil
 select-enable-primary nil
 server-client-instructions nil
 tab-bar-close-button-show nil
 tab-bar-new-button-show nil
 tab-line-close-button-show nil
 tab-line-exclude-modes nil
 tab-line-new-button-show nil
 tab-width 4
 truncate-partial-width-windows 32
 use-dialog-box nil
 use-file-dialog nil
 use-short-answers t
 use-system-tooltips nil
 ;; vc-handled-backends nil
 visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow)
 whitespace-style '(face tabs trailing newline)
 word-wrap-by-category t)
(load custom-file t)

(set-face-attribute 'default nil :family "Monospace")
(set-face-attribute 'fixed-pitch nil :family "Monospace")
(set-face-attribute 'fixed-pitch-serif nil :family "Monospace")
(set-face-attribute 'variable-pitch nil :family "Sans Serif")

(electric-indent-mode 1)
(electric-pair-mode 1)
;; (fido-vertical-mode 1)
;; (global-display-line-numbers-mode 1)
(global-visual-line-mode 1)
(global-whitespace-mode 1)
(mouse-wheel-mode 1)
(pixel-scroll-precision-mode 1)
(recentf-mode 1)
(xterm-mouse-mode 1)

;; (add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; (define-key icomplete-minibuffer-map (kbd "TAB") 'icomplete-force-complete)
;; (define-key icomplete-minibuffer-map (kbd "C-h") 'icomplete-vertical-goto-first)
;; (define-key icomplete-minibuffer-map (kbd "C-j") 'icomplete-forward-completions)
;; (define-key icomplete-minibuffer-map (kbd "C-k") 'icomplete-backward-completions)
;; (define-key icomplete-minibuffer-map (kbd "C-l") 'icomplete-vertical-goto-last)

(global-set-key (kbd "C-S-c") #'(lambda () (interactive)
                                  (let ((select-enable-clipboard t)) (kill-ring-save nil nil t))))
(global-set-key (kbd "C-S-v") #'(lambda () (interactive)
                                  (let ((select-enable-clipboard t)) (yank))))
(global-set-key (kbd "C-x C-b") #'(lambda () (interactive)
                                    (switch-to-buffer (other-buffer (current-buffer) 1))))
(global-set-key (kbd "C-x j") 'kill-current-buffer)
(global-set-key (kbd "C-<") 'bs-cycle-previous)
(global-set-key (kbd "C->") 'bs-cycle-next)
(global-set-key (kbd "<f7>") 'global-hl-line-mode)
(global-set-key (kbd "<f8>") 'indent-tabs-mode)
(global-set-key (kbd "<f9>") 'revert-buffer-with-coding-system)



(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package)
  (require 'use-package-ensure)
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(use-package almost-mono-themes :demand t)

(use-package circadian
  :init
  (setq
   circadian-themes
   '(("00:00" . almost-mono-black)
     ("04:00" . almost-mono-gray)
     ("08:00" . almost-mono-cream)
     ("12:00" . almost-mono-white)
     ("16:00" . almost-mono-cream)
     ("20:00" . almost-mono-gray)))
  :config (circadian-setup))

(use-package evil
  :hook (after-init . evil-mode)
  :init
  (setq
   evil-move-beyond-eol t
   evil-search-module 'evil-search
   evil-undo-system 'undo-tree
   evil-want-keybinding nil
   evil-want-C-i-jump nil
   evil-want-C-u-scroll t))
(use-package evil-collection :after evil
  :config (evil-collection-init))
(use-package evil-easymotion :after evil
  :config (evilem-default-keybindings "SPC"))

(use-package minions
  :hook (after-init . minions-mode)
  :init (setq minions-prominent-modes '(flymake-mode)))

(use-package undo-tree
  :init (setq undo-tree-auto-save-history nil)
  :config (global-undo-tree-mode 1))



(use-package consult
  :bind (("C-c M-x" . consult-mode-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-g o" . consult-outline)
         ("M-s d" . consult-find)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines))
  :init (setq-default xref-show-xrefs-function #'consult-xref
                      xref-show-definitions-function #'consult-xref)
  :config (consult-customize consult-buffer :preview-key "C-."))

(use-package jinx
  :hook (text-mode . jinx-mode)
  :bind ([remap ispell-word] . jinx-correct)
  :init (setq-default jinx-languages "ru_RU en_GB en_US de_DE es_ES it_IT pl_PL")
  :config (add-to-list 'jinx-exclude-regexps '(t "[[:blank:]]*-[[:blank:]]*")))

(use-package marginalia
  :hook (icomplete-minibuffer-setup . (lambda () (setq truncate-lines t)))
  :config (marginalia-mode 1))

(use-package vertico :demand t
  :bind
  (:map vertico-map
        ("C-h" . vertico-first)
        ("C-j" . vertico-next)
        ("C-k" . vertico-previous)
        ("C-l" . vertico-last)
        ;; ("SPC" . minibuffer-complete-word)
        ("RET" . vertico-directory-enter)
        ("DEL" . vertico-directory-delete-char)
        ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :init
  (setq
   read-file-name-completion-ignore-case t
   read-buffer-completion-ignore-case t
   completion-ignore-case t)
  :config (vertico-mode 1))



(setq-default
 auto-mode-alist
 (append
  '(("CMakeLists\\.txt\\'" . cmake-ts-mode)
    ("\\.cmake\\'" . cmake-ts-mode)
    ("Dockerfile\\'" . dockerfile-ts-mode)
    ("\\.go\\'" . go-ts-mode)
    ("/go\\.mod\\'" . go-mod-ts-mode)
    ;; ("\\.nix\\'" . nix-ts-mode)
    ("\\.rs\\'" . rust-ts-mode)
    ("\\.tsx\\'" . tsx-ts-mode)
    ("\\.ts\\'" . typescript-ts-mode)
    ("\\.y[a]?ml\\'" . yaml-ts-mode))
  auto-mode-alist)
 major-mode-remap-alist
 (append
  '((c-mode . c-ts-mode)
    (c++-mode . c++-ts-mode)
    (c-or-c++-mode . c-or-c++-ts-mode)
    (conf-toml-mode . toml-ts-mode)
    (csharp-mode . csharp-ts-mode)
    (css-mode . css-ts-mode)
    (java-mode . java-ts-mode)
    (js-mode . js-ts-mode)
    (js-json-mode . json-ts-mode)
    (python-mode . python-ts-mode)
    (ruby-mode . ruby-ts-mode)
    (sh-mode . bash-ts-mode))
  major-mode-remap-alist))

(use-package haskell-mode :defer t
  :hook (haskell-mode . interactive-haskell-mode))
(use-package markdown-mode :defer t)
(use-package meson-mode :defer t)
(use-package nix-mode :defer t)
;; (use-package nix-ts-mode :defer t)
(use-package zig-mode :defer t)

(use-package corfu
  :hook (eglot-managed-mode . corfu-mode)
  :init
  (setq
   corfu-auto t
   ;; corfu-auto-delay 0
   corfu-auto-prefix 2
   corfu-echo-delay 0
   corfu-popupinfo-delay 0)
  :config (corfu-echo-mode 1)
  (corfu-popupinfo-mode 1))

(use-package eglot
  :after yasnippet
  :hook
  (c-mode . eglot-ensure)
  (c-ts-mode . eglot-ensure)
  (c++-mode . eglot-ensure)
  (c++-ts-mode . eglot-ensure)
  (c-or-c++-mode . eglot-ensure)
  (c-or-c++-ts-mode . eglot-ensure)
  (go-mode . eglot-ensure)
  (go-ts-mode . eglot-ensure)
  (haskell-mode . eglot-ensure)
  (nix-mode . eglot-ensure)
  (rust-mode . eglot-ensure)
  (rust-ts-mode . eglot-ensure)
  (zig-mode . eglot-ensure)
  :init
  (setq-default
   eglot-autoshutdown t
   eglot-confirm-server-initiated-edits nil
   read-process-output-max (* 1024 1024))
  (add-to-list 'completion-category-overrides '(eglot (styles flex)) t)
  :config
  (setq-default
   eglot-server-programs
   (append
    '(((nix-mode) . ("nil")))
    eglot-server-programs)))

(use-package envrc
  :config (envrc-global-mode 1))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode))

(provide 'init)

;;; init.el ends here
