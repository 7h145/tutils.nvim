-- tutils/init.lua, thias <github.attic@typedef.net> 2025, CC0 1.0
-- vim:ft=lua:tw=0:nowrap

-- this is just a debug error waiting to happen
--error('oops')

-- Lua 5.1/LuaJIT: unpack, Lua >5.1: table.unpack
local unpack = table.unpack or unpack

-- NOTE: fn_label(): This is only marginally helpful if `fn` is a builtin,
-- since debug.getinfo() will just yield `[C]:-1`. Good enough.

--- Build a readable label string for a function (name or file:line).
--- @param fn function The function to describe
--- @return string label A human-readable label for diagnostics
local function fn_label(fn)
	local info = debug.getinfo(fn, 'nS')
	if info and info.name and info.name ~= '' then
		return info.name
	end
	local src = (info and info.short_src) or '?'
	local line = (info and info.linedefined) and tostring(info.linedefined) or '?'

	return ('%s:%s'):format(src, line)
end

-- NOTE: safe_call(): just a pcall() wrapper with vim.notify() error
-- reporting.  Nothing to see here.

--- Safe call wrapper with vim.notify() on error.
--- @param fn function  The function to pcall()
--- @param ... any  Aguments to pass to the function
--- @return boolean ok  True if the call succeeded
--- @return any ...  Remaining return values from the function (on success)
local function safe_call(fn, ...)
	local args = { ... }
	local ret = { pcall(fn, unpack(args)) }
	local ok = table.remove(ret, 1)

	if not ok then
		local argstr = table.concat(vim.tbl_map(tostring, args), ', ')

		vim.notify(("%s(%s): %s"):format(
			fn_label(fn), argstr, tostring(ret[1])), vim.log.levels.ERROR)
		return false
	else
		return true, unpack(ret)
	end
end

-- NOTE: require_dir(): require() any `.lua` file in a subdirectory of the
-- `lua` directory (given by `luadir`), optionally matching a Vim glob
-- pattern (given by `vimglob`).

--- require() all lua modules in a directory that match a vim glob
--- @param luadir string  path relative to stdpath('config')/lua
--- @param vimglob string?  vim vimglob pattern (defaults to '*.lua')
--- @return nil
local function require_dir(luadir, vimglob)
	vimglob = vimglob or '*.lua'
	vimglob = vimglob:match('%.lua$') and vimglob or (vimglob .. '.lua')

	local dir = vim.fn.stdpath('config') .. '/lua/' .. luadir

	for _, file in ipairs(vim.fn.glob(dir .. '/' .. vimglob, true, true)) do
		local name = file:match('(' .. luadir .. '/[^/]+)%.lua$')
		local modulename = name:gsub('/', '.')

		safe_call(require, modulename)
	end
end


-- the module table

--- @class Tutils
--- @field require_dir fun(luadir:string, vimglob?:string)
--- @field safe_call fun(fn:function, ...):boolean, ...  -- same shape as pcall
local M = {}
M.safe_call = safe_call
M.require_dir = require_dir

--- @type Tutils
return M
