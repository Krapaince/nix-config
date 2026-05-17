require("bindings")
require("rules")
require("monitors")

local nix = require("nix")

local animationEnabled = false
local focusColor = "#bf8300"
local unfocusColor = "#595959aa"

hl.device({ name = "tpps/2-ibm-trackpoint", sensitivity = 1 })

hl.config({
	general = {
		border_size = 1,
		col = {
			active_border = focusColor,
			inactive_border = unfocusColor,
		},
		gaps_in = 7,
		gaps_out = 3,
		layout = "dwindle",
	},

	decoration = {
		blur = {
			enabled = true,
			passes = 1,
			size = 3,
			xray = true,
		},
		shadow = {
			enabled = false,
		},
	},

	animations = {
		enabled = animationEnabled,
	},

	input = {
		kb_layout = "us,fr",
		kb_options = "grp:win_space_toggle",
		kb_variant = ",azerty",
		repeat_delay = 200,
		repeat_rate = 50,
	},

	group = {
		groupbar = {
			col = {
				active = focusColor,
				inactive = unfocusColor,
			},
		},
	},

	misc = {
		disable_autoreload = false,
		disable_hyprland_logo = true,
		font_family = nix.fontFamily,
		key_press_enables_dpms = true,
		mouse_move_enables_dpms = true,
	},

	binds = {
		movefocus_cycles_fullscreen = false,
	},

	cursor = {
		inactive_timeout = 3,
	},

	ecosystem = {
		no_update_news = true,
	},

	dwindle = {
		force_split = 2,
		preserve_split = true,
	},
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
hl.animation({ leaf = "windows", enabled = animationEnabled, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = animationEnabled, speed = 7, bezier = "default", style = "popin 95%" })
hl.animation({ leaf = "border", enabled = animationEnabled, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = animationEnabled, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = animationEnabled, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = animationEnabled, speed = 6, bezier = "default" })
