-- Makes Neovim usable on the Bulgarian phonetic layout:
--   * setup() sets 'langmap' so normal-mode commands work
--   * map()   works like vim.keymap.set but also registers a Cyrillic copy of the lhs
local M = {}

-- letters in Bulgarian alphabet order, with the Latin key each one sits on
local bg_letters = "абвгдежзийклмнопрстуфхцъья"
local en_letters = "abwgdevzijklmnoprstufhcyxq"

-- latin key -> bulgarian character on the same physical key
local to_bg = {
  ["`"] = "ч",
  ["~"] = "Ч",
  ["["] = "ш",
  ["{"] = "Ш",
  ["]"] = "щ",
  ["}"] = "Щ",
  ["\\"] = "ю",
  ["|"] = "Ю",
}

for i = 1, vim.fn.strchars(bg_letters) do
  local bg = vim.fn.strcharpart(bg_letters, i - 1, 1)
  local en = en_letters:sub(i, i)
  to_bg[en] = bg
  to_bg[en:upper()] = vim.fn.toupper(bg)
end

-- langmap treats ; , \ as special, so they must be escaped
local function escape(c)
  return (c:gsub("[;,\\]", "\\%0"))
end

function M.setup()
  local entries = {}
  for latin, cyrillic in pairs(to_bg) do
    table.insert(entries, escape(cyrillic) .. escape(latin))
  end
  table.sort(entries)
  vim.opt.langmap = table.concat(entries, ",")
  vim.opt.langremap = false
end

-- translate the letters of a lhs, keeping <special> tokens untouched
local function bg_lhs(lhs)
  local res, i = "", 1
  while i <= #lhs do
    local special = lhs:match("^<[^>]+>", i)
    if special then
      res = res .. special
      i = i + #special
    else
      local c = lhs:sub(i, i)
      res = res .. (to_bg[c] or c)
      i = i + 1
    end
  end
  return res
end

-- like vim.keymap.set, but also sets the Bulgarian-layout twin
function M.map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
  local alt = bg_lhs(lhs)
  if alt ~= lhs then
    vim.keymap.set(mode, alt, rhs, opts)
  end
end

return M
