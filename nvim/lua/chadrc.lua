--[[

MIT License

Copyright (c) 2010 Clivern

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]

-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig

local M = {}

M.base46 = {
	-- NvChad Theme IDs
	-- 1. aquarium
	-- 2. ashes
	-- 3. ayu_dark
	-- 4. ayu_light
	-- 5. bearded-arc
	-- 6. blossom_light
	-- 7. catppuccin
	-- 8. chadracula-evondev
	-- 9. chadracula
	-- 10. chadtain
	-- 11. chocolate
	-- 12. dark_horizon
	-- 13. decay
	-- 14. doomchad
	-- 15. everblush
	-- 16. everforest
	-- 17. everforest_light
	-- 18. falcon
	-- 19. flex-light
	-- 20. flexoki-light
	-- 21. flexoki
	-- 22. gatekeeper
	-- 23. github_dark
	-- 24. github_light
	-- 25. gruvbox
	-- 26. gruvbox_light
	-- 27. gruvchad
	-- 28. jabuti
	-- 29. jellybeans
	-- 30. kanagawa
	-- 31. material-darker
	-- 32. material-lighter
	-- 33. melange
	-- 34. mito-laser
	-- 35. monekai
	-- 36. monochrome
	-- 37. mountain
	-- 38. nano-light
	-- 39. nightfox
	-- 40. nightlamp
	-- 41. nightowl
	-- 42. nord
	-- 43. oceanic-light
	-- 44. oceanic-next
	-- 45. one_light
	-- 46. onedark
	-- 47. onenord
	-- 48. onenord_light
	-- 49. oxocarbon
	-- 50. palenight
	-- 51. pastelDark
	-- 52. pastelbeans
	-- 53. penumbra_dark
	-- 54. penumbra_light
	-- 55. poimandres
	theme = "chadtain",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

M.nvdash = {
    load_on_startup = true,
    header = {
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡇⠀⢠⣾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⡇⢠⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⢸⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⡀⠙⠛⠃⠘⠻⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠐⠚⣛⣛⣁⡀⠹⣿⣿⣶⣶⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⣠⣴⠶⠿⠛⠛⠛⠛⠛⠀⢻⣿⣿⣤⣀⣙⣷⣀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⣈⣁⣤⣴⣶⠶⠿⠿⠿⠿⠇⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣦⣤⡄",
		"⠀⠐⠛⢉⣉⣠⣤⣤⣶⣶⣶⣶⣦⠀⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠿⠛⠉⠀",
		"⠀⡾⠛⠉⠉⠉⠙⠻⢿⣿⣿⣿⣿⡀⢹⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⢸⡇⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⡇⠘⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⢸⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡇⠀⣾⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠃⠀⢿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⠀⠀⠸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠀⠀⠀⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀ +-+-+-+-+-+-+-+⠀⠀⠀⠀⠀  ",
		"                                ",
    }
}

return M
