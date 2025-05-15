return {
  {
    "Saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      -- Don't show completion menu until I press ctrl-space.
      opts.completion.menu.auto_show = false

      -- Don't consider ghost text visible.
      local function is_open()
        return require("blink.cmp.completion.windows.menu").win:is_open()
        -- or require('blink.cmp.completion.windows.ghost_text').is_open()
      end
      local function if_open_then(cmd)
        return function(cmp)
          return is_open() and cmp[cmd]()
        end
      end
      -- local function show_menu()
      --   if is_open() then
      --     return
      --   end
      --   return true
      -- end
      --
      opts.keymap = {
        preset = "default",
        -- ["<C-space>"] = { show_menu, "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { if_open_then("accept"), "fallback" },
        ["<Tab>"] = { "accept", "fallback" },
        ["<Up>"] = { if_open_then("select_prev"), "fallback" },
        ["<Down>"] = { if_open_then("select_next"), "fallback" },
        ["<C-p>"] = { if_open_then("select_prev"), "fallback" },
        ["<C-n>"] = { if_open_then("select_next"), "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      }
    end,
  },
}
