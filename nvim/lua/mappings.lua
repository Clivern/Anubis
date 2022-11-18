--[[

MIT License

Copyright (c) 2010 Clivern

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]

require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find File with Telescope" })

local function print_version()
    print("Anubis v5.4.0")
end

map("n", "<leader>v", print_version, { desc = "Get Version" })

local function run_command()
    -- Prompt user for input
    local cmd = vim.fn.input("Enter command: ")

    -- Execute the command and capture the output
    local handle = io.popen(cmd)
    local result = handle:read("*a")  -- Read all output
    handle:close()

    -- Use vim.notify to show the result
    vim.notify(result, vim.log.levels.INFO, { title = "Command Output" })
end

-- Map run_command function to <leader>ru
map("n", "<leader>ru", run_command, { desc = "Run Local Command" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
