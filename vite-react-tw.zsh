# ─────────────────────────────────────────────────────────────────────────────
# vrt  –  scaffold a Vite + React + Tailwind v4 project
#
# Usage:
#   vrt [project-name] [flags]
#
# Flags:
#   --js          Use JavaScript instead of TypeScript (default: TypeScript)
#   --no-code     Skip opening VS Code after setup
#
# Examples:
#   vrt my-app
#   vrt my-app --js
#   vrt .           # scaffold into the current directory
#   vrt             # prompts you for a project name
#
# Installation:
#   1. Copy this file somewhere, e.g. ~/.zsh/vrt.zsh
#   2. Add the following line to your ~/.zshrc:
#        source ~/.zsh/vrt.zsh
#   3. Reload:  source ~/.zshrc
# ─────────────────────────────────────────────────────────────────────────────

vrt() {
  # ── colours ────────────────────────────────────────────────────────────────
  local RESET='\033[0m'
  local BOLD='\033[1m'
  local GREEN='\033[0;32m'
  local CYAN='\033[0;36m'
  local YELLOW='\033[1;33m'
  local RED='\033[0;31m'

  _vrt_step()  { echo -e "${CYAN}${BOLD}▶ $*${RESET}"; }
  _vrt_ok()    { echo -e "${GREEN}✔ $*${RESET}"; }
  _vrt_warn()  { echo -e "${YELLOW}⚠ $*${RESET}"; }
  _vrt_error() { echo -e "${RED}✖ $*${RESET}"; }

  # ── parse args ─────────────────────────────────────────────────────────────
  local project_name=""
  local use_ts=true
  local open_code=true

  for arg in "$@"; do
    case "$arg" in
      --js)       use_ts=false ;;
      --no-code)  open_code=false ;;
      *)          project_name="$arg" ;;
    esac
  done

  # Prompt if no name given
  if [[ -z "$project_name" ]]; then
    echo -n "Project name (or '.' for current dir): "
    read project_name
    [[ -z "$project_name" ]] && { _vrt_error "No project name provided."; return 1; }
  fi

  local template="react-ts"
  $use_ts || template="react"

  # ── scaffold with vite ─────────────────────────────────────────────────────
  _vrt_step "Creating Vite project → ${BOLD}$project_name${RESET}${CYAN} (template: $template)"

  if [[ "$project_name" == "." ]]; then
    # Scaffold into current directory
    npm create vite@latest . -- --template "$template" || { _vrt_error "Vite scaffold failed."; return 1; }
  else
    npm create vite@latest "$project_name" -- --template "$template" || { _vrt_error "Vite scaffold failed."; return 1; }
    cd "$project_name" || { _vrt_error "Could not cd into $project_name"; return 1; }
  fi

  # ── install base deps ──────────────────────────────────────────────────────
  _vrt_step "Installing dependencies…"
  npm install || { _vrt_error "npm install failed."; return 1; }
  _vrt_ok "Dependencies installed."

  # ── install tailwind v4 ────────────────────────────────────────────────────
  _vrt_step "Installing Tailwind CSS v4 + Vite plugin…"
  npm install tailwindcss @tailwindcss/vite || { _vrt_error "Tailwind install failed."; return 1; }
  _vrt_ok "Tailwind v4 installed."

  # ── patch vite.config ──────────────────────────────────────────────────────
  _vrt_step "Configuring vite.config…"

  local vite_cfg="vite.config.ts"
  $use_ts || vite_cfg="vite.config.js"

  cat > "$vite_cfg" <<'VITECFG'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
  ],
})
VITECFG

  _vrt_ok "vite.config written."

  # ── write index.css ────────────────────────────────────────────────────────
  _vrt_step "Writing src/index.css with Tailwind v4 import…"

  mkdir -p src
  cat > src/index.css <<'TWINDCSS'
@import "tailwindcss";
TWINDCSS

  _vrt_ok "src/index.css ready."

  # ── ensure index.css is imported in main.tsx / main.jsx ───────────────────
  local main_file="src/main.tsx"
  $use_ts || main_file="src/main.jsx"

  if [[ -f "$main_file" ]]; then
    # Add import if it's not already there
    if ! grep -q "index.css" "$main_file"; then
      # Prepend the import at the top of the file
      local tmp_file=$(mktemp)
      echo "import './index.css'" | cat - "$main_file" > "$tmp_file" && mv "$tmp_file" "$main_file"
      _vrt_ok "index.css import added to $main_file"
    else
      _vrt_warn "index.css already imported in $main_file — skipping."
    fi
  else
    _vrt_warn "$main_file not found — make sure you import './index.css' manually."
  fi

  # ── clean up vite boilerplate (optional) ───────────────────────────────────
  _vrt_step "Tidying boilerplate…"

  # Reset App component to a blank slate
  if $use_ts && [[ -f "src/App.tsx" ]]; then
    cat > src/App.tsx <<'APPTSX'
export default function App() {
  return (
    <main className="min-h-screen flex items-center justify-center">
      <h1 className="text-3xl font-bold">Hello, world!</h1>
    </main>
  )
}
APPTSX
    _vrt_ok "src/App.tsx reset."
  elif ! $use_ts && [[ -f "src/App.jsx" ]]; then
    cat > src/App.jsx <<'APPJSX'
export default function App() {
  return (
    <main className="min-h-screen flex items-center justify-center">
      <h1 className="text-3xl font-bold">Hello, world!</h1>
    </main>
  )
}
APPJSX
    _vrt_ok "src/App.jsx reset."
  fi

  # Remove the default Vite SVG assets if present
  [[ -f "src/assets/react.svg" ]]  && rm "src/assets/react.svg"
  [[ -f "public/vite.svg" ]]       && rm "public/vite.svg"
  [[ -f "src/App.css" ]]           && rm "src/App.css"

  # ── done ───────────────────────────────────────────────────────────────────
  echo ""
  echo -e "${GREEN}${BOLD}🚀 Project ready!${RESET}"
  echo -e "   ${BOLD}cd${RESET} $(pwd)"
  echo -e "   ${BOLD}npm run dev${RESET}"
  echo ""

  if $open_code; then
    if command -v code &>/dev/null; then
      _vrt_step "Opening in VS Code…"
      code .
    else
      _vrt_warn "'code' command not found — skipping VS Code launch."
      _vrt_warn "To enable: open VS Code → Cmd+Shift+P → 'Install code command in PATH'"
    fi
  fi
}
