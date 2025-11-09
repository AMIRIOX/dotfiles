;; -*- lexical-binding: t; -*-

;; -1. Avoid * Warning * buffer annoying
(setq warning-minimum-level :error)
(setq native-comp-async-report-warnings-errors nil)

(let ((autosaves (expand-file-name "auto-saves/" user-emacs-directory)))
  (make-directory autosaves t)
  (setq auto-save-file-name-transforms `((".*" ,autosaves t))))

(let ((backups (expand-file-name "backups/" user-emacs-directory)))
  (make-directory backups t)
  (setq backup-directory-alist `(("." . ,backups))
        backup-by-copying t))

;; 0. Download proxt settings
(setq url-retrieve-command "curl -sSL -x http://127.0.0.1:7890 -o %o %s")
(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\|192.168.*\\)")
        ("http" . "127.0.0.1:7890")
        ("https" . "127.0.0.1:7890")))
(setenv "http_proxy" "http://127.0.0.1:7890")
(setenv "https_proxy" "http://127.0.0.1:7890")

;; 1. Basic Settings (Performance and UI)
(when (not (display-graphic-p))
  (set-face-background 'default "unspecified-bg"))
(setq inhibit-startup-message t)
(setq initial-buffer-choice nil)
(setq initial-scratch-message "")
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-saves/" t)))

(global-hl-line-mode 1)
(custom-set-faces
 '(hl-line ((t (:background "#2c2f3a" :extend t)))))
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(add-hook 'after-load-theme-hook
          (lambda ()
            (set-face-background 'mode-line "unspecified-bg")
            (set-face-background 'mode-line-inactive "unspecified-bg")))

(set-face-background 'line-number "unspecified-bg")
(set-face-background 'line-number-current-line "unspecified-bg")


;; 2. Package Management (Bootstrap straight.el and use-package)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(use-package use-package
  :config
  (setq straight-use-package-by-default t
    straight-vc-git-default-clone-depth 1))
    ;straight-vc-git-default-protocol 'ssh)  )

;; 3. Evil-Mode (Vim Emulation)
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (setq evil-insert-state-cursor 'bar)
  (setq evil-normal-state-cursor 'box)
  (setq evil-visual-state-cursor 'box)
  (setq evil-motion-state-cursor 'box)
  (setq evil-operator-state-cursor 'box)
  (setq evil-replace-state-cursor 'hbar)
  (setq evil-emacs-state-cursor 'box)
  (setq evil-echo-state nil)
  (evil-mode 1))

(use-package evil-terminal-cursor-changer
  :straight t
  :after evil
  :config
  (evil-terminal-cursor-changer-activate)
  (setq etcc-insert-state-cursor-shape 'bar)
  (setq etcc-normal-state-cursor-shape 'block)
  (setq etcc-visual-state-cursor-shape 'block)
  (setq etcc-motion-state-cursor-shape 'block)
  (setq etcc-operator-state-cursor-shape 'block)
  (setq etcc-replace-state-cursor-shape 'hbar)
)

(use-package doom-modeline
  :straight t
  :config
  (doom-modeline-mode 1)
  (setq doom-modeline-modal-icon nil
        doom-modeline-buffer-encoding nil
        doom-modeline-checker-simple-format t)
  (setq evil-normal-state-tag   " NORMAL ")
  (setq evil-insert-state-tag   " INSERT ")
  (setq evil-visual-state-tag   " VISUAL ")
  (setq evil-motion-state-tag   " MOTION ")
  (setq evil-replace-state-tag  " REPLACE ")
  (setq evil-operator-state-tag " OPERATOR "))

;(use-package minions
;  :straight t
;  :config
;  (minions-mode 1))

;; 4. Leader Key and Keybinding Management
(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer my-leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package which-key
  :config
  (which-key-mode 1))


;; 5. Project Management (Projectile)
(use-package projectile
  :config
  (projectile-mode +1))


;; 6. Directory Tree (Treemacs)
(use-package treemacs
  :defer t
  :bind ("M-m" . treemacs)
  :config
  (with-eval-after-load 'treemacs
    (define-key treemacs-mode-map (kbd "M-m") #'treemacs))
  ;; -----------------------------
  (treemacs-resize-icons 16)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-project-follow-mode t))

(add-hook 'treemacs-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)))

;; Treemacs integrations
(use-package treemacs-evil
  :after (treemacs evil))
(use-package treemacs-projectile
  :after (treemacs projectile))


;; 7. Core Functionality Keybindings
;; This block is evaluated after `general` has been loaded and `my-leader-keys` defined.
(my-leader-keys
  "f"  '(:ignore t :which-key "File")
  "f f"  '(projectile-find-file :which-key "Find file in project")
  "f g"  '(projectile-ripgrep :which-key "Grep in project"))

;; 8. Load Theme
(use-package dracula-theme
  :demand t
  :config
  (load-theme 'dracula t))

;; 9. Load Dashboard
(use-package dashboard
  :straight t
  :init
  (setq dashboard-center-content t
    dashboard-vertically-center-content t
    dashboard-show-shortcuts nil)
  (setq dashboard-startup-banner "~/.emacs.d/header.txt")
  (setq dashboard-banner-logo-title nil)
  (setq dashboard-projects-backend 'projectile)
  (recentf-mode 1)

  (defun my/dashboard-action-projects ()
    (interactive)
    (if (fboundp 'projectile-switch-project)
        (call-interactively 'projectile-switch-project)
      (user-error "no projectile-switch-project")))

  (defun my/dashboard-action-recents ()
    (interactive)
    (cond
     ((fboundp 'recentf-open-files) (call-interactively 'recentf-open-files))
     (t (user-error "try to enable recentf"))))

  (defun my/dashboard-action-edit-init ()
    (interactive)
    (find-file user-init-file))

  (defun my/dashboard--insert-action-line (label fn)
    (let ((command fn))
      (insert-text-button
       label
       'face 'dashboard-heading
       'help-echo label
       'follow-link t
       'action (lambda (_btn) (funcall command)))
      (insert "\n")))

  (defun my/dashboard-insert-3-actions (_list-size)
    (my/dashboard--insert-action-line "Projects"      #'my/dashboard-action-projects)
    (my/dashboard--insert-action-line "Recent files"  #'my/dashboard-action-recents)
    (my/dashboard--insert-action-line "Edit init.el"  #'my/dashboard-action-edit-init))

  (setq dashboard-set-footer t)
  (setq dashboard-footer-messages
    (list (with-temp-buffer
      (insert-file-contents "~/.emacs.d/footer.txt")
      (buffer-string))))

  :config
  (define-key dashboard-mode-map (kbd "RET") #'push-button)
  (define-key dashboard-mode-map (kbd "<return>") #'push-button)
  (define-key dashboard-mode-map (kbd "<kp-enter>") #'push-button)
  (define-key dashboard-mode-map (kbd "TAB") #'forward-button)
  (define-key dashboard-mode-map (kbd "<backtab>") #'backward-button)
  (add-hook 'dashboard-after-initialize-hook
    (lambda ()
      (goto-char (point-min))
      (forward-button 1 nil t)))

  (setq dashboard-items '((actions . 1)))
  (add-to-list 'dashboard-item-generators
    '(actions . my/dashboard-insert-3-actions))
  (dashboard-setup-startup-hook))

;; 10. LSP
(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred)
  :hook ((c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (python-mode . lsp-deferred))
  :init
  (setq lsp-completion-provider :none    ; 不用自带前端，交给 CAPF
        lsp-prefer-capf t
        lsp-enable-snippet t
        lsp-idle-delay 0.2
        lsp-headerline-breadcrumb-enable nil
        lsp-inhibit-message t)
  :config
  (setq lsp-keymap-prefix "C-c l"))

(with-eval-after-load 'lsp-mode
  (setq lsp-clients-clangd-args
        '("--background-index"
          "--all-scopes-completion"
          "--completion-style=detailed"
          "--header-insertion=never"
          "--pch-storage=memory")))

(use-package lsp-ui
  :straight t
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-delay 0.1)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-show-diagnostics t))

;;; === 前端：Corfu ===
(use-package corfu
  :straight t
  :init
  (global-corfu-mode)
  ;; 禁止在 minibuffer 启用，避免 :wq 弹窗
  (add-hook 'minibuffer-setup-hook (lambda () (corfu-mode -1)))
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 0)        ; 标点后也能弹
  (corfu-auto-delay 0.05)
  (corfu-quit-no-match 'separator)
  (corfu-preselect-first t)
  (corfu-cycle t)
  (corfu-preview-current 'insert)
  :bind
  (:map corfu-map
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)
        ("TAB" . corfu-insert)
        ("RET" . corfu-insert))
  (:map evil-insert-state-map
        ("C-SPC" . completion-at-point)
        ("C-."   . completion-at-point)))

;; 在终端下启用 corfu-terminal
(use-package corfu-terminal
  :straight (corfu-terminal :type git :host codeberg :repo "akib/emacs-corfu-terminal")
  :if (not (display-graphic-p))
  :config (corfu-terminal-mode +1))

;;; === 匹配优化：Orderless ===
(use-package orderless
  :straight t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((lsp-capf (styles orderless))
          (file (styles basic partial-completion)))))

;;; === 补全源扩展：Cape ===
(use-package cape
  :straight t
  :init
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-hook 'completion-at-point-functions #'cape-file   90 t)
              (add-hook 'completion-at-point-functions #'cape-dabbrev 95 t))))
(add-hook 'lsp-completion-mode-hook
          (lambda ()
            (add-hook 'completion-at-point-functions #'lsp-completion-at-point 10 t)))

;;; === 诊断：Flymake ===
(use-package flymake
  :hook ((lsp-mode . flymake-mode))
  :custom
  (flymake-no-changes-timeout 0.3)
  (flymake-start-on-flymake-mode t)
  (flymake-start-on-save-buffer t))

;;; === Evil 下常用快捷键 ===
(with-eval-after-load 'evil
  (evil-define-key 'normal 'global
    (kbd "gd") #'lsp-find-definition
    (kbd "gD") #'lsp-find-declaration
    (kbd "gr") #'lsp-find-references
    (kbd "gi") #'lsp-find-implementation
    (kbd "gR") #'lsp-rename
    (kbd "K")  #'lsp-ui-doc-glance))

;;; === 静音无关 LSP 消息 ===
(setq warning-minimum-level :error)

;; 让 C-n/C-p 在插入态也用于 Corfu，而不是 Evil 自带的补全
(with-eval-after-load 'evil
  (define-key evil-insert-state-map (kbd "C-n") nil)
  (define-key evil-insert-state-map (kbd "C-p") nil)
  (define-key evil-insert-state-map (kbd "C-n") #'corfu-next)
  (define-key evil-insert-state-map (kbd "C-p") #'corfu-previous))

;; 再确保在弹窗里 C-n/C-p 也走 Corfu（双保险）
(with-eval-after-load 'corfu
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-p") #'corfu-previous))

(with-eval-after-load 'corfu
  ;; 精确匹配也保持窗口显示，避免看起来像“只剩一个”
  (setq corfu-on-exact-match 'show
        corfu-preview-current nil         ;; 取消幽灵预览，避免视觉误导
        corfu-quit-no-match nil
        corfu-quit-at-boundary 'separator
        corfu-preselect-first t
        corfu-cycle t))

;; 绝不在 minibuffer 开 corfu（覆盖 corfu-terminal 的影响）
(setq corfu-enable-in-minibuffer nil)

(with-eval-after-load 'evil
  (evil-global-set-key 'normal (kbd "gd") #'lsp-find-definition)
  (evil-global-set-key 'normal (kbd "gD") #'lsp-find-declaration)
  (evil-global-set-key 'normal (kbd "gr") #'lsp-find-references)
  (evil-global-set-key 'normal (kbd "gi") #'lsp-find-implementation)
  (evil-global-set-key 'normal (kbd "gR") #'lsp-rename)
  (evil-global-set-key 'normal (kbd "K")  #'lsp-ui-doc-glance))

(with-eval-after-load 'lsp-mode
  (setq lsp-eldoc-enable-hover nil))       ;; 禁掉 eldoc hover
(with-eval-after-load 'lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-show-with-mouse  nil
        lsp-ui-doc-delay 0.1
        lsp-ui-doc-position 'at-point))

(defun my/disable-corfu-in-minibuffer ()
  (setq-local corfu-auto nil)
  (setq-local completion-in-region-function #'completion--in-region)
  (when (bound-and-true-p corfu-mode)
    (corfu-mode -1)))

(add-hook 'minibuffer-setup-hook #'my/disable-corfu-in-minibuffer)

(with-eval-after-load 'evil
  (add-hook 'evil-ex-setup-hook #'my/disable-corfu-in-minibuffer))

;; Configuration loaded
(message "init.el (final version) loaded successfully!")
