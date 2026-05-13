<div align="center">

```
██╗   ██╗██████╗ ████████╗
██║   ██║██╔══██╗╚══██╔══╝
██║   ██║██████╔╝   ██║
╚██╗ ██╔╝██╔══██╗   ██║
 ╚████╔╝ ██║  ██║   ██║
  ╚═══╝  ╚═╝  ╚═╝   ╚═╝
```

**vrt** — _Vite + React + Tailwind, scaffolded in seconds._

[![Shell](https://img.shields.io/badge/shell-zsh-89e051?style=flat-square&logo=gnubash&logoColor=white)](https://www.zsh.org/)
[![Vite](https://img.shields.io/badge/vite-6.x-646CFF?style=flat-square&logo=vite&logoColor=white)](https://vitejs.dev/)
[![React](https://img.shields.io/badge/react-19.x-61DAFB?style=flat-square&logo=react&logoColor=black)](https://react.dev/)
[![Tailwind CSS](https://img.shields.io/badge/tailwind-v4-38BDF8?style=flat-square&logo=tailwindcss&logoColor=white)](https://tailwindcss.com/)

</div>

---

Tired of running the same five commands every time you start a new project? `vrt` is a single zsh function that goes from an empty folder to a fully configured **Vite + React + Tailwind v4** project — with a clean `App.tsx`, wired-up config, and VS Code open — in one command.

```zsh
vrt my-app
```

That's it.

---

## ✨ What it does

| Step | Action |
|---|---|
| 🏗️ | Scaffolds a Vite project (`react-ts` or `react`) |
| 📦 | Runs `npm install` |
| 🎨 | Installs `tailwindcss` + `@tailwindcss/vite` (the v4 Vite plugin — no PostCSS needed) |
| ⚡ | Rewrites `vite.config.ts` with the Tailwind plugin wired in |
| 🖌️ | Writes `src/index.css` with `@import "tailwindcss"` |
| 🔗 | Prepends the CSS import into `main.tsx` if missing |
| 🧹 | Strips Vite boilerplate (default SVGs, `App.css`) |
| 💻 | Opens the project in VS Code |

---

## 📦 Installation

**1. Download the script**

```zsh
curl -o ~/.zsh/vrt.zsh https://raw.githubusercontent.com/Build-and-Break-BNB/vrt/main/vite-react-tw.zsh
```

> Or clone the repo and copy manually:
> ```zsh
> git clone https://github.com/Build-and-Break-BNB/vrt.git
> mkdir -p ~/.zsh && cp vrt/vite-react-tw.zsh ~/.zsh/vrt.zsh
> ```

**2. Source it in your `.zshrc`**

```zsh
echo 'source ~/.zsh/vrt.zsh' >> ~/.zshrc
```

**3. Reload your shell**

```zsh
source ~/.zshrc
```

Done. The `vrt` command is now available everywhere.

---

## 🚀 Usage

```zsh
vrt [project-name] [flags]
```

### Examples

```zsh
# TypeScript project (default)
vrt my-app

# Scaffold into the current directory
vrt .

# JavaScript instead of TypeScript
vrt my-app --js

# Skip opening VS Code
vrt my-app --no-code

# No args — prompts you for a name
vrt
```

### Flags

| Flag | Description |
|---|---|
| `--js` | Use JavaScript instead of TypeScript |
| `--no-code` | Skip launching VS Code after setup |

---

## 📁 What you get

```
my-app/
├── src/
│   ├── App.tsx          ← clean slate component, ready to go
│   ├── index.css        ← @import "tailwindcss"
│   └── main.tsx         ← CSS import added automatically
├── vite.config.ts       ← react() + tailwindcss() plugins configured
├── package.json
├── tsconfig.json
└── index.html
```

**`App.tsx`** starts you off with:

```tsx
export default function App() {
  return (
    <main className="min-h-screen flex items-center justify-center">
      <h1 className="text-3xl font-bold">Hello, world!</h1>
    </main>
  )
}
```

**`vite.config.ts`** is pre-configured:

```ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
  ],
})
```

---

## 🔧 Requirements

- [Node.js](https://nodejs.org/) (v18+)
- [npm](https://www.npmjs.com/) (comes with Node)
- [zsh](https://www.zsh.org/) as your shell
- [VS Code](https://code.visualstudio.com/) _(optional — for auto-open)_

> To enable the `code` CLI in VS Code: **Cmd+Shift+P** → _"Shell Command: Install 'code' command in PATH"_

---

## 💡 Tips

**Use it in an existing empty folder:**
```zsh
mkdir my-project && cd my-project && vrt .
```

**Add an alias if you want an even shorter command:**
```zsh
# in ~/.zshrc
alias v='vrt'
```

---

## 🤝 Contributing

PRs welcome! Ideas for future flags:
- `--router` — add React Router
- `--eslint` — scaffold with ESLint + Prettier config
- `--shadcn` — init shadcn/ui after setup

---

## 📄 Licence

[MIT](LICENSE) — use it, fork it, ship it.

---

<div align="center">
  <sub>Made for developers who'd rather be building than configuring.</sub>
</div>
