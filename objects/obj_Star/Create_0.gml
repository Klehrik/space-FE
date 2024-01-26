/// Init

depth = 500;

image_speed = 0;
image_index = choose(0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5);

Alpha = random_range(0.3, 0.6);
image_alpha = Alpha / 2;
AlphaInc = choose(-0.002, 0.002);

x = irandom_range(4, (global.MAP_WIDTH * 16) - 4);
y = irandom_range(4, (global.MAP_HEIGHT * 16) - 4);