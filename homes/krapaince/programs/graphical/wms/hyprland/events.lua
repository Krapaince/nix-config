local function handle_firefox_window(window)
	local title = window.title

	if title:sub(1, 2) == "FW" then
		local workspace_id = tonumber(title:match("^FW(%d+)"))

		if type(workspace_id) == "number" then
			hl.dispatch(hl.dsp.window.move({ window = window, workspace = workspace_id, follow = false }))
		end
	end
end

hl.on("window.title", function(window)
	local class = window.class

	if class == "firefox" then
		handle_firefox_window(window)
	end
end)
