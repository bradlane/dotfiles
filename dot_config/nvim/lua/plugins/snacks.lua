return {
  "folke/snacks.nvim",
  dependencies = {
    "echasnovski/mini.icons",
  },
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    indent = {
      enabled = true,
      chunk = { enabled = true },
      animate = { enabled = false },
      scope = {
        treesitter = { enabled = true },
      },
    },
    input = { enabled = true },
    git = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          actions = {
            -- close snacks explorer when opening a file
            expand_dir_open_file = function(picker, item)
              if item.dir then
                picker:action("confirm")
              else
                picker:action({ "confirm", "close" })
              end
            end,
          },
          win = {
            list = {
              keys = {
                ["<CR>"] = "expand_dir_open_file",
              },
            },
          },
        },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    styles = {
      notification = {
        wo = { wrap = true },
      },
    },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    -- stylua: ignore start
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.files() end,     desc = "Find Files", },
    { "<leader>,", function() Snacks.picker.buffers() end,         desc = "Buffers", },
    { "<leader>/", function() Snacks.picker.grep() end,            desc = "Grep", },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History", },
    { "<leader>n", function() Snacks.picker.notifications() end,   desc = "Notification History", },
    { "<leader>e", function() Snacks.picker.explorer() end,        desc = "File Explorer", },
    { "<leader>.", function() Snacks.scratch() end,                desc = "Scratch Buffer" },

    -- buffer
    { "<leader>bb", "<cmd>e #<cr>",                           desc = "Switch to Other Buffer" },
    { "<leader>bd", function() Snacks.bufdelete() end,        desc = "Delete Buffer" },

    -- find
    { "<leader>ff", function() Snacks.picker.files() end,     desc = "Find Files", },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files", },
    { "<leader>fp", function() Snacks.picker.projects() end,  desc = "Projects", },
    { "<leader>fr", function() Snacks.picker.recent() end,    desc = "Recent", },

    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches", },
    { "<leader>gg", function() Snacks.lazygit() end,             desc = "Lazygit", },
    { "<leader>gl", function() Snacks.picker.git_log() end,      desc = "Git Log", },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line", },
    { "<leader>gs", function() Snacks.picker.git_status() end,   desc = "Git Status", },
    { "<leader>gS", function() Snacks.picker.git_stash() end,    desc = "Git Stash", },
    { "<leader>gd", function() Snacks.picker.git_diff() end,     desc = "Git Diff (Hunks)", },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File", },

    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end,        desc = "Buffer Lines", },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers", },
    { "<leader>sg", function() Snacks.picker.grep() end,         desc = "Grep", },
    { "<leader>sw", function() Snacks.picker.grep_word() end,    desc = "Visual selection or word", mode = { "n", "x" }, },

    -- search
    --{ "<leader>s",       function() Snacks.picker.registers() end,                  desc = "Registers", },
    { "<leader>s/", function() Snacks.picker.search_history() end,     desc = "Search History", },
    { "<leader>sa", function() Snacks.picker.autocmds() end,           desc = "Autocmds", },
    { "<leader>sb", function() Snacks.picker.lines() end,              desc = "Buffer Lines", },
    { "<leader>sc", function() Snacks.picker.command_history() end,    desc = "Command History", },
    { "<leader>sC", function() Snacks.picker.commands() end,           desc = "Commands", },
    { "<leader>sd", function() Snacks.picker.diagnostics() end,        desc = "Diagnostics", },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics", },
    { "<leader>sh", function() Snacks.picker.help() end,               desc = "Help Pages", },
    { "<leader>sH", function() Snacks.picker.highlights() end,         desc = "Highlights", },
    { "<leader>si", function() Snacks.picker.icons() end,              desc = "Icons", },
    { "<leader>sj", function() Snacks.picker.jumps() end,              desc = "Jumps", },
    { "<leader>sk", function() Snacks.picker.keymaps() end,            desc = "Keymaps", },
    { "<leader>sl", function() Snacks.picker.loclist() end,            desc = "Location List", },
    { "<leader>sm", function() Snacks.picker.marks() end,              desc = "Marks", },
    { "<leader>sM", function() Snacks.picker.man() end,                desc = "Man Pages", },
    { "<leader>sp", function() Snacks.picker.lazy() end,               desc = "Search for Plugin Spec", },
    { "<leader>sq", function() Snacks.picker.qflist() end,             desc = "Quickfix List", },
    { "<leader>sR", function() Snacks.picker.resume() end,             desc = "Resume", },
    { "<leader>su", function() Snacks.picker.undo() end,               desc = "Undo History", },
    --{ "<leader>uC", function() Snacks.picker.colorschemes() end,       desc = "Colorschemes", },

    -- LSP
    { "<leader>cl", function() Snacks.picker.lsp_config() end,            desc = "Lsp Info", },
    { "gd",         function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition", },
    { "gD",         function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration", },
    { "gR",         function() Snacks.picker.lsp_references() end,        desc = "References",               nowait = true, },
    { "gI",         function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation", },
    { "gy",         function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition", },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols", },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols", },
    -- stylua: ignore end
  },
}
