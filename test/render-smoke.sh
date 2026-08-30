#!/usr/bin/env bash
# Smoke test: render the theme template through Omarchy's resolver and confirm
# no template variable is left unresolved. Mirrors what `omarchy theme set`
# does for the installed template.
set -euo pipefail

REPO=$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)
TPL="$REPO/doom-omarchy-theme.el.tpl"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

command -v omarchy-theme-set-templates >/dev/null || {
  echo "SKIP: omarchy-theme-set-templates not on PATH"
  exit 0
}

# Pick the current theme, or the first installed one with a colors.toml.
theme=$(cat "$HOME/.local/state/omarchy/current/theme.name" 2>/dev/null || true)
colors=""
if [[ -n $theme && -f "${OMARCHY_PATH:-/usr/share/omarchy}/themes/$theme/colors.toml" ]]; then
  colors="${OMARCHY_PATH:-/usr/share/omarchy}/themes/$theme/colors.toml"
elif [[ -f "$HOME/.config/omarchy/themes/$theme/colors.toml" ]]; then
  colors="$HOME/.config/omarchy/themes/$theme/colors.toml"
else
  colors=$(ls -1 "${OMARCHY_PATH:-/usr/share/omarchy}"/themes/*/colors.toml \
            "$HOME/.config/omarchy"/themes/*/colors.toml 2>/dev/null | head -1 || true)
fi
[[ -n ${colors:-} && -f ${colors:-} ]] || { echo "SKIP: no theme colors.toml to render"; exit 0; }

NEXT="$TMP/.local/state/omarchy/current/next-theme"
mkdir -p "$NEXT" "$TMP/.config/omarchy/themed"
cp "$colors" "$NEXT/colors.toml"
cp "$TPL" "$TMP/.config/omarchy/themed/"

OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}" HOME="$TMP" \
  omarchy-theme-set-templates >/dev/null 2>&1

out="$NEXT/doom-omarchy-theme.el"
[[ -f $out ]] || { echo "FAIL: render produced no doom-omarchy-theme.el"; exit 1; }

if grep -q '{{' "$out"; then
  echo "FAIL: unresolved template variables for '$theme':"
  grep -o '{{[^}]*}}' "$out" | sort -u | sed 's/^/  /'
  exit 1
fi

echo "OK: doom-omarchy-theme.el rendered cleanly for '$theme'"
