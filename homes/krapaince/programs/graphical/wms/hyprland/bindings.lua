local nix = require("nix")

local mainMod = "ALT"

local directions = {
	h = "l",
	j = "d",
	k = "u",
	l = "r",
}

local bindings = {
	-- TODO make it start a tmux session
	{ mainMod .. " + Return", hl.dsp.exec_cmd(nix.program.alacritty .. " -e " .. nix.program.tmux .. " new") },
	{ mainMod .. " + D", hl.dsp.exec_cmd(nix.program.rofi .. " -show drun -theme ~/.config/rofi/config.rasi") },

	{ "SUPER + Up", hl.dsp.exec_cmd(nix.script.lock .. " -f && " .. nix.script.suspend) },
	{ "SUPER + Right", hl.dsp.exec_cmd(nix.script.lock) },

	{ "CTRL + Space", hl.dsp.exec_cmd(nix.program["swaync-client"] .. " --hide-latest") },
	{ mainMod .. " + t", hl.dsp.exec_cmd(nix.program["swaync-client"] .. " -t") },

	{ "Print", hl.dsp.exec_cmd(nix.script.screenshot) },
	{ mainMod .. " + Print", hl.dsp.exec_cmd(nix.script.screenshotEdit) },

	{ mainMod .. " + SHIFT + Q", hl.dsp.window.close() },
	{ mainMod .. " + SHIFT + E", hl.dsp.exec_cmd('loginctl terminate-user ""') },
	{ mainMod .. " + SHIFT + P", hl.dsp.window.pin() },
	{ "CTRL + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }) },
	{ mainMod .. " + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }) },
	{ mainMod .. " + SHIFT + f", hl.dsp.window.fullscreen({ mode = "maximized" }) },

	{ "CTRL + ALT + h", hl.dsp.focus({ workspace = "e-1" }) },
	{ "CTRL + ALT + l", hl.dsp.focus({ workspace = "e+1" }) },

	{ "XF86AudioMute", hl.dsp.exec_cmd(nix.script.pipewireControl .. " togmute"), { locked = true } },
	{
		"XF86AudioMicMute",
		hl.dsp.exec_cmd(nix.program.pactl .. " set-source-mute @DEFAULT_SOURCE@ toggle"),
		{ locked = true },
	},
	{ "F4", hl.dsp.exec_cmd(nix.program.pactl .. " set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true } },
	{ "XF86AudioNext", hl.dsp.exec_cmd(nix.program.playerctl .. " next"), { locked = true } },
	{ "XF86AudioPrev", hl.dsp.exec_cmd(nix.program.playerctl .. " previous"), { locked = true } },
	{ "XF86AudioPause", hl.dsp.exec_cmd(nix.program.playerctl .. " play-pause"), { locked = true } },
	{ "switch:on:Lid Switch", hl.dsp.exec_cmd(nix.script.lock .. " -f && " .. nix.script.suspend), { locked = true } },
	{
		"XF86AudioRaiseVolume",
		hl.dsp.exec_cmd(nix.script.pipewireControl .. " up"),
		{ locked = true, repeating = true },
	},
	{
		"XF86AudioLowerVolume",
		hl.dsp.exec_cmd(nix.script.pipewireControl .. " down"),
		{ locked = true, repeating = true },
	},
	{
		"XF86MonBrightnessDown",
		hl.dsp.exec_cmd(nix.program.brightnessctl .. " -c backlight set 10%-"),
		{ locked = true, repeating = true },
	},
	{
		"XF86MonBrightnessUp",
		hl.dsp.exec_cmd(nix.program.brightnessctl .. " -c backlight set 10%+"),
		{ locked = true, repeating = true },
	},

	{ mainMod .. " + mouse:272", hl.dsp.window.drag() },
	{ mainMod .. " + mouse:273", hl.dsp.window.resize() },

	{ mainMod .. " + w", hl.dsp.group.toggle() },
	{ mainMod .. " + SHIFT + w", hl.dsp.window.move({ out_of_group = true }) },
	{ mainMod .. " + g", hl.dsp.submap("group") },
	{ mainMod .. " + m", hl.dsp.submap("media") },
	{ mainMod .. " + r", hl.dsp.submap("resize") },
}

hl.define_submap("group", function()
	hl.bind(mainMod .. " + t", hl.dsp.group.lock({ action = "toggle" }))

	hl.bind("h", hl.dsp.group.prev())
	hl.bind("l", hl.dsp.group.next())

	for key, direction in pairs(directions) do
		hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ into_group = direction }))
	end

	hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.define_submap("media", function()
	hl.bind("h", hl.dsp.exec_cmd(nix.program.playerctl .. " previous"))
	hl.bind("l", hl.dsp.exec_cmd(nix.program.playerctl .. " next"))
	hl.bind("p", hl.dsp.exec_cmd(nix.program.playerctl .. " play-pause"))

	hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.define_submap("resize", function()
	hl.bind("h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
	hl.bind("l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })

	for key, direction in pairs(directions) do
		hl.bind(mainMod .. " + " .. key, hl.dsp.workspace.move({ monitor = direction }))
	end

	hl.bind("escape", hl.dsp.submap("reset"))
end)

for key, direction in pairs(directions) do
	table.insert(bindings, { mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }) })
	table.insert(bindings, { mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }) })
end

for i = 1, 10 do
	local key = i % 10 -- 10 -> 0

	table.insert(bindings, { mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }) })
	table.insert(bindings, { mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }) })
end

for _, binding in ipairs(bindings) do
	local key = binding[1]
	local dispatcher = binding[2]
	local options = binding[3] or {}

	hl.bind(key, dispatcher, options)
end

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
