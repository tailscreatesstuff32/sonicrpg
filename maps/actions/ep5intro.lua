return function(scene, hint)
	local Transform = require "util/Transform"
	local Rect = unpack(require "util/Shapes")
	local Layout = require "util/Layout"

	local Action = require "actions/Action"
	local TypeText = require "actions/TypeText"
	local Menu = require "actions/Menu"
	local MessageBox = require "actions/MessageBox"
	local Move = require "actions/Move"
	local PlayAudio = require "actions/PlayAudio"
	local Ease = require "actions/Ease"
	local Parallel = require "actions/Parallel"
	local Serial = require "actions/Serial"
	local Executor = require "actions/Executor"
	local Wait = require "actions/Wait"
	local Do = require "actions/Do"
	local Spawn = require "actions/Spawn"
	local BlockPlayer = require "actions/BlockPlayer"
	local Animate = require "actions/Animate"
	local SpriteNode = require "object/SpriteNode"


	local undonight = function()
		-- Undo ignore night
		local shine = require "lib/shine"

		scene.nighttime = true
		scene.map.properties.ignorenight = false
		scene.originalMapDraw = scene.map.drawTileLayer
		scene.map.drawTileLayer = function(map, layer)
			if not scene.night then
				scene.night = shine.nightcolor()
			end
			scene.night:draw(function()
				scene.night.shader:send("opacity", layer.opacity or 1)
				scene.night.shader:send("lightness", 1 - (layer.properties.darkness or 0))
				scene.originalMapDraw(map, layer)
			end)
		end
	end

	scene.objectLookup.TailsBed.sprite:setAnimation("tailsawake_lookup")

	GameState:setFlag("ep5_intro")

	scene.objectLookup.Door.isInteractable = false
	scene.player.sprite.visible = false
	scene.player.dropShadow.hidden = true

	scene.camPos.x = 0
	scene.camPos.y = 0

	local storybook = SpriteNode(scene, Transform(0, -300, 1, 1), {255,255,255,0}, "storybook1", nil, nil, "ui")

	return BlockPlayer {
		Do(function()
			scene.objectLookup.Door.isInteractable = false
			scene.objectLookup.Drawer.isInteractable = false
			scene.objectLookup.TailsBed.isInteractable = false

			scene.player.object.properties.ignoreMapCollision = true
			scene.player:removeKeyHint()
			scene.player.sprite.visible = false
			scene.player.dropShadow.hidden = true

			scene.camPos.x = 0
			scene.camPos.y = 0
		end),
		Wait(2),
		PlayAudio("music", "tailssleep", 1.0, true),
		MessageBox {message="Sally: And so, Ben and his trusty companion, the Inventor Knight, made their way through the twisted\nand tangled Great Jungle...", textSpeed=3},
		MessageBox {message="Sally: *Gruff voice* \"What are we looking for, Ben?\",\nthe Knight pressed...", textSpeed=3},
		MessageBox {message="Sally: *Playful voice* \"I will let you know once I've\nfound it!\", Ben retorted...", textSpeed=3},
		MessageBox {message="Sally: But just as Ben's tried companion was about\nto lash back in frustration{p50}, the brush finally cleared!", textSpeed=3},
		MessageBox {message="Sally: A bright, warm light enveloped the two\nadventurers...{p50} and as the knight took a step forward\nout of the jungle, what he saw left him speechless!", textSpeed=3},
		
		Parallel {
			Serial {
				Wait(2),
				MessageBox {message="Sally: And there it was. That hallowed realm, untouched by crown or conquest--just beyond the wild...", textspeed=3, closeAction=Wait(4)},
				MessageBox {message="Sally: \"This is it!\", Ben proclaimed, \"The Light of Mobius is somewhere down there!\"", textspeed=3, closeAction=Wait(4)},
			},
			Serial {
				Wait(2),
				PlayAudio("music", "storybooklonging", 1.0, true)
			},
			Serial {
				Wait(1),
				Parallel {
					Ease(storybook.color, 4, 255, 1, "linear"),
					Ease(storybook.transform, "y", -20, 0.07, "linear")
				}
			}
		},
		Wait(6),
		Ease(storybook.color, 4, 0, 1, "linear"),
		MessageBox {message="Tails: That's Boulder Bay they're talkin' about, huh?\n{p40}Where Baby T lives?", textspeed=3},
		MessageBox {message="Sally: You'll just have to wait and see!{p40} It's past your bedtime, Tails.", textspeed=3},
		Animate(scene.objectLookup.Sally.sprite, "idledown"),
		MessageBox {message="Tails: Aww man!", textspeed=3},
		Do(function() scene.objectLookup.Sally.sprite:setAnimation("walkup") end),

		Parallel {
			Ease(scene.objectLookup.Sally, "x", scene.objectLookup.Sally.x - 40, 1, "linear"),
			Serial {
				Ease(scene.objectLookup.Sally, "y", scene.objectLookup.Sally.y - 60, 1, "linear"),
				Animate(scene.objectLookup.Sally.sprite, "idleup")
			},
			MessageBox {message="Tails: ...", textspeed=3, closeAction=Wait(1)}
		},
		MessageBox {message="Tails: Hey Sally...", textspeed=3},
		Animate(scene.objectLookup.Sally.sprite, "idledown"),
		MessageBox {message="Sally: Yeah?", textspeed=3},
		MessageBox {message="Tails: Do ya think the {h Light of Mobius} is really out\nthere?", textspeed=3},
		Animate(scene.objectLookup.Sally.sprite, "thinking"),
		MessageBox {message="Sally: Well...{p50} we did find the {h Breath of Mobius},{p60}\nso I wouldn't count it out!", textspeed=3},
		MessageBox {message="Tails: Wow...", textspeed=3},
		Animate(scene.objectLookup.Sally.sprite, "idledown"),
		MessageBox {message="Sally: Good night, Tails.", textspeed=3},
		Animate(scene.objectLookup.Sally.sprite, "idleup"),

		Wait(1),
		Do(function() undonight() end),
		Wait(1),
		Do(function() scene.objectLookup.Door:interact() end),
		Wait(0.5),
		Do(function() scene.objectLookup.Sally:remove() end),
		Wait(0.5),
		Do(function() scene.objectLookup.Door:close() end),
		PlayAudio("music", "tailssleep2", 1.0, true),
		Wait(1),
		Animate(scene.objectLookup.TailsBed.sprite, "tailstired"),
		Wait(2),
		Animate(scene.objectLookup.TailsBed.sprite, "tailssleep"),
		Do(function()
			scene:changeScene{map="tailshut", fadeOutSpeed=0.1, fadeInSpeed=0.2, enterDelay=1.0, hint="ep5intro"}
		end)
	}
end
