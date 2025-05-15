return {
  -- add ledger
  {
    "ledger/vim-ledger",
    event = { "BufEnter *.ledger" },
    -- Shortcuts for clearing/unclearing (also note that Pending is ! and Unknown is ?)
    keys = {
      {
        "<localleader>C",
        ":call ledger#transaction_state_set(line('.'), '*')<cr>",
        mode = { "n", "v" },
        desc = "Clear Transactions",
      },
      {
        "<localleader>T",
        ":call ledger#transaction_state_toggle(line('.'), ' *?!')<cr>",
        mode = { "n", "v" },
        desc = "Toggle Transactions",
      },
      {
        "<localleader>U",
        ":call ledger#transaction_state_set(line('.'), '')<cr>",
        mode = { "n", "v" },
        desc = "Set Transactions to Uncleared",
      },
    },
  },
}
