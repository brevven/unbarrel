data:extend(
{
  {
		type = "string-setting",
		name = "unbarrel-subgroup-excludes",
		setting_type = "startup",
    allow_blank = true,
		default_value = "empty-barrel fill-barrel",
		order = "a1",
	},
  {
		type = "string-setting",
		name = "unbarrel-recipe-excludes",
		setting_type = "startup",
    allow_blank = true,
		default_value = mods["space-exploration"] and "se-liquid-rocket-fuel" or "",
		order = "a1",
	},
})
