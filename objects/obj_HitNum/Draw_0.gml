/// Draw

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var col = $000000;
draw_text_colour(x, y + 1, Text, col, col, col, col, 1);
var col = Colour;
draw_text_colour(x, y, Text, col, col, col, col, 1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

y -= 0.1;

if (Time > 0) Time -= 1;
else instance_destroy();