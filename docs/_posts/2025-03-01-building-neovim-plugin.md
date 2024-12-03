---
title: Building a Neovim Plugin
date: 2025-03-01 00:00:00
featured_image: https://images.unsplash.com/photo-1489846986031-7cea03ab8fd0?q=75&fm=jpg&w=1000&fit=max
excerpt: Creating Neovim plugins with Lua can significantly enhance your development workflow. This guide will walk you through building a simple plugin that displays a daily quote.
keywords: lua, neovim, vim, neovim-plugins
---

![](https://images.unsplash.com/photo-1489846986031-7cea03ab8fd0?q=75&fm=jpg&w=1000&fit=max)

Creating Neovim plugins with Lua can significantly enhance your development workflow. This guide will walk you through building a simple plugin that displays a daily quote using the `:Quote` command.

In a nutshell the plugin is supposed to do a curl request to fetch a quote from different sources whenever we type `:Quote` command.

```
$ curl https://zenquotes.io/api/today -s | jq '.[0].q'

"Get busy living or get busy dying"
```

### Plugin Architecture

Neovim plugins typically follow a specific structure:

```
plugin_name/
├── lua/
│   └── module/
│       ├── init.lua
│       └── sub_modules.lua
└── plugin/
    └── plugin_name.lua
```

- The `lua/` directory contains the main plugin logic.
- The `plugin/` directory holds files that are automatically executed when Neovim starts.

Let's start to build the new plugin

#### Setup

First, let's set up the plugin directory locally from a neovim plugin template:

```bash
$ git clone https://github.com/Clivern/teacup.nvim.git
$ mv teacup.nvim quote.nvim
$ cd quote.nvim
$ rm -rf .git
$ git init
$ git branch -m main

# Replace with your repository
$ git remote add origin git@github.com:Clivern/quote.nvim.git
$ git push -u origin main
```

#### Plugin Loading

During development, you can load the plugin from a directory.

```lua
-- lazy.nvim
{
    dir = "~/plugins/quote.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
},
```

Once the plugin is working as expected, you can switch to the remote github repository.

```lua
-- lazy.nvim
{
    "clivern/quote.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    }
},
```

#### Implementing the Quote Fetcher

Create `lua/site/zenquotes.lua`. This module uses plenary.nvim to fetch a quote from Zenquotes API. In case the HTTP request fails for any reason, it will show a specific error message.

```lua
--- file lua/site/zenquotes.lua
local curl = require("plenary.curl")
local json = vim.fn.json_decode

local M = {}

---@return string
M.get_zen_quote = function()
  local response = curl.get("https://zenquotes.io/api/today")

  if response.status == 200 then
    local data = json(response.body)

    if data and type(data) == "table" and #data > 0 then
      return data[1].q
    else
      return "The Quote Well Has Run Dry!"
    end
  else
    return "The Quote Well Has Run Dry!"
  end
end

return M
```

#### Main Plugin Logic

Create `lua/quote.lua`:

```lua
-- lua/quote.lua
local zq = require("site.zenquotes")

---@class Config
local config = {
  site = "zenquotes",
}

local M = {}

---@type Config
M.config = config

-- get quote method
M.get_quote = function()
  if M.config.site == "zenquotes" then
    return zq.get_zen_quote()
  else
    return "No Quotes for You... Until Setup is Complete!"
  end
end

-- Execute plugin
M.execute = function()
  vim.api.nvim_create_user_command("Quote", function()
    vim.notify(M.get_quote())
  end, {})
end

-- Setup method
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
  M.execute()
end

return M
```

This module defines the plugin's core functionality:

- `config`: Stores plugin configuration.
- `get_quote`: Retrieves a quote based on the configured site.
- `execute`: Creates the `:Quote` command.
- `setup`: Initializes the plugin with user-defined options.

The final plugin source code is [published on github](https://github.com/Clivern/quote.nvim)
