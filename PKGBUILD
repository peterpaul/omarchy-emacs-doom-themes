# Maintainer: Peterpaul Klein Haneveld <pp.kleinhaneveld@gmail.com>
pkgname=omarchy-emacs-doom-themes
pkgver=0.1.1
pkgrel=1
pkgdesc="A Doom Emacs theme (doom-themes) generated from the active Omarchy theme"
arch=('any')
url="https://github.com/peterpaul/omarchy-emacs-doom-themes"
license=('MIT')
depends=('bash' 'emacs')
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/v$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
  cd "$srcdir/$pkgname-$pkgver"

  # Install the Emacs library that applies the generated Doom theme.
  install -dm755 "$pkgdir/usr/share/omarchy-emacs-doom-themes/config/lisp"
  install -Dm644 config/lisp/omarchy-doom.el \
    "$pkgdir/usr/share/omarchy-emacs-doom-themes/config/lisp/omarchy-doom.el"

  # Install the theme template consumed by `omarchy theme set`.
  install -Dm644 doom-omarchy-theme.el.tpl \
    "$pkgdir/usr/share/omarchy-emacs-doom-themes/doom-omarchy-theme.el.tpl"

  # Install the setup script to PATH.
  install -Dm755 bin/omarchy-emacs-doom-setup \
    "$pkgdir/usr/bin/omarchy-emacs-doom-setup"

  # Install license.
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
