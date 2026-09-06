;;; doom-omarchy.el --- A Doom theme generated from the active Omarchy theme -*- lexical-binding: t; -*-
;;
;; The Omarchy theme engine renders `doom-omarchy-theme.el' into the
;; active Omarchy theme directory.  This library applies it to Emacs: at
;; startup, and whenever the Omarchy theme changes.  Use it with
;;
;;   (require 'doom-omarchy)
;;   (doom-omarchy-activate)
;;
;; and re-apply manually with M-x doom-omarchy-apply.
;;
;; It works with or without the omarchy-emacs integration:
;; `omarchy-apply-theme' is advised when it is present, and a small file
;; watch is installed as a fallback otherwise.  When doom-themes is not
;; installed (e.g. the powerline appearance style) the plugin is inert and
;; Emacs keeps whatever theme it already has.
;;; Code:

(require 'cl-lib)

(declare-function file-notify-add-watch "filenotify" (file flags callback))
(declare-function file-notify-rm-watch "filenotify" (descriptor))

(defgroup doom-omarchy nil
  "Use a Doom theme generated from the active Omarchy theme."
  :group 'doom-themes)

(defcustom doom-omarchy-theme 'doom-omarchy
  "Theme symbol generated from the active Omarchy theme."
  :type 'symbol
  :group 'doom-omarchy)

(defconst doom-omarchy--theme-file-name "doom-omarchy-theme.el"
  "Name of the Doom theme file generated into the active Omarchy theme.")

(defun doom-omarchy--theme-directory ()
  "Return the directory holding the active Omarchy theme's assets.
Prefer the one the omarchy-emacs integration computed; fall back to the
two standard Omarchy locations (4 then 3)."
  (cond
   ((and (boundp 'omarchy-theme-directory) omarchy-theme-directory)
    omarchy-theme-directory)
   ((file-directory-p "~/.local/state/omarchy/current/theme")
    "~/.local/state/omarchy/current/theme")
   ((file-directory-p "~/.config/omarchy/current/theme")
    "~/.config/omarchy/current/theme")))

(defun doom-omarchy--theme-file ()
  "Return the generated Doom theme file, or nil if it is unavailable."
  (when-let* ((dir (doom-omarchy--theme-directory))
              (file (expand-file-name doom-omarchy--theme-file-name dir))
              ((file-readable-p file)))
    file))

(defun doom-omarchy--register-theme ()
  "Make the generated Doom theme selectable in `M-x customize-themes'.

Emacs discovers themes by scanning `custom-theme-load-path' for files
named `THEME-theme.el', so the generated theme's directory is added there
once the theme file exists.  Idempotent; safe to call repeatedly."
  (when-let* ((dir (doom-omarchy--theme-directory))
              (theme-file (expand-file-name doom-omarchy--theme-file-name dir))
              ((file-readable-p theme-file)))
    (add-to-list 'custom-theme-load-path dir)))

(defun doom-omarchy--forget-theme ()
  "Forget generated themes so a reload redefines them cleanly."
  (dolist (theme (cons doom-omarchy-theme '(omarchy omarchy-dark omarchy-light)))
    (disable-theme theme)
    (setq custom-known-themes (delq theme custom-known-themes))
    (put theme 'theme-settings nil)))

(defun doom-omarchy-apply ()
  "Apply the Omarchy-generated Doom theme, replacing the current one.
No-op when doom-themes is not available, or when Omarchy has not
generated a theme yet (its assets appear after the first
`omarchy theme set')."
  (interactive)
  (if (not (require 'doom-themes nil t))
      (progn
        (message "doom-omarchy: doom-themes is not available; keeping current theme")
        nil)
    (if-let* ((file (doom-omarchy--theme-file)))
        (progn
          (dolist (theme (copy-sequence custom-enabled-themes))
            (disable-theme theme))
          (doom-omarchy--forget-theme)
          (load-file file)
          (enable-theme doom-omarchy-theme)
          (message "Enabled %s from %s" doom-omarchy-theme file)
          t)
      (message "doom-omarchy: no generated theme yet; run `omarchy theme refresh' after setting a theme")
      nil)))

(defvar doom-omarchy--watch nil
  "File notification descriptor for Omarchy theme changes.")

(defun doom-omarchy--watch-setup ()
  "Watch the Omarchy theme for changes when the omarchy one is absent."
  (when (and (not doom-omarchy--watch)
             (not (fboundp 'omarchy-apply-theme))
             (require 'filenotify nil t)
             (file-exists-p "~/.local/state/omarchy/current/theme.name"))
    (setq doom-omarchy--watch
          (file-notify-add-watch
           "~/.local/state/omarchy/current/theme.name" '(change)
           (lambda (_event)
             (doom-omarchy--register-theme)
             (doom-omarchy-apply))))))

(defun doom-omarchy-activate ()
  "Apply the Omarchy Doom theme now and on every Omarchy theme change."
  (interactive)
  (when (fboundp 'omarchy-apply-theme)
    (advice-remove 'omarchy-apply-theme #'doom-omarchy-apply)
    (advice-add 'omarchy-apply-theme :after #'doom-omarchy-apply))
  (doom-omarchy--watch-setup)
  (doom-omarchy--register-theme)
  (add-hook 'after-init-hook #'doom-omarchy-apply -50))

(provide 'doom-omarchy)
;;; doom-omarchy.el ends here