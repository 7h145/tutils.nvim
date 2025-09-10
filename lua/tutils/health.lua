-- tutils/health.lua, thias <github.attic@typedef.net> 2025, CC0 1.0
-- vim:ft=lua:tw=0:nowrap

-- see `health`, `health-dev`

local function check()
	vim.health.start('tutils.nvim report')

	-- FIXME: maybe some actual checks here if needed.
	if package.loaded['tutils'] then
		vim.health.ok("package 'tutils' is loaded")
	else
		vim.health.error("package 'tutils' is not loaded")
	end
end

-- the module table

--- @class TutilsHealth
--- @field check fun():nil Run health checks for tutils.nvim
local M = {}
M.check = check

--- @type TutilsHealth
return M
