# tutils.nvim

This is a tiny Lua module for [Neovim](https://github.com/neovim/neovim) for my personal use.  I'm sure this has been done many time and I assume you can find similar plugins which are better in many ways, but feel free to check out this one :)

## Installation with [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ 
    '7h145/tutils',
    event = 'VeryLazy',
}
```

## Usage:

Just some Lua utility functions for now:

* `safe_call()`: a pcall() wrapper with vim.notify() on error.
* `require_dir()`: require() all lua modules in a directory that match a vim glob

I'm sure I'm not the first one writing these... 

Practical application, in e.g. `init.lua`: require() all `*.lua` files in the `lua/snippets` directory by vim glob:

```lua
local tutils = require('tutils')

tutils.require_dir('snippets', 'keymap-*.lua')
tutils.require_dir('snippets', 'command-*.lua')
```

Copyright 2025, thias <github.attic@typedef.net>, CC0 1.0
