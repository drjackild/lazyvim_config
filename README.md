# 💤 My LazyVim Configuration

Based on a starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## 📝 Notes Configuration

This configuration supports both **Obsidian** (via `obsidian.nvim`) and **Zk** (via `zk-nvim`) as note-taking backends. You can configure the backend and notes path per-workspace or globally.

### Per-Workspace Configuration (Recommended)

Create a `.neoconf.json` file in your **workspace root** (the directory where your notes are stored or the root of your project):

```json
{
  "notes": {
    "backend": "obsidian", // or "zk"
    "path": "~/zettel", // Optional: override default path
    "daily_folder": "journal/daily" // Optional: override default "daily" folder
  }
}
```

### Global Configuration

Alternatively, you can set global variables in your `lua/config/options.lua` or `init.lua`:

```lua
vim.g.notes_backend = "zk"
vim.g.notes_path = "~/personal-notes"
```

The default backend is `obsidian` and the default path is `~/zettel`.

### Keymaps

The notes keymaps are grouped under `<leader>o` (labeled as **Org** in Which-Key):

- `<leader>on`: New Note
- `<leader>os`: Search Notes
- `<leader>ot`: Today's Note
- `<leader>ob`: Backlinks
- `<leader>oo`: Open in App (Obsidian only)
- `<leader>op`: Picker (Obsidian only)
