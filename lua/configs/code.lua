return {
	provider = "gemini",
	gemini = {
		generationConfig = {
			stopSequences = { "test" },
		},
	},
	-- provider = "ollama",
	-- ollama = {
	-- 	model = "llama3.2",
	-- 	model = "deepseek-r1:1.5b",
	-- 	endpoint = "http://127.0.0.1:11434",
	-- },
}
