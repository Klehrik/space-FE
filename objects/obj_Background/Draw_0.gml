/// Draw

depth = 1000;



// Grid Lines
var col = $532b1d;
for (var i = 0; i <= global.MAP_WIDTH * 16; i += 16)
{
	draw_set_alpha(0.5);
	draw_line_colour(i, -1, i, global.MAP_HEIGHT * 16, col, col);
	draw_set_alpha(1);
}
for (var i = 0; i <= global.MAP_HEIGHT * 16; i += 16)
{
	draw_set_alpha(0.5);
	draw_line_colour(0, i, global.MAP_WIDTH * 16, i, col, col);
	draw_set_alpha(1);
}



// Movement tiles
var m = obj_Manager;
if (m.Selected >= 0)
{
	if (m.SelectedState == 0) // Draw movement tiles
	{
		var move = min(m.Selected.Engine[1], m.Selected.MaxMove);
	
		for (var _y = 0; _y < global.MAP_HEIGHT; _y += 1)
		{
			for (var _x = 0; _x < global.MAP_WIDTH; _x += 1)
			{
				draw_set_alpha(0.8);
				if (m.Selected.Map[# _x, _y] <= move and m.Selected.Engine[0] >= 1) draw_sprite(spr_Tiles, 0, _x * 16, _y * 16);
				else if (m.Selected.Map[# _x, _y] <= move * 2 and m.Selected.Engine[0] >= 3) draw_sprite(spr_Tiles, 1, _x * 16, _y * 16);
				draw_set_alpha(1);
			}
		}
	
		// Draw MoveCost
		var cost = 0;
		if (m.Selected.Map[# m.CsrXTo, m.CsrYTo] <= move and m.Selected.Engine[0] >= 1) cost = 1;
		else if (m.Selected.Map[# m.CsrXTo, m.CsrYTo] <= move * 2 and m.Selected.Engine[0] >= 3) cost = 2; // Far move cost
		if (m.Selected.Map[# m.CsrXTo, m.CsrYTo] <= move * 2 and m.Selected.Engine[0] >= 1 and global.UnitMap[# m.CsrXTo, m.CsrYTo] == 0) draw_sprite(spr_MoveCost, cost, m.CsrXTo * 16 + 4, (m.CsrYTo * 16) + 6);
	}
	else if (m.SelectedState == 4) // Draw attack tiles
	{
		if (ds_exists(m.Targets, ds_type_list))
		{
			for (var i = 0; i < ds_list_size(m.Targets); i += 1)
			{
				var inst = m.Targets[| i];
				draw_sprite(spr_Tiles, 2, inst.PosX * 16, inst.PosY * 16);
			}
		}
	}
}