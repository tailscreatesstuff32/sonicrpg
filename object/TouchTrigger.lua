local NPC = require "object/NPC"

local TouchTrigger = class(NPC)

function TouchTrigger:construct(scene, layer, object)
    self.ghost = true
	
	NPC.init(self)

	self.atMostOnce = object.properties.atMostOnce
	self.touched = false

	self:addHandler("collision", TouchTrigger.touch, self)
end

function TouchTrigger:touch(prevState)
	if not self.touched then
		self.scene:run(assert(loadstring(self.object.properties.script))()(self))
		self.touched = true

		if self.atMostOnce then
			self:permanentRemove()
		end
	end
end

return TouchTrigger
