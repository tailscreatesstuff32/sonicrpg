local BlockPlayer = require "actions/BlockPlayer"
local Parallel = require "actions/Parallel"
local Ease = require "actions/Ease"
local Do = require "actions/Do"
local Animate = require "actions/Animate"

local Player = require "object/Player"
local NPC = require "object/NPC"

local Quicksand = class(NPC)

function Quicksand:construct(scene, layer, object)
	self.ghost = true
	self.exitObject = object.properties.exitObject
	self.depth = 10

	NPC.init(self)
	
	self:addSceneHandler("update", Quicksand.update)
end

function Quicksand:update(dt)
	local player = self.scene.player

	if player.teleporting then
		return
	end

	-- Initialize quicksands
	if player.quicksands == nil then
		player.quicksands = {}
	end

	NPC.update(self, dt)

	if self.state == NPC.STATE_TOUCHING then
		if next(player.quicksands) == nil then
			player.y = player.y + self.depth
			player.sprite:setCrop(self.depth)
			player.dropShadow.hidden = true
		end

		-- Start pulling player toward center of quicksand
		local dx = player.x - (self.x + self.object.width/2)
		local dy = (player.y + player.height) - (self.y + self.object.height/2)
		local mag = math.sqrt(dx * dx + dy * dy)

		local stepX = -(dx / mag) * (dt/0.016)
		local stepY = -(dy / mag) * (dt/0.016)
		
		player.quicksands[tostring(self)] = self

		if mag < 5 then
			self:teleport()
		else
			player.x = player.x + stepX
			player.y = player.y + stepY
		end
	elseif player.quicksands[tostring(self)] ~= nil then
		player.quicksands[tostring(self)] = nil

		if next(player.quicksands) == nil then
			player.y = player.y - self.depth
			player.sprite:removeCrop()
			player.dropShadow.hidden = false
			self.depth = 10
		end
	end
end

function Quicksand:teleport()
	local player = self.scene.player
	local exitObject = self.scene.objectLookup[self.exitObject]

    player.teleporting = true

	self:run(BlockPlayer {
		Do(function()
			player.state = "shock"
		end),
		Parallel {
			Ease(self, "depth", function() return self.depth + player.height + 10 end, 1),
			Ease(player, "y", function() return player.y + player.height + 10 end, 1),
			Do(function()
				player.sprite:setCrop(self.depth)
			end)
		},
        Parallel {
            Ease(player, "x", exitObject.x + exitObject.object.width/2, 1),
            Ease(player, "y", exitObject.y + exitObject.object.height/2 - player.height, 1)
        },
		Parallel {
			Ease(self, "depth", 0, 4),
			Ease(player, "y", function() return player.y - 100 end, 3),
			Do(function()
				player.sprite:setCrop(self.depth)
			end)
		},
		Ease(player, "y", function() return player.y + 230 end, 5),
		Do(function()
			player.teleporting = false
		end)
    })
end

return Quicksand
