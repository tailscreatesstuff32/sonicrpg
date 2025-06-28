local Ease = require "actions/Ease"
local Serial = require "actions/Serial"
local Parallel = require "actions/Parallel"
local Repeat = require "actions/Repeat"
local Animate = require "actions/Animate"
local Wait = require "actions/Wait"
local Spawn = require "actions/Spawn"
local PlayAudio = require "actions/PlayAudio"
local Do = require "actions/Do"

local Player = require "object/Player"
local BasicNPC = require "object/BasicNPC"
local NPC = require "object/NPC"

local Monkey = class(NPC)

function Monkey:construct(scene, layer, object)
	self.ghost = true
	self.throw = false

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

	if not self.viewRange then
		self.viewRange = self.scene.objectLookup[self.object.properties.viewRange]
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
	local player = self.scene.player
	if self.viewRange.state == NPC.STATE_TOUCHING and player.doingSpecialMove and not self.throw then
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
		self.coconut.sprite.color = {50, 50, 10, 255}
		self.scene:addObject(self.coconut)

		self:run {
			Animate(self.sprite, "hold"),
			Wait(0.5),
			Parallel {
				Animate(self.sprite, "throw"),
				Ease(self.coconut, "x", function() return player.x end, 3),
				Ease(self.coconut, "y", function() return player.y end, 3)
			},
			Do(function()
				player.forceDrop = true
			end),
			-- Player flicker
			Spawn(
				Repeat(
					Serial {
						Ease(player.sprite.color, 4, 0, 20, "linear"),
						Ease(player.sprite.color, 4, 255, 20, "linear")
					},
					12
				)
			),
			Parallel {
				PlayAudio("sfx", "poptop", 1.0),

				-- Bounce off
				Ease(self.coconut, "x", function() return self.coconut.x + 50 end, 3),
				Serial {
					Ease(self.coconut, "y", function() return self.coconut.y - 50 end, 6),
					Ease(self.coconut, "y", function() return self.coconut.y + 50 end, 6)
				}
			},
			Do(function()
				self.coconut:remove()
				self.throw = false
			end)
		}
	end
end


return Monkey
