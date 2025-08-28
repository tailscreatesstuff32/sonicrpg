return {
    image = "brush.png",
    starting = "idle",
    w = 65,
    h = 64,

    animations = {
		idle = {
			frames = {{0,0}, {1,0}, {2,0}},
			speed = 0.4
		},
		backward = {
			frames = {{0,0}, {1,0}, {2,0}},
			speed = 0.4
		},
        hurt = {
            frames = {{3,0}}
        }
    }
}