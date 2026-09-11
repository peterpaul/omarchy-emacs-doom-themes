# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Modeline buffer filename color changed from brown to blue for better
  readability.
- Active modeline background now uses a subtle blend of the theme's accent
  color instead of a plain darkened background.

## [0.2.1] - 2026-09-06

### Fixed

- Fixed `doom-omarchy-padded-modeline` customize widget type (`or` → `choice`),
  which crashed the Customize UI when expanding the option.
- The generated theme now `(require 'doom-omarchy)` so its `defcustom`s'
  customize group is always defined, keeping the options nested correctly
  under the `doom-omarchy` group in the Customize UI.

## [0.2.0] - 2026-09-06

### Changed

- Renamed the Emacs library from `omarchy-doom` to `doom-omarchy` to unify the
  prefix with the theme name. It now installs as
  `~/.config/emacs/lisp/doom-omarchy.el`, and its entry points are
  `doom-omarchy-activate` / `doom-omarchy-apply`. The theme's custom options
  now live in the same `doom-omarchy` customize group.

## [0.1.1] - 2026-08-30

### Added

- `doom-omarchy` is now selectable from `M-x customize-themes`. The library
  registers the generated theme's directory on `custom-theme-load-path` (once
  `doom-omarchy-theme.el` exists, and again on each theme change), so Emacs
  lists the theme in the Customize UI like any other theme.

### Changed

- Dropped `omarchy-emacs` from the package's hard dependencies. It remains an
  optional integration: the library advises `omarchy-apply-theme` when present
  and otherwise falls back to its own file watch and the stock Omarchy theme
  directory.
- Added `.SRCINFO` for AUR packaging.

## [0.1.0] - 2026-08-30

### Added

- Doom Emacs theme (`doom-themes`) generated from the active Omarchy theme.
- `~/.config/emacs/lisp/omarchy-doom.el` library that loads the generated
  theme and re-applies it whenever the Omarchy theme changes — advising
  `omarchy-apply-theme` when omarchy-emacs is present, with a file-watch
  fallback otherwise.
- `doom-omarchy-theme.el.tpl` Omarchy template rendered by `omarchy theme set`
  into `~/.local/state/omarchy/current/theme/doom-omarchy-theme.el`, using
  Omarchy's built-in template variables.
- `omarchy-emacs-doom-setup` script to install the library and template.
- `PKGBUILD` for Arch/AUR packaging.
- CI (shellcheck, Emacs byte-compile, template render smoke test).

[Unreleased]: https://github.com/peterpaul/omarchy-emacs-doom-themes/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/peterpaul/omarchy-emacs-doom-themes/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/peterpaul/omarchy-emacs-doom-themes/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/peterpaul/omarchy-emacs-doom-themes/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/peterpaul/omarchy-emacs-doom-themes/releases/tag/v0.1.0