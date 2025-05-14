return {
	adapters = {
		deepseek = function()
			return require("codecompanion.adapters").extend("ollama", {
				name = "deepseek",
				schema = {
					env = {
						endpoint = "http://localhost:11434/api",
					},

					model = {
						default = "deepseek-r1:1.5b",
					},
					num_ctx = {
						default = 16384,
					},
					num_predict = {
						default = -1,
					},
				},
			})
		end,
	},
	strategies = {
		chat = {
			adapter = "deepseek",
		},
		inline = {
			adapter = "deepseek",
		},
		cmd = {
			adapter = "deepseek",
		},
	},
}
