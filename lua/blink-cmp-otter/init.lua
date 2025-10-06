-- ~/.config/nvim/lua/blink-cmp-otter/init.lua
local sources = require("blink.cmp.sources")

sources.register("otter", function(ctx)
  local ok, otter = pcall(require, "otter")
  if not ok or type(otter.get_completions) ~= "function" then
    return {}
  end
  local ok2, items = pcall(otter.get_completions, ctx)
  if not ok2 or not items then
    return {}
  end
  local out = {}
  for _, it in ipairs(items) do
    table.insert(out, {
      label = it.label or it.word,
      kind = it.kind,
      insert_text = it.insertText or it.label or it.word,
    })
  end
  return out
end)
