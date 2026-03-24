local M = {}

M.apply_highlights = function()
	local colors = require("themes").get_theme_colors()

	local highlights = {
		-- Cmp Window Styles
		CmpPmenu = { bg = colors.black2, fg = colors.white },
		CmpBorder = { fg = colors.black2, bg = colors.black2 },
		CmpDoc = { bg = colors.darker_black, fg = colors.white },
		CmpDocBorder = { fg = colors.darker_black, bg = colors.darker_black },
		CmpSel = { bg = colors.blue, fg = colors.black, bold = true },

		-- Cmp Item Kinds (Coloring the "Function", "Variable" labels etc.)
		CmpItemAbbr = { fg = colors.white },
		CmpItemAbbrDeprecated = { fg = colors.grey, strikethrough = true },
		CmpItemAbbrMatch = { fg = colors.blue, bold = true },
		CmpItemAbbrMatchFuzzy = { fg = colors.blue, bold = true },
		CmpItemKind = { fg = colors.purple },
		CmpItemMenu = { fg = colors.grey_fg2, italic = true },

		-- Specific Kind Highlights (matching your screenshot's colorful labels)
		CmpItemKindText = { fg = colors.green },
		CmpItemKindMethod = { fg = colors.blue },
		CmpItemKindFunction = { fg = colors.blue },
		CmpItemKindConstructor = { fg = colors.yellow },
		CmpItemKindField = { fg = colors.blue },
		CmpItemKindVariable = { fg = colors.orange },
		CmpItemKindClass = { fg = colors.yellow },
		CmpItemKindInterface = { fg = colors.yellow },
		CmpItemKindModule = { fg = colors.blue },
		CmpItemKindProperty = { fg = colors.blue },
		CmpItemKindUnit = { fg = colors.orange },
		CmpItemKindValue = { fg = colors.orange },
		CmpItemKindEnum = { fg = colors.yellow },
		CmpItemKindKeyword = { fg = colors.purple },
		CmpItemKindSnippet = { fg = colors.red },
		CmpItemKindColor = { fg = colors.red },
		CmpItemKindFile = { fg = colors.blue },
		CmpItemKindReference = { fg = colors.purple },
		CmpItemKindFolder = { fg = colors.blue },
		CmpItemKindEnumMember = { fg = colors.cyan },
		CmpItemKindConstant = { fg = colors.orange },
		CmpItemKindStruct = { fg = colors.yellow },
		CmpItemKindEvent = { fg = colors.yellow },
		CmpItemKindOperator = { fg = colors.cyan },
		CmpItemKindTypeParameter = { fg = colors.green },

		-- Treesitter Highlights
		["@variable"] = { fg = colors.white },
		["@variable.builtin"] = { fg = colors.red },
		["@variable.parameter"] = { fg = colors.orange },
		["@variable.member"] = { fg = colors.orange },

		["@symbol"] = { fg = colors.orange },

		["@constant"] = { fg = colors.orange },
		["@constant.builtin"] = { fg = colors.orange },
		["@constant.macro"] = { fg = colors.orange },

		["@module"] = { fg = colors.blue },
		["@module.builtin"] = { fg = colors.blue },

		["@label"] = { fg = colors.purple },

		["@string"] = { fg = colors.green },
		["@string.documentation"] = { fg = colors.green },
		["@string.regexp"] = { fg = colors.orange },
		["@string.escape"] = { fg = colors.orange },
		["@string.special"] = { fg = colors.orange },

		["@character"] = { fg = colors.yellow },
		["@character.special"] = { fg = colors.yellow },

		["@boolean"] = { fg = colors.orange },
		["@number"] = { fg = colors.orange },
		["@number.float"] = { fg = colors.orange },

		["@type"] = { fg = colors.yellow },
		["@type.builtin"] = { fg = colors.yellow },
		["@type.definition"] = { fg = colors.yellow },
		["@type.qualifier"] = { fg = colors.yellow },

		["@attribute"] = { fg = colors.yellow },
		["@property"] = { fg = colors.blue },

		["@function"] = { fg = colors.blue },
		["@function.builtin"] = { fg = colors.blue },
		["@function.macro"] = { fg = colors.blue },
		["@function.method"] = { fg = colors.blue },

		["@constructor"] = { fg = colors.yellow },
		["@operator"] = { fg = colors.cyan },

		["@keyword"] = { fg = colors.purple },
		["@keyword.function"] = { fg = colors.purple },
		["@keyword.operator"] = { fg = colors.purple },
		["@keyword.return"] = { fg = colors.purple },

		["@punctuation.delimiter"] = { fg = colors.cyan },
		["@punctuation.bracket"] = { fg = colors.white },
		["@punctuation.special"] = { fg = colors.cyan },

		["@comment"] = { fg = colors.grey_fg, italic = true },
		["@comment.documentation"] = { fg = colors.grey_fg },

		["@tag"] = { fg = colors.red },
		["@tag.attribute"] = { fg = colors.orange },
		["@tag.delimiter"] = { fg = colors.cyan },

		-- Standard Syntax Highlights (fallback for non-TS)
		Keyword = { fg = colors.purple },
		Function = { fg = colors.blue },
		String = { fg = colors.green },
		Comment = { fg = colors.grey_fg, italic = true },
		Constant = { fg = colors.orange },
		Type = { fg = colors.yellow },
		Number = { fg = colors.orange },
		Operator = { fg = colors.cyan },
		Delimiter = { fg = colors.cyan },
		Identifier = { fg = colors.white },
		Statement = { fg = colors.purple },
		PreProc = { fg = colors.red },
		Special = { fg = colors.orange },
		Underlined = { underline = true },
		Bold = { bold = true },
		Italic = { italic = true },
		Error = { fg = colors.red, bold = true },
		Todo = { fg = colors.black, bg = colors.yellow, bold = true },

		-- General UI
		Normal = { fg = colors.white, bg = colors.black },
		NormalFloat = { fg = colors.white, bg = colors.black },
		FloatBorder = { fg = colors.grey, bg = colors.black },
		LineNr = { fg = colors.grey, bg = colors.black },
		CursorLineNr = { fg = colors.white, bg = colors.black, bold = true },
		CursorLine = { bg = colors.black2 },
		SignColumn = { bg = colors.black },
		VertSplit = { fg = colors.line, bg = colors.black },
		EndOfBuffer = { fg = colors.black, bg = colors.black }, -- Hide the ~ tildes
		MsgArea = { fg = colors.white, bg = colors.black }, -- Message area at bottom
		Pmenu = { bg = colors.black2, fg = colors.white },
		PmenuSel = { bg = colors.blue, fg = colors.black, bold = true },
		PmenuSbar = { bg = colors.black },
		PmenuThumb = { bg = colors.grey },

		-- Diagnostics (NvChad Style)
		DiagnosticError = { fg = colors.red },
		DiagnosticWarn = { fg = colors.yellow },
		DiagnosticInfo = { fg = colors.blue },
		DiagnosticHint = { fg = colors.cyan },

		DiagnosticSignError = { fg = colors.red },
		DiagnosticSignWarn = { fg = colors.yellow },
		DiagnosticSignInfo = { fg = colors.blue },
		DiagnosticSignHint = { fg = colors.cyan },

		DiagnosticFloatingError = { fg = colors.red },
		DiagnosticFloatingWarn = { fg = colors.yellow },
		DiagnosticFloatingInfo = { fg = colors.blue },
		DiagnosticFloatingHint = { fg = colors.cyan },

		DiagnosticVirtualTextError = { bg = "NONE", fg = colors.red },
		DiagnosticVirtualTextWarn = { bg = "NONE", fg = colors.yellow },
		DiagnosticVirtualTextInfo = { bg = "NONE", fg = colors.blue },
		DiagnosticVirtualTextHint = { bg = "NONE", fg = colors.cyan },

		DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
		DiagnosticUnderlineWarn = { sp = colors.yellow, undercurl = true },
		DiagnosticUnderlineInfo = { sp = colors.blue, undercurl = true },
		DiagnosticUnderlineHint = { sp = colors.cyan, undercurl = true },
	}

	for group, opts in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, opts)
	end

	-- Sync Ghostty terminal colors (OSC 11: background, OSC 10: foreground)
	if colors.black and colors.white then
		io.write(string.format("\27]11;%s\7", colors.black))
		io.write(string.format("\27]10;%s\7", colors.white))
	end
end

return M
