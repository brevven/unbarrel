local subgroups = {"empty-barrel", "fill-barrel"}
local groups = {}
local recipes = {}
local categories = {}

if settings.startup["unbarrel-subgroup-excludes"] then 
  subgroups = {}
  for subgroup in string.gmatch(settings.startup["unbarrel-subgroup-excludes"].value, '[^",%s]+') do
    table.insert(subgroups, subgroup)
  end
end

if settings.startup["unbarrel-group-excludes"] then 
  for group in string.gmatch(settings.startup["unbarrel-group-excludes"].value, '[^",%s]+') do
    table.insert(groups, group)
  end
end

if settings.startup["unbarrel-recipe-excludes"] then 
  for recipe in string.gmatch(settings.startup["unbarrel-recipe-excludes"].value, '[^",%s]+') do
    table.insert(recipes, recipe)
  end
end

if settings.startup["unbarrel-category-excludes"] then 
  for category in string.gmatch(settings.startup["unbarrel-category-excludes"].value, '[^",%s]+') do
    table.insert(categories, category)
  end
end

function hide_recipe_from_player_crafting(recipe, t, val)
  log("due to "..t.." of '"..val.."', hiding '"..recipe.name.."' recipe from hand crafting")
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

function get_recipe_subgroup(recipe)
  if recipe.subgroup then
    return recipe.subgroup
  end
  if data.raw.item[recipe.result] and data.raw.item[recipe.result].subgroup then
    return data.raw.item[recipe.result].subgroup
  end
  if data.raw.fluid[recipe.result] and data.raw.fluid[recipe.result].subgroup then
    return data.raw.fluid[recipe.result].subgroup
  end
  if recipe.normal and data.raw.item[recipe.normal.result] and data.raw.item[recipe.normal.result].subgroup then
    return data.raw.item[recipe.normal.result].subgroup 
  end
  if recipe.normal and data.raw.fluid[recipe.normal.result] and data.raw.fluid[recipe.normal.result].subgroup then
    return data.raw.fluid[recipe.normal.result].subgroup 
  end
  if data.raw.item[recipe.main_product] and data.raw.item[recipe.main_product].subgroup then
    return data.raw.item[recipe.main_product].subgroup 
  end
  if data.raw.fluid[recipe.main_product] and data.raw.fluid[recipe.main_product].subgroup then
    return data.raw.fluid[recipe.main_product].subgroup 
  end
  if recipe.normal and data.raw.item[recipe.normal.main_product] and data.raw.item[recipe.normal.main_product].subgroup then
    return data.raw.item[recipe.normal.main_product].subgroup 
  end
  if recipe.normal and data.raw.fluid[recipe.normal.main_product] and data.raw.fluid[recipe.normal.main_product].subgroup then
    return data.raw.fluid[recipe.normal.main_product].subgroup 
  end
  if recipe.results and #recipe.results == 1 and data.raw.item[recipe.results[1]] and data.raw.item[recipe.results[1]].subgroup then
    return data.raw.item[recipe.results[1]].subgroup 
  end
  if recipe.results and #recipe.results == 1 and data.raw.fluid[recipe.results[1]] and data.raw.fluid[recipe.results[1]].subgroup then
    return data.raw.fluid[recipe.results[1]].subgroup 
  end
  if recipe.normal and recipe.normal.results and #recipe.normal.results == 1 and data.raw.item[recipe.normal.results[1]] and data.raw.item[recipe.normal.results[1]].subgroup then
    return data.raw.item[recipe.normal.results[1]].subgroup 
  end
  if recipe.normal and recipe.normal.results and #recipe.normal.results == 1 and data.raw.fluid[recipe.normal.results[1]] and data.raw.fluid[recipe.normal.results[1]].subgroup then
    return data.raw.fluid[recipe.normal.results[1]].subgroup 
  end
end

function get_recipe_group(recipe) 
  local subgroup = get_recipe_subgroup(recipe)
  if data.raw["item-subgroup"][subgroup] and data.raw["item-group"][data.raw["item-subgroup"][subgroup].group] then
    return data.raw["item-subgroup"][subgroup].group
  end
end

log("hiding subgroups from hand crafting: " .. serpent.line(subgroups))
log("hiding groups from hand crafting: " .. serpent.line(groups))
log("hiding categories from hand crafting: " .. serpent.line(categories))
log("hiding other recipes from hand crafting: " .. serpent.line(recipes))

for _, recipe in pairs(data.raw["recipe"]) do
  for _, subgroup in pairs(subgroups) do
    if get_recipe_subgroup(recipe) == subgroup then 
      hide_recipe_from_player_crafting(recipe, "subgroup", subgroup)
      break
    end
  end
  for _, group in pairs(groups) do
    if get_recipe_group(recipe) == group then 
      hide_recipe_from_player_crafting(recipe, "group", group)
      break
    end
  end
  for _, category in pairs(categories) do
    if recipe.category == category then
      hide_recipe_from_player_crafting(recipe, "category", category)
      break
    end
  end
end

for _, recipe_name in pairs(recipes) do
  local recipe = data.raw.recipe[recipe_name]
  if recipe then
    hide_recipe_from_player_crafting(recipe, "recipe", recipe_name)
  end
end
