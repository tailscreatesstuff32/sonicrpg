local Ease = require "actions/Ease"
local Parallel = require "actions/Parallel"
local Animate = require "actions/Animate"
local Wait = require "actions/Wait"
local PlayAudio = require "actions/PlayAudio"

local Player = require "object/Player"
local BasicNPC = require "object/BasicNPC"
local NPC = require "object/NPC"

local Monkey = class(NPC)

function Monkey:construct(scene, layer, object)
	self.ghost = true
	self.throw = false

	if self.object.properties.viewRange then
		self.viewRanges = {}
		for _, view in pairs(pack((self.object.properties.viewRange):split(','))) do
			table.insert(self.viewRanges, self.scene.objectLookup[view])
		end
	end

	NPC.init(self)

	self:addSceneHandler("update", Monkey.update)
end

function Monkey:update(dt)
	if self:isRemoved() then
		self:removeSceneHandler("update")
		return
	end
	
	if GameState.leader ~= "tails" then
		return
	end

	--[[ Don't interact with player if player doesn't care about your layer
	if (self.scene.player.onlyInteractWithLayer ~= nil and
		self.scene.player.onlyInteractWithLayer ~= self.layer.name) and
		self.layer.name ~= "all"
	then
		return
	end]]
	
	-- ^^^ We want Monkey to be able to see/interact with you on any layer
	
	-- If you are colliding with view range, and you are flying, monkey will throw coconut at you
	local inView = false
	if self.viewRanges then
		for _, v in pairs(self.viewRanges) do
			if v.state == NPC.STATE_TOUCHING and
			   self:isTouching(v.x, v.y, v.object.width, v.object.height)
			then
				inView = true
				break
			end
		end
		if not inView then
			return
		end
	end

	local player = self.scene.player
	if inView and player.doingSpecialMove and not self.throw then
		self.throw = true

		-- Throw a coconut!
		self.coconut = BasicNPC(
			self.scene,
			{name = "objects"},
			{
				name = "Coconut",
				x = self.x + 22 * 2,
				y = self.y + 17 * 2,
				width = 8,
				height = 8,
				properties = {nocollision = true, sprite = "art/sprites/snowball.png"}
			}
		)
		self.coconut.sprite.transform.ox = 4
		self.coconut.sprite.transform.oy = 4
		self.coconut.sprite.color = {255, 255, 0, 255}
		self.scene:addObject(self.coconut)

		self:run {
			Animate(self.sprite, "hold"),
			Wait(1),
			Parallel {
				Animate(self.sprite, "throw"),
				Ease(self.coconut, "x", player.x, 3),
				Ease(self.coconut, "y", player.y, 3)
			},
			Do(function()
				player.forceDrop = true
			end),
			PlayAudio("sfx", "poptop", 1.0),
			Do(function()
				self.throw = false
			end)
		}
	end
end


return Monkey
