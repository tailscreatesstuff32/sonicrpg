local Transform = require "util/Transform"

local SpriteNode = require "object/SpriteNode"
local Bot = require "object/Bot"

local Brush = class(Bot)

function Brush:construct(scene, layer, object)
	object.properties.align = "bottom_left"
	self.ghost = true
	self.movespeed = 0

	Bot.init(self, true)
end

function Brush:getInitiative()
	return nil
end


return Brush
