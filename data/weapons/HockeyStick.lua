local WeaponType = require "util/WeaponType"
local ItemType = require "util/ItemType"
local EventType = require "util/EventType"

return {
	name = "Hockey Stick",
	desc = "An unconventional weapon.",
	type = ItemType.Weapon,
	subtype = WeaponType.Sword,
	usableBy = {"tails"},
	sprite = "sword",
	color = {200,200,0,255},
	stats = {
		attack = 1
	}
}
