;;; omarchy-doom.el --- A Doom theme generated from the active Omarchy theme -*- lexical-binding: t; -*-
;;
;; The Omarchy theme engine renders `doom-omarchy-theme.el' into the
;; active Omarchy theme directory.  This library applies it to Emacs: at
;; startup, and whenever the Omarchy theme changes.  Use it with
;;
;;   (require 'omarchy-doom)
;;   (omarchy-doom-activate)
;;
;; and re-apply manually with M-x omarchy-doom-apply.
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

(defgroup omarchy-doom nil
  "Use a Doom theme generated from the active Omarchy theme."
  :group 'doom-themes)

(defcustom omarchy-doom-theme 'doom-omarchy
  "Theme symbol generated from the active Omarchy theme."
  :type 'symbol
  :group 'omarchy-doom)

(defconst omarchy-doom--theme-file-name "doom-omarchy-theme.el"
  "Name of the Doom theme file generated into the active Omarchy theme.")

(defun omarchy-doom--theme-directory ()
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

(defun omarchy-doom--theme-file ()
  "Return the generated Doom theme file, or nil if it is unavailable."
  (when-let* ((dir (omarchy-doom--theme-directory))
              (file (expand-file-name omarchy-doom--theme-file-name dir))
              ((file-readable-p file)))
    file))

(defun omarchy-doom--forget-theme ()
  "Forget generated themes so a reload redefines them cleanly."
  (dolist (theme (cons omarchy-doom-theme '(omarchy omarchy-dark omarchy-light)))
    (disable-theme theme)
    (setq custom-known-themes (delq theme custom-known-themes))
    (put theme 'theme-settings nil)))

(defun omarchy-doom-apply ()
  "Apply the Omarchy-generated Doom theme, replacing the current one.
No-op when doom-themes is not available, or when Omarchy has not
generated a theme yet (its assets appear after the first
`omarchy theme set')."
  (interactive)
  (if (not (require 'doom-themes nil t))
      (progn
        (message "omarchy-doom: doom-themes is not available; keeping current theme")
        nil)
    (if-let* ((file (omarchy-doom--theme-file)))
        (progn
          (dolist (theme (copy-sequence custom-enabled-themes))
            (disable-theme theme))
          (omarchy-doom--forget-theme)
          (load-file file)
          (enable-theme omarchy-doom-theme)
          (message "Enabled %s from %s" omarchy-doom-theme file)
          t)
      (message "omarchy-doom: no generated theme yet; run `omarchy theme refresh' after setting a theme")
      nil)))

(defvar omarchy-doom--watch nil
  "File notification descriptor for Omarchy theme changes.")

(defun omarchy-doom--watch-setup ()
  "Watch the Omarchy theme for changes when the omarchy one is absent."
  (when (and (not omarchy-doom--watch)
             (not (fboundp 'omarchy-apply-theme))
             (require 'filenotify nil t)
             (file-exists-p "~/.local/state/omarchy/current/theme.name"))
    (setq omarchy-doom--watch
          (file-notify-add-watch
           "~/.local/state/omarchy/current/theme.name" '(change)
           (lambda (_event) (omarchy-doom-apply))))))

(defun omarchy-doom-activate ()
  "Apply the Omarchy Doom theme now and on every Omarchy theme change."
  (interactive)
  (when (fboundp 'omarchy-apply-theme)
    (advice-remove 'omarchy-apply-theme #'omarchy-doom-apply)
    (advice-add 'omarchy-apply-theme :after #'omarchy-doom-apply))
  (omarchy-doom--watch-setup)
  (add-hook 'after-init-hook #'omarchy-doom-apply -50))

(provide 'omarchy-doom)
;;; omarchy-doom.el ends here