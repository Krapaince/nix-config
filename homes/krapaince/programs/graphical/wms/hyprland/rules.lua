local nix = require("nix")

hl.layer_rule({
	match = { namespace = "match:namespace ^(" .. nix.program.rofi .. ")$" },
	no_anim = true,
})

-- Smart gaps
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

local rules = {
	-- Smart gaps
	{ match = { float = false, workspace = "w[tv1]" }, border_size = 0 },
	{ match = { float = false, workspace = "w[tv1]" }, rounding = 0 },
	{ match = { float = false, workspace = "f[1]" }, border_size = 0 },
	{ match = { float = false, workspace = "f[1]" }, rounding = 0 },

	{ match = { title = "^dragon-drop$" }, pin = true },
	{ match = { title = "^(?:Coping|Moving) - Dolphin" }, float = true },

	{ match = { class = "firefox" }, idle_inhibit = "fullscreen" },
	{ match = { title = "^Opening", class = "firefox" }, float = true },
	{
		match = { title = "^Picture-in-Picture$" },
		float = true,
		idle_inhibit = "fullscreen",
		move = "((monitor_w*0.5)) ((monitor_h*0.01))",
		pin = true,
	},

	{ match = { class = "^Matplotlib$" }, float = true },
	{ match = { class = "protonvpn-app" }, float = true },

	{ match = { title = "^satty$" }, float = true },

	{
		match = {
			title = "^Floating Window - Show Me The Key$",
		},
		no_blur = true,
		float = true,
		pin = true,
		opacity = "1.0 override 1.0 override",
	},

	{ match = { class = "vlc" }, idle_inhibit = "fullscreen" },
}

for _, rule in pairs(rules) do
	hl.window_rule(rule)
end
