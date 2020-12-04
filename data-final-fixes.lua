local subgroups = {"empty-barrel", "fill-barrel"}

if settings.startup["unbarrel-subgroup-excludes"] then 
  subgroups = {}
  for subgroup in string.gmatch(settings.startup["unbarrel-subgroup-excludes"].value, '[^",%s]+') do
    table.insert(subgroups, subgroup)
  end
end

log("hiding subgroups from hand crafting: " .. serpent.line(subgroups))

for _, recipe in pairs(data.raw["recipe"]) do
  for _, subgroup in pairs(subgroups) do
    if recipe.subgroup == subgroup then
      if recipe.ingredients then
        recipe.hide_from_player_crafting = true
      end
      if recipe.normal then
        recipe.normal.hide_from_player_crafting = true
      end
      if recipe.expensive then
        recipe.expensive.hide_from_player_crafting = true
      end
    end
  end
end

