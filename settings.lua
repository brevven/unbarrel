data:extend(
{
  {
		type = "string-setting",
		name = "unbarrel-subgroup-excludes",
		setting_type = "startup",
    allow_blank = true,
		default_value = "empty-barrel fill-barrel",
		order = "a2",
	},
  {
		type = "string-setting",
		name = "unbarrel-group-excludes",
		setting_type = "startup",
    allow_blank = true,
		default_value = "",
		order = "a3",
	},
  {
		type = "string-setting",
		name = "unbarrel-category-excludes",
		setting_type = "startup",
    allow_blank = true,
		default_value = "",
		order = "a4",
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
