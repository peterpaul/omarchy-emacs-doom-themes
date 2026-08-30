# omarchy-emacs-doom-themes

An Arch package that ships a [Doom Emacs](https://github.com/doomemacs/themes)
theme generated from the active [Omarchy](https://omarchy.org) theme. Built as
a companion to [omarchy-emacs](https://github.com/scottjones/omarchy-emacs):
while that package keeps Emacs' regular faces in sync with the desktop, this
one renders a `doom-themes` port so you can use a unified Doom appearance.

## What it provides

- **`~/.config/emacs/lisp/omarchy-doom.el`** — an Emacs library that loads the
  generated Doom theme and re-applies it whenever the Omarchy theme changes.
  It advises `omarchy-apply-theme` when omarchy-emacs is present, and installs
  a small file-watch fallback otherwise.
- **`doom-omarchy-theme.el.tpl`** — an Omarchy template rendered by
  `omarchy theme set` into `~/.local/state/omarchy/current/theme/doom-omarchy-theme.el`.
  It uses Omarchy's built-in template variables (`{background_strip}`,
  `{mix_strip a b 0.5}`, the full ANSI palette, etc.), so it works on stock
  Omarchy 4 with no extra machinery.

When doom-themes is not installed, the library is inert and Emacs keeps
whatever theme it already has.

## Install

```
yay -S omarchy-emacs-doom-themes
omarchy-emacs-doom-setup
```

`omarchy-emacs-doom-setup` installs the library and template into your
`~/.config/`, re-renders the current theme, and reloads a running Emacs daemon.

You also need the `doom-themes` Emacs package (e.g. via elpaca/use-package):

```elisp
(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  (doom-themes-padded-modeline t)
  :config
  (doom-themes-org-config))
```

Then load the library and apply it:

```elisp
(add-to-list 'load-path "~/.config/emacs/lisp")
(use-package omarchy-doom
  :config
  (omarchy-doom-activate)
  (omarchy-doom-apply))
```

## What gets installed where

| Path | Status |
|------|--------|
| `~/.config/emacs/lisp/omarchy-doom.el` | **Yours** — copied only if missing. Edit to taste; survives upgrades. |
| `~/.config/omarchy/themed/doom-omarchy-theme.el.tpl` | **Managed** — overwritten on every setup run and package upgrade. |
| `~/.local/state/omarchy/current/theme/doom-omarchy-theme.el` | **Generated** — re-rendered by `omarchy theme set`. |

## Customizing

- The theme defines `doom-omarchy-brighter-modeline`,
  `doom-omarchy-brighter-comments`, `doom-omarchy-comment-bg` and
  `doom-omarchy-padded-modeline` as `defcustom`s. Set them before applying.
- To tune colors for your setup, edit the generated
  `doom-omarchy-theme.el` or adjust the template in
  `~/.config/omarchy/themed/`.

## Developing

`dev/try-theme` renders the working-tree template through Omarchy's own
resolver and opens it in a throwaway Emacs, without installing anything and
without touching your live theme:

```
dev/try-theme                 # the current Omarchy theme
dev/try-theme tokyo-night     # any installed theme, by directory name
dev/try-theme --list          # what is installed
dev/try-theme --tty gruvbox   # terminal frame instead of a GUI window
```

## License

MIT — see [LICENSE](LICENSE).

Issues and PRs welcome.
