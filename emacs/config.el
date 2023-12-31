(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package doom-themes
  :init (load-theme 'doom-city-lights t))

(defvar efs/default-font-size 130)
(defvar efs/default-variable-font-size 130)

(set-face-attribute 'default nil :font "JetBrains Mono NerdFont" :weight 'semibold :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "JetBrains Mono NerdFont" :weight 'semibold :height efs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "JetBrains Mono NerdFont" :height efs/default-variable-font-size :weight 'regular)

(setq inhibit-startup-message t)

  (scroll-bar-mode -1)        ; Disable visible scrollbar
  (tool-bar-mode -1)          ; Disable the toolbar
  (tooltip-mode -1)           ; Disable tooltips
  (set-fringe-mode 10)        ; Give some breathing room

  (menu-bar-mode -1)            ; Disable the menu bar

  ;; Set up the visible bell
  (setq visible-bell nil)

  (column-number-mode)
  (global-display-line-numbers-mode t)

  ;; Disable line numbers for some modes
  (dolist (mode '(org-mode-hook
		  term-mode-hook
		  shell-mode-hook
	          treemacs-mode-hook
		  eshell-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode 0))))
(setq scroll-conservatively 1)

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 32)))

(setq backup-directory-alist '((".**" . "~/.local/share/Trash/files")))

(use-package rainbow-delimiters
 :hook (prog-mode . rainbow-delimiters-mode))

(defun efs/org-mode-setup ()
        (org-indent-mode)
        (auto-fill-mode 0)
        (setq evil-auto-indent nil)
        (variable-pitch-mode 1)
        (visual-line-mode 1))

      (use-package org
        :hook (org-mode . efs/org-mode-setup)
        :config
        (setq org-ellipsis " ▾"))

      (use-package org-bullets
        :after org
        :hook (org-mode . org-bullets-mode)
        :custom
        (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

      (defun efs/org-mode-visual-fill ()
        (setq visual-fill-column-width 100
              visual-fill-column-center-text t)
        (visual-fill-column-mode 1))

      (use-package visual-fill-column
        :hook (org-mode . efs/org-mode-visual-fill))

      (use-package toc-org
          :commands toc-org-enable
          :init (add-hook 'org-mode-hook 'toc-org-enable))

      (font-lock-add-keywords 'org-mode
                              '(("^ *\\([-]\\) "
                                  (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
      ;; Set faces for heading levels
      (dolist (face '((org-level-1 . 1.2)
                      (org-level-2 . 1.1)
                      (org-level-3 . 1.05)
                      (org-level-4 . 1.0)
                      (org-level-5 . 1.1)
                      (org-level-6 . 1.1)
                      (org-level-7 . 1.1)
                      (org-level-8 . 1.1)))
        (set-face-attribute (car face) nil :font "JetBrains Mono NerdFont" :weight 'regular :height (cdr face)))

      ;; Ensure that anything that should be fixed-pitch in Org files appears that way
      (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
      (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

  ;; active Babel languages
  (org-babel-do-load-languages
  'org-babel-load-languages
  '((C . t)
  (python . t)
  (emacs-lisp . t)))

  (setq org-confirm-babel-evaluate nil)

  
(require 'org-tempo)
(setq org-agenda-files '("~/Documents/college/"))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "." '(counsel-find-file :which-key "Counsel Find File")
    "p" '(counsel-linux-app :which-key "Counsel Linux Application Menu")
    "o" '(org-agenda :which-key "Org Agenda Menu")
    ))

(setq ivy-initial-inputs-alist nil)
