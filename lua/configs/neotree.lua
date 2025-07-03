return {
	auto_clean_after_session_restore = true,
	close_if_last_window = true,
	default_component_configs = {
		indent = { padding = 0 },
		modified = { symbol = "" },
		git_status = {
			symbols = {
				added = "",
				deleted = "",
				modified = "",
				renamed = "➜",
				untracked = "★",
				ignored = "◌",
				unstaged = "✗",
				staged = "✓",
				conflict = "",
			},
		},
	},
	cwd_target = "none",
	popup_border_style = "rounded",
	event_handlers = {
		{
			event = "file_open_requested",
			handler = function()
				require("neo-tree.command").execute({ action = "close" })
			end,
		},
	},
	commands = {
		parent_or_close = function(state)
			local node = state.tree:get_node()
			if (node.type == "directory" or node:has_children()) and node:is_expanded() then
				state.commands.toggle_node(state)
			else
				require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
			end
		end,
		child_or_open = function(state)
			local node = state.tree:get_node()
			if node.type == "directory" or node:has_children() then
				if not node:is_expanded() then -- if unexpanded, expand
					state.commands.toggle_node(state)
				else -- if expanded and has children, seleect the next child
					require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
				end
			else -- if not a directory just open it
				state.commands.open(state)
			end
		end,
	},
	window = {
		position = "left",
		width = 30,
		mappings = {
			["<space>"] = false,
			h = "parent_or_close",
			l = "child_or_open",
		},
	},
	filesystem = {
		follow_current_file = { enabled = true },
		hijack_netrw_behavior = "open_current",
		use_libuv_file_watcher = true,
		window = {
			mappings = {
				["\\"] = "close_window",
			},
		},
	},
}
