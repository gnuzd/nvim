local M = {}

function M.apply_highlights(colors)
    local hl = vim.api.nvim_set_hl
    
    -- Define base UI highlights
    hl(0, "Normal", { fg = colors.white, bg = colors.black })
    hl(0, "CursorLine", { bg = colors.black2 })
    hl(0, "LineNr", { fg = colors.grey })
    hl(0, "CursorLineNr", { fg = colors.white })
    hl(0, "Visual", { bg = colors.grey_fg })
    hl(0, "Search", { fg = colors.black, bg = colors.yellow })
    hl(0, "EndOfBuffer", { fg = colors.black })
    
    -- Gitsigns/Diff
    hl(0, "DiffAdd", { fg = colors.green })
    hl(0, "DiffChange", { fg = colors.blue })
    hl(0, "DiffDelete", { fg = colors.red })

    -- Syntax
    hl(0, "Keyword", { fg = colors.purple, bold = true })
    hl(0, "Function", { fg = colors.blue })
    hl(0, "String", { fg = colors.green })
    hl(0, "Comment", { fg = colors.grey_fg, italic = true })
    hl(0, "Constant", { fg = colors.orange })
    hl(0, "Type", { fg = colors.yellow })
    hl(0, "Variable", { fg = colors.white })
    hl(0, "Identifier", { fg = colors.red })

    -- Border and UI elements
    hl(0, "FloatBorder", { fg = colors.blue, bg = colors.black2 })
    hl(0, "NormalFloat", { bg = colors.black2 })
    hl(0, "LspFloatWinNormal", { bg = colors.black2 })
    hl(0, "StatusLine", { fg = colors.white, bg = colors.black2 })
    hl(0, "WinSeparator", { fg = colors.grey })
    hl(0, "VertSplit", { fg = colors.grey })

    -- Statusline Highlights
    hl(0, "StatusLineNormal", { fg = colors.black, bg = colors.blue, bold = true })
    hl(0, "StatusLineInsert", { fg = colors.black, bg = colors.green, bold = true })
    hl(0, "StatusLineVisual", { fg = colors.black, bg = colors.purple, bold = true })
    hl(0, "StatusLineReplace", { fg = colors.black, bg = colors.red, bold = true })
    hl(0, "StatusLineCommand", { fg = colors.black, bg = colors.yellow, bold = true })
    
    hl(0, "StatusLineFile", { fg = colors.white, bg = colors.grey, bold = true })
    hl(0, "StatusLineGit", { fg = colors.orange, bg = colors.black2 })
    hl(0, "StatusLineLsp", { fg = colors.cyan, bg = colors.black2 })
    hl(0, "StatusLineError", { fg = colors.red, bg = colors.black2 })
    hl(0, "StatusLinePos", { fg = colors.white, bg = colors.grey })

    -- TODO Highlights
    hl(0, "TodoComment", { fg = colors.blue, bg = colors.black2, bold = true })
    hl(0, "FixmeComment", { fg = colors.red, bg = colors.black2, bold = true })
    hl(0, "BugComment", { fg = colors.orange, bg = colors.black2, bold = true })
    hl(0, "NoteComment", { fg = colors.green, bg = colors.black2, bold = true })

    -- Diagnostics Highlights (Trouble-like)
    hl(0, "DiagListError", { fg = colors.red })
    hl(0, "DiagListWarn", { fg = colors.yellow })
    hl(0, "DiagListInfo", { fg = colors.blue })
    hl(0, "DiagListHint", { fg = colors.cyan })

    -- Completion Menu Highlights
    hl(0, "Pmenu", { fg = colors.white, bg = colors.black2 }) -- Background of the menu
    hl(0, "PmenuSel", { fg = colors.black, bg = colors.blue }) -- Background of the selected item
    hl(0, "PmenuSbar", { bg = colors.black2 })
    hl(0, "PmenuThumb", { bg = colors.grey })
    
    -- Custom Explorer Highlights
    hl(0, "TreeExplorerRoot", { fg = colors.green, bold = true })
    hl(0, "TreeExplorerConnector", { fg = colors.grey })
    hl(0, "TreeExplorerFolderIcon", { fg = colors.yellow })
    hl(0, "TreeExplorerFileIcon", { fg = colors.blue })
    hl(0, "TreeExplorerFolderName", { fg = colors.white, bold = true })
    hl(0, "TreeExplorerFileName", { fg = colors.white })
end

return M
