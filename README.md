# PoSH-Nvim

**The Production-Ready Neovim Configuration for PowerShell Engineers.**

VS Code is a web browser. The ISE is a corpse. You are an engineer; stop fighting your tools and start commanding them.

PoSHNvim is a "drop-in" Neovim distribution built specifically for the Windows ecosystem. It prioritizes stability, standard keybinds, and immediate utility over flashy animations. It bridges the gap between the Windows terminal and the speed of modal editing.

Projects like LazyVim or LunarVim are fantastic, but they are built for Linux-first Web Developers. They treat PowerShell support as an afterthought. PoSHVim is built on Windows, for Windows. We don't assume you have sed, awk, or grep. We assume you have Get-ChildItem and Select-String.

### Why Neovim for PowerShell?
If you can script in PowerShell, you already know how to configure Neovim.
* **Lua Tables** `{ key = "value" }` are just **Hashtables** `@{ key = "value" }`.
* **Plugins** are just **Modules**.
* **Buffers** are just **Pipeline Objects**.

This configuration is opinionated but risk-averse. It includes a fully configured LSP (Intellisense), GitHub Copilot integration, and Git management via LazyGit, all running natively in your terminal. 

**Stop clicking. Start shipping.**
---

## 1. Prerequisites (Run in Admin Terminal)
Neovim requires external binaries to function correctly. Node is unfortunately required for Copilot (I know, it sucks, but it's the engine).

```powershell
# 1. Core Editor & Git
winget install -e --id Neovim.Neovim
winget install -e --id Git.Git

# 2. Copilot Requirement (NodeJS v18+) - Required for AI
winget install -e --id OpenJS.NodeJS.LTS

# 3. Git UI (LazyGit) - The TUI interface
winget install -e --id JesseDuffield.LazyGit

# 4. Optional: C Compiler (Zig) - Helps Treesitter compile language parsers on Windows
winget install -e --id zig.zig

# 5. Optional: Nerd Font - Required for file icons (DevIcons) to render
# See This neat Powershell wrapper for more options: https://github.com/jpawlowski/nerd-fonts-installer-PS
& ([scriptblock]::Create((iwr 'https://to.loredo.me/Install-NerdFont.ps1')))
```
## 2. Custom Keymap Reference
**Leader Key:** `-` (Dash)

### Intellisense (LSP & Autocomplete)
| Key | Mode | Action |
| :--- | :--- | :--- |
| `gd` | Normal | **Go to Definition** (Jumps to function/cmdlet source) |
| `K` | Normal | **Hover Doc** (Shows cmdlet syntax/help popup) |
| `Tab` | Insert | **Autocomplete Menu** (Select next list suggestion) |
| `S-Tab` | Insert | **Autocomplete Back** (Select previous list suggestion) |

### AI (GitHub Copilot)
| Key | Mode | Action |
| :--- | :--- | :--- |
| `Alt + l` | Insert | **Accept Ghost Text** (Commits the gray inline suggestion) |
| `Alt + ]` | Insert | **Next Suggestion** (Cycle forward through ghost text options) |
| `-cc` | Normal | **Toggle Chat** (Opens the floating Copilot window) |
| `-ce` | Normal | **Explain Code** (Ask Copilot to explain selection/cursor) |
| `-cf` | Normal | **Fix Code** (Ask Copilot to fix bugs/errors in selection) |
| `-cr` | Normal | **Reset Chat** (Clear conversation history) |

### Git Management (LazyGit)
| Key | Mode | Action |
| :--- | :--- | :--- |
| `-gg` | Normal | **Open LazyGit Dashboard** (Full TUI for Staging/Commits/Push) |

### Core & UI
| Key | Mode | Action |
| :--- | :--- | :--- |
| `-e` | Normal | **Switch between Neo Tree and the editor** |
| `-h` | Normal | **Clear Highlights** (Removes search highlighting) |
| `-r` | Normal | **Toggle Relative Numbers** (Switches relative/absolute) |
| `-n` | Normal | **Enable Line Numbers** (`set number`) |
| `-nn` | Normal | **Disable Line Numbers** (`set nonumber`) |
| `-m` | Normal | **Enable Mouse** (Click/scroll enabled) |
| `-mm` | Normal | **Disable Mouse** (Pure keyboard mode) |
| `jj` | Insert | **Escape** (Instant exit from Insert Mode) |

## 3. Post-Install Checks
1. Open Neovim.
2. Run `:checkhealth` to verify all providers (Node, Git, Python) are detected.
3. Run `:Copilot auth` to sign into GitHub.
4. Run `:Lazy` to check plugin status.
