local NPC = require "object/NPC"

local Chargeable = class(NPC)

function Chargeable:construct(scene, layer, object)
	self.objectInTree = object.properties.objectInTree

	NPC.init(self)
end

function Chargeable:whileColliding(player, prevState)
	if not self.objectInTree or
	   GameState.leader ~= "babyt" or
	   not player.doingSpecialMove or
	   not player.charging
	then
        return
    end
	
	print("charged")

	local obj = self.scene.objectLookup[self.objectInTree]
	if obj and obj.knockDown then
		obj:knockDown(self)
	end
	self.objectInTree = nil
end

return Chargeable
