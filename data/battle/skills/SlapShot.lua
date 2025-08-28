local TargetType = require "util/TargetType"

return {
	name = "Slap Shot",
	target = TargetType.None,
	unusable = function(target) return false end,
	cost = 5,
	desc = "Slap a puck at opponent.",
	action = require "data/battle/skills/actions/SlapShot"
}