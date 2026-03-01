#!/usr/bin/env bash
set -euo pipefail

# Work around Flutter's Linux native-assets toolchain lookup, which resolves
# clang++ symlinks and then requires linker/archiver binaries in the same dir.
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)"
TOOLCHAIN_BIN_DIR="$ROOT_DIR/toolchain/bin"
export PATH="$TOOLCHAIN_BIN_DIR:$PATH"

if [[ $# -eq 0 ]]; then
  exec /home/kali/flutter/bin/flutter run -d linux
fi

exec /home/kali/flutter/bin/flutter "$@"
