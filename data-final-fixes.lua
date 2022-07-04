local subgroups = {"empty-barrel", "fill-barrel"}
local recipes = {}

if settings.startup["unbarrel-subgroup-excludes"] then 
  subgroups = {}
  for subgroup in string.gmatch(settings.startup["unbarrel-subgroup-excludes"].value, '[^",%s]+') do
    table.insert(subgroups, subgroup)
  end
end

if settings.startup["unbarrel-recipe-excludes"] then 
  for recipe in string.gmatch(settings.startup["unbarrel-recipe-excludes"].value, '[^",%s]+') do
    table.insert(recipes, recipe)
  end
end

function hide_recipe_from_player_crafting(recipe)
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

function check_item_subgroup(recipe, subgroup)
  if (data.raw.item[recipe.result] and data.raw.item[recipe.result].subgroup == subgroup)
  or (recipe.normal and data.raw.item[recipe.normal.result] and data.raw.item[recipe.normal.result] and data.raw.item[recipe.normal.result].subgroup == subgroup) then
    return true
  end
  if (data.raw.item[recipe.main_product] and data.raw.item[recipe.main_product].subgroup == subgroup)
  or (data.raw.fluid[recipe.main_product] and data.raw.fluid[recipe.main_product].subgroup == subgroup)
  or (recipe.normal and data.raw.item[recipe.normal.main_product] and data.raw.item[recipe.normal.main_product] and data.raw.item[recipe.normal.main_product].subgroup == subgroup)
  or (recipe.normal and data.raw.fluid[recipe.normal.main_product] and data.raw.fluid[recipe.normal.main_product] and data.raw.fluid[recipe.normal.main_product].subgroup == subgroup) then
    return true
  end
  if recipe.results and #recipe.results == 1 and
     ( (data.raw.item[recipe.results[1]] and data.raw.item[recipe.results[1]].subgroup == subgroup) 
    or (data.raw.fluid[recipe.results[1]] and data.raw.fluid[recipe.results[1]].subgroup == subgroup)) 
  then
    return true 
  end
  if recipe.normal and recipe.normal.results and #recipe.normal.results == 1 and
     ( (data.raw.item[recipe.normal.results[1]] and data.raw.item[recipe.normal.results[1]].subgroup == subgroup) 
    or (data.raw.fluid[recipe.normal.results[1]] and data.raw.fluid[recipe.normal.results[1]].subgroup == subgroup)) 
  then
    return true 
  end
  return false
end

log("hiding subgroups from hand crafting: " .. serpent.line(subgroups))

for _, recipe in pairs(data.raw["recipe"]) do
  for _, subgroup in pairs(subgroups) do
    if recipe.subgroup == subgroup or check_item_subgroup(recipe, subgroup) then 
      hide_recipe_from_player_crafting(recipe)
      break
    end
  end
end

log("hiding other recipes from hand crafting: " .. serpent.line(recipes))
for _, recipe_name in pairs(recipes) do
  local recipe = data.raw.recipe[recipe_name]
  if recipe then
    hide_recipe_from_player_crafting(recipe)
  end
end
