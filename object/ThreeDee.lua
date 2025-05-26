local Player = require "object/Player"
local NPC = require "object/NPC"

local ThreeDee = class(NPC)

function ThreeDee:construct(scene, layer, object)
	self.ghost = true
	self.depth = self.object.properties.depth
	self.flyLandingLayer = self.object.properties.flyLandingLayer
	self.nextFlyLandingLayer = self.object.properties.nextFlyLandingLayer
	self.nextFlyOffsetY = self.object.properties.nextFlyOffsetY
	self.passThru = self.object.properties.passThru

	NPC.init(self)
end

function ThreeDee:whileColliding(player, prevState)
	if GameState.leader ~= "tails" or
	   not player.doingSpecialMove or
	   player.flyOffsetY < self.object.height
	then
        return
    end

    if self:onTop() then
        player.tempFlyOffsetY = -self.object.height + 20
		player.flyLandingLayer = self.flyLandingLayer
		player.nextFlyLandingLayer = self.nextFlyLandingLayer
		player.nextFlyOffsetY = self.nextFlyOffsetY
		player.dropShadow.sprite.sortOrderY = 100000
    else
        player.tempFlyOffsetY = 0
		player.flyLandingLayer = self.nextFlyLandingLayer
		player.nextFlyLandingLayer = self.nextFlyLandingLayer
		player.nextFlyOffsetY = 0
		player.dropShadow.sprite.sortOrderY = nil
    end

	player.threeDeeObjects[tostring(self)] = self
end

function ThreeDee:onTop()
	local player = self.scene.player
	local playerY = player.y + player.flyOffsetY
	local objBottomY = self.object.y + self.object.height
	return (playerY < objBottomY) and (playerY > (objBottomY - self.depth))
end

function ThreeDee:notColliding(player, prevState)
    if GameState.leader ~= "tails" or
	   not player.doingSpecialMove or
	   prevState == NPC.STATE_IDLE
	then
        return
    end

	player.threeDeeObjects[tostring(self)] = nil

	if next(player.threeDeeObjects) == nil then
		player.tempFlyOffsetY = 0
		player.flyLandingLayer = self.nextFlyLandingLayer
		player.dropShadow.sprite.sortOrderY = nil
	end
end


return ThreeDee
