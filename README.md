# Teleport Menu

Adds simple buttons to the game menu (esc key) to use your hearthstone(s) and teleports quick and easy.

## Development Environment

To ensure a consistent development environment, please use the following tools and configurations:

### 1. Lua Language Server by Sumneko

- We highly recommend using the Lua Language Server by Sumneko for code completion, error checking, and other language features.
- Install the Lua Language Server extension in your preferred code editor (e.g., VS Code).
- Configure the server to use the WoW API definitions (see below).

### 2. Stylua

- We use Stylua for code formatting to maintain a consistent code style.
- Install Stylua and configure your editor to use it for Lua files.
- Our project uses tab indentation with a tab size of 4. Ensure your Stylua configuration matches this.
- Example Stylua configuration in .editorconfig:

```
indent_style = tab
indent_size = 4
quote_style = double
```

### 3. VSCode WoW API by Ketho

- For VS Code users, we strongly recommend installing the VSCode WoW API extension by Ketho.
- This extension provides API definitions and code completion for the World of Warcraft Lua API, which is essential for addon development.
    - This extension is vital for using the Sumneko Lua language server with the WoW API.
