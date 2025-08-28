return {
    image = "flower.png",
    starting = "idle",
    w = 90,
    h = 62,

    animations = {
		idle = {
			frames = {{0,0}, {1,0}},
			speed = 0.5
		},
		hurt = {
			frames = {{2,0}}
		},
		shoot = {
			frames = {{2,0}, {3,0}},
			speed = 0.2
		},
    }
}