local Player = require "object/Player"
local NPC = require "object/NPC"

local SimulatedDrop = class(NPC)

function SimulatedDrop:construct(scene, layer, object)
	self.ghost = true

	NPC.init(self)
end

function SimulatedDrop:whileColliding(player, prevState)
	if GameState.leader ~= "tails" or
	   not player.doingSpecialMove or
	   player.simulatedDrops[tostring(self)] ~= nil or
	   next(player.simulatedDrops) ~= nil
    then
        return
    end

	player.simulatedDrops[tostring(self)] = self
	player.dropShadow.hidden = true
end

function SimulatedDrop:notColliding(player, prevState)
    if GameState.leader ~= "tails" or
	   player.simulatedDrops[tostring(self)] == nil or
	   next(player.simulatedDrops) == nil
	then
        return
    end

	player.simulatedDrops[tostring(self)] = nil

	if next(player.simulatedDrops) == nil then
		player.dropShadow.hidden = false
	end
end


return SimulatedDrop
