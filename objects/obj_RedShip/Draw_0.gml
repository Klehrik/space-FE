/// Draw

if (Moved == 1) image_blend = $707070;
else image_blend = c_white;

draw_sprite_ext(sprite_index, image_index, x, y - sin(global.DT / 40), image_xscale, image_yscale, image_angle, image_blend, image_alpha);