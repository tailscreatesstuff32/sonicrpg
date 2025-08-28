return {
    image = "monkey.png",
    starting = "idle",
    w = 31,
    h = 39,

    animations = {
		idle = {
			frames = {{0,0}, {1,0}},
			speed = 0.4
		},
        hold = {
            frames = {{2,0}}
        },
		throw = {
            frames = {{3,0},{4,0}},
			speed = 0.1
        },
		knockdown = {
            frames = {{5,0}}
        }
    }
}