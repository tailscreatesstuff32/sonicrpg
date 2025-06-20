local Ease = require "actions/Ease"
local Serial = require "actions/Serial"
local Parallel = require "actions/Parallel"
local Animate = require "actions/Animate"
local Do = require "actions/Do"

local Player = require "object/Player"
local ThreeDee = require "object/ThreeDee"

local ThreeDeeMushroom = class(ThreeDee)


function ThreeDeeMushroom:land()
	-- Bounce up on landing
	self:run {
		Parallel {
			Ease(self.scene.player, "y", self.scene.player.y - self.nextFlyOffsetY - 200, 2),
			Ease(self.scene.camPos, "y", self.scene.camPos.y - self.nextFlyOffsetY - 200, 2),
			Ease(self.scene.player, "flyOffsetY", self.scene.player.flyOffsetY + self.nextFlyOffsetY + 200, 2),

			Serial {
				Animate(self.scene.objectLookup.Mushroom1.sprite, "bounce"),
				Animate(self.scene.objectLookup.Mushroom1.sprite, "idle")
			}
		},
		Do(function()
			self.scene.player.noLand = false
			self.scene.player.stickyLShift = false
			self.scene:swapLayer(1, true)
		end)
	}
	return true
end


return ThreeDeeMushroom
