local vscode_colors = require('vscode.colors').get_colors()
local colors = {
  visual = vscode_colors.vscGreen,
  replace = vscode_colors.vscRed,
}

if vim.o.background == 'dark' then
  colors.normal = vscode_colors.vscBlue
  colors.insert = vscode_colors.vscYellowOrange
  colors.command = vscode_colors.vscDarkYellow
else
  colors.normal = vscode_colors.vscDarkBlue
  colors.insert = vscode_colors.vscOrange
  colors.command = '#FFC000'
end

local mode_highlight = function(highlight)
  return {
    a = { bg = highlight, fg = vscode_colors.vscLeftMid, gui = 'bold' },
    b = { bg = vscode_colors.vscLeftMid, fg = highlight },
    c = { bg = vscode_colors.vscLeftDark, fg = vscode_colors.vscFront },
  }
end

return {
  normal = mode_highlight(colors.normal),
  insert = mode_highlight(colors.insert),
  visual = mode_highlight(colors.visual),
  replace = mode_highlight(colors.replace),
  command = mode_highlight(colors.command),
}
