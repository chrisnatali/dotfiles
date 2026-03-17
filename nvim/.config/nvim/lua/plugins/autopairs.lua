-- TODO: Determine if we should just disable autopairs via
--return {
--   { "windwp/nvim-autopairs", enabled = false },
--}
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)
    local Rule = require("nvim-autopairs.rule")

    -- Disable quote pairing in Python specifically
    if vim.bo.filetype == "python" then
      -- Remove all quote rules for Python
      npairs.clear_rules()
      -- Add back non-quote default rules if needed
      -- e.g., only bracket rules or any custom you want
    end
  end,
}
