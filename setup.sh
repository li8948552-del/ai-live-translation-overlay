#!/bin/bash
# Compatibility entry point. The maintained installer is setup-m2.sh.
set -euo pipefail
exec "$(dirname "$0")/setup-m2.sh" "$@"
