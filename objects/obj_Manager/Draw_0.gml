/// Draw

draw_set_font(fnt_PICO8);



// Display Cursor
var spr = spr_Cursor;
if (Selected >= 0) spr = spr_YellowCursor;
draw_sprite(spr, (global.DT mod 80) / 40, CsrX * 16, CsrY * 16);



// Display StatBars of current moused-over ship
var ship = 0;
with (obj_Ship) { if (PosX == other.CsrXTo and PosY == other.CsrYTo) { ship = 1; other.StatBarsInst = id; } } // Get instance id of ship

if (StatBarsInst >= 0)
{
	if (instance_exists(StatBarsInst))
	{
		var inst = StatBarsInst;
		
		if (inst.Hull <= 0) ship = 0; // Slide bars out during battle screen (when Hull hits 0)
	
		if (ship == 1) // Slide bars in
		{
			var difx = 4 - StatBarsX;
			if (abs(difx) < 0.1) StatBarsX = 4 else StatBarsX += difx / 6;
		}
		else // Slide bars out
		{
			var difx = -49 - StatBarsX;
			if (abs(difx) < 0.1) StatBarsX = -49 else StatBarsX += difx / 6;
		}

		// Starting coords of the top-left corner of the display 
		var topx = CamX + StatBarsX;
		var topy = CamY + 113;
	
		draw_sprite(spr_StatBars, 0, topx, topy); // Hull
		for (var i = 0; i < inst.MaxHull; i += 1)
		{
			var spr = 3;
			if (i >= inst.Hull) spr = 6;
			draw_sprite(spr_StatBars, spr, topx + 10 + (i * 4), topy);
			if (i >= inst.MaxHull - 1) draw_sprite(spr_StatBars, 9, topx + 14 + (i * 4), topy); // End bit
		}
	
		draw_sprite(spr_StatBars, 1, topx, topy + 8); // Shield
		for (var i = 0; i < inst.Shield[2]; i += 1)
		{
			var spr = 4;
			if (i >= inst.Shield[0]) spr = 7;
			if (i >= inst.Shield[1]) spr = 12;
			else if (i >= inst.Shield[1] - inst.Shield[3]) spr = 14;
			draw_sprite(spr_StatBars, spr, topx + 10 + (i * 4), topy + 8);
			if (i >= inst.Shield[2] - 1) draw_sprite(spr_StatBars, 10, topx + 14 + (i * 4), topy + 8); // End bit
		}
	
		draw_sprite(spr_StatBars, 2, topx, topy + 16); // Engine
		for (var i = 0; i < inst.Engine[2]; i += 1)
		{
			var spr = 5;
			if (i >= inst.Engine[0]) spr = 8;
			if (i >= inst.Engine[1]) spr = 13;
			else if (i >= inst.Engine[1] - inst.Engine[3]) spr = 15;
			draw_sprite(spr_StatBars, spr, topx + 10 + (i * 4), topy + 16);
			if (i >= inst.Engine[2] - 1) draw_sprite(spr_StatBars, 11, topx + 14 + (i * 4), topy + 16); // End bit
		}
	}
}



// Display Options
if (SelectedState == 2) // Ship - Action state
{
	OptionState = 0;
	
	// Get maximum range of Weapons
	var range = 0;
	for (var i = 0; i < array_length(Selected.Weapons); i += 1)
	{
		var wep = weapon_data(Selected.Weapons[i][0], "range")
		if (wep > range) range = wep;
	}
	
	// Check if any enemies are within range
	for (var _y = -range; _y <= range; _y += 1)
	{
		for (var _x = -range; _x <= range; _x += 1)
		{
			var xpos = CsrXTo + _x;
			var ypos = CsrYTo + _y;
			
			if (xpos >= 0 and xpos < global.MAP_WIDTH and ypos >= 0 and ypos < global.MAP_HEIGHT) // Check if the position is within bounds
			{
				if (abs(CsrXTo - xpos) + abs(CsrYTo - ypos) <= range) // Check if the position is within the ship's range
				{
					if (global.UnitMap[# xpos, ypos] == 2) OptionState = 1; // Check if there is an enemy in the position
				}
			}
		}
	}
	
	// Top left corner of the option box
	var topx = CamX + 8;
	var topy = CamY + 8;
	
	draw_sprite(spr_Options, OptionState, topx, topy);
	draw_sprite(spr_Options, 2, topx + 2, topy + 2 + (OptionY * 8));
	
	if (OptionState == 0) // End, Cancel
	{
		draw_text(topx + 3, topy + 3, "End");
		draw_text(topx + 3, topy + 11, "Back");
	}
	else // Attack, End, Cancel
	{
		draw_text(topx + 3, topy + 3, "Attack");
		draw_text(topx + 3, topy + 11, "End");
		draw_text(topx + 3, topy + 19, "Back");
	}
}
else if (SelectedState == 3) // Select weapon
{
	// Top left corner of the option box
	var topx = CamX + 8;
	var topy = CamY + 8;
	
	// Draw box
	draw_sprite(spr_Options, 3, topx, topy);
	var col = $e8f1ff;
	draw_text_colour(topx + 3, topy + 3, "Weapons", col, col, col, col, 1);
	for (var i = 0; i < array_length(Selected.Weapons); i += 1) draw_sprite(spr_Options, 5, topx, topy + 10 + (i * 8));
	draw_sprite(spr_Options, 6, topx, topy + 10 + (array_length(Selected.Weapons) * 8));
	
	// Option cursor
	draw_sprite(spr_Options, 7, topx + 2, topy + 10 + (OptionY * 8));
	
	// Weapon data
	for (var i = 0; i < array_length(Selected.Weapons); i += 1)
	{
		// apparently "[$" is invalid syntax so i needed to put a dummy value ("0") at the front
		// yoyo pls fix
		var col = [0, $c7c3c2, $00a3ff, $ffad29, $36e400];
		col = col[weapon_data(Selected.Weapons[i][0], "type") + 1];
		
		
		
		// Check if Weapon cannot be powered
		if (weapon_data(Selected.Weapons[i][0], "power") > Selected.Weapons[i][1] - Selected.Weapons[i][3]) col = $4f575f;
		
		// Check if Weapon cannot reach any enemies
		var range = weapon_data(Selected.Weapons[i][0], "range");
		with (obj_RedShip) { if (abs(other.CsrXTo - PosX) + abs(other.CsrYTo - PosY) <= range) range = 100; }
		if (range < 99) col = $4f575f;
		
		// Check if ship does not have enough Missiles (for Missile weapons)
		if (Selected.Missiles < weapon_data(Selected.Weapons[i][0], "missiles")) col = $4f575f;
		
		draw_text_colour(topx + 3, topy + 11 + (i * 8), weapon_data(Selected.Weapons[i][0], "name"), col, col, col, col, 1);
		
		
		
		// Missile count
		draw_set_halign(fa_center);
		if (weapon_data(Selected.Weapons[i][0], "type") == 1) draw_text(topx + 69, topy + 11 + (i * 8), Selected.Missiles);
		draw_set_halign(fa_left);
	}
}
else if (SelectedState == 4) draw_sprite(spr_Options, 8, CamX + 8, CamY + 8); // Select target
else if (SelectedState == 5) // Target what?
{	
	// Top left corner of the option box
	var topx = CamX + 8;
	var topy = CamY + 8;
	
	// Draw box
	draw_sprite(spr_Options, 3, topx, topy);
	var col = $e8f1ff;
	draw_text_colour(topx + 3, topy + 3, "Target what?", col, col, col, col, 1);
	for (var i = 0; i < array_length(TargetRooms); i += 1) draw_sprite(spr_Options, 5, topx, topy + 10 + (i * 8));
	draw_sprite(spr_Options, 6, topx, topy + 10 + (array_length(TargetRooms) * 8));
	
	// Option cursor
	draw_sprite(spr_Options, 7, topx + 2, topy + 10 + (OptionY * 8));
	
	// Room Names (Shield, Engine, Weapons, Systems)
	for (var i = 0; i < array_length(TargetRooms); i += 1)
	{
		var name = "?";
		var col = $ffffff;
		
		switch (string_copy(TargetRooms[i], 1, 1)) // Check identifier of room (first letter in each element of TargetRooms)
		{
			case "S":
				name = "Shield";
				col = $ffad29;
				break;
				
				//// Draw HP
				//for (var j = 0; j < TargetID.Shield[2]; j += 1)
				//{
				//	var spr = 18;
				//	if (j < TargetID.Shield[0] and j < TargetID.Shield[1] - TargetID.Shield[3]) spr = 16;
				//	draw_sprite(spr_StatBars, spr, topx + 63 + (j * 2), topy + 11);
				//}
				
				//// Draw X and O
				//for (var j = TargetID.Shield[1]; j < TargetID.Shield[2]; j += 2) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 2), topy + 11);
				//for (var j = TargetID.Shield[1] - TargetID.Shield[3]; j < TargetID.Shield[1]; j += 2) draw_sprite(spr_StatBars, 20, topx + 63 + (j * 2), topy + 11);
				//break;
				
				
				
			case "E":
				name = "Engine";
				col = $27ecff;
				break;
				
				//// Draw HP
				//for (var j = 0; j < TargetID.Engine[2]; j += 1)
				//{
				//	var spr = 18;
				//	if (j < TargetID.Engine[0] and j < TargetID.Engine[1] - TargetID.Engine[3]) spr = 17;
				//	draw_sprite(spr_StatBars, spr, topx + 63 + (j * 2), topy + 19);
				//}
				
				//// Draw X and O
				//for (var j = TargetID.Engine[1]; j < TargetID.Engine[2]; j += 2) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 2), topy + 19);
				//for (var j = TargetID.Engine[1] - TargetID.Engine[3]; j < TargetID.Engine[1]; j += 2) draw_sprite(spr_StatBars, 20, topx + 63 + (j * 2), topy + 19);
				//break;
				
				
				
			case "w":
				var num = real(string_copy(TargetRooms[i], 2, 1));
				name = weapon_data(TargetID.Weapons[num][0], "name");
				var col_array = [0, $c7c3c2, $00a3ff, $ffad29, $36e400];
				col = col_array[weapon_data(TargetID.Weapons[num][0], "type") + 1];
				
				// Draw HP
				for (var j = 0; j < TargetID.Weapons[num][2]; j += 1)
				{
					var spr = 22;
					if (j < weapon_data(TargetID.Weapons[num][0], "power") and weapon_data(TargetID.Weapons[num][0], "power") <= TargetID.Weapons[num][1] - TargetID.Weapons[num][3]) spr = 21;
					draw_sprite(spr_StatBars, spr, topx + 63 + (j * 4), topy + 11 + (i * 8));
					
					// Draw X and O
					if (j >= TargetID.Weapons[num][1]) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 4), topy + 11 + (i * 8));
					else if (j >= TargetID.Weapons[num][1] - TargetID.Weapons[num][3]) draw_sprite(spr_StatBars, 20, topx + 63 + (j * 4), topy + 11 + (i * 8));
				}
				break;
				
				
			
			case "s":
				var num = real(string_copy(TargetRooms[i], 2, 1));
				name = system_data(TargetID.Systems[num][0], "name");
				col = $518700;
				
				// Draw HP
				for (var j = 0; j < TargetID.Systems[num][2]; j += 1)
				{
					var spr = 22;
					if (j < system_data(TargetID.Systems[num][0], "power") and system_data(TargetID.Systems[num][0], "power") <= TargetID.Systems[num][1] - TargetID.Systems[num][3]) spr = 21;
					draw_sprite(spr_StatBars, spr, topx + 63 + (j * 4), topy + 11 + (i * 8));
					
					// Draw X and O
					if (j >= TargetID.Systems[num][1]) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 4), topy + 11 + (i * 8));
					else if (j >= TargetID.Systems[num][1] - TargetID.Systems[num][3]) draw_sprite(spr_StatBars, 20, topx + 63 + (j * 4), topy + 11 + (i * 8));
				}
				break;
		}
		
		// Check if room is in ToHit; if so, colour it white
		if (ds_list_find_index(ToHit, TargetRooms[i]) >= 0) col = $e8f1ff;
		
		draw_text_colour(topx + 3, topy + 11 + (i * 8), name, col, col, col, col, 1);
	}

	//// Weapons HP		[ID, Room HP, Room MaxHP, Stun]
	//for (var i = 0; i < array_length(target.Weapons); i += 1) // Loop through all Weapons
	//{
	//	for (var j = 0; j < target.Weapons[i][2]; j += 1)
	//	{
	//		var spr = 22;
	//		if (j < weapon_data(target.Weapons[i][0], "power") and weapon_data(target.Weapons[i][0], "power") <= target.Weapons[i][1]) spr = 21; // Fill bar (unless the Weapon cannot be powered)
	//		draw_sprite(spr_StatBars, spr, topx + 63 + (j * 4), topy + 27 + (i * 8));
	//		if (j >= target.Weapons[i][1]) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 4), topy + 27 + (i * 8)); // Draw X
	//	}
	//}



	
	
	
	//// Target variables
	//var target = TargetID; // Get id of target instance
	//var count = 2 + array_length(target.Weapons) + array_length(target.Systems); // How much stuff there is to hit (Shield, Engine, Weapons, Systems)
	
	//// Draw box
	//draw_sprite(spr_Options, 4, topx, topy);
	//for (var i = 0; i < count; i += 1) draw_sprite(spr_Options, 5, topx, topy + 10 + (i * 8));
	//draw_sprite(spr_Options, 6, topx, topy + 10 + (count * 8));
	
	//// Option cursor
	//draw_sprite(spr_Options, 7, topx + 2, topy + 10 + (OptionY * 8));
	
	//// Shield, Engine (Text)
	//var col = $ffad29;
	//draw_text_colour(topx + 3, topy + 11, "Shield", col, col, col, col, 1);
	//var col = $27ecff;
	//draw_text_colour(topx + 3, topy + 19, "Engine", col, col, col, col, 1);
	
	//// Weapons (Names)
	//for (var i = 0; i < array_length(target.Weapons); i += 1)
	//{
	//	var col = [0, $c7c3c2, $00a3ff, $ffad29, $36e400];
	//	col = col[weapon_data(target.Weapons[i][0], "type") + 1];
	//	draw_text_colour(topx + 3, topy + 27 + (i * 8), weapon_data(target.Weapons[i][0], "name"), col, col, col, col, 1);
	//}
	
	//// Systems (Names)
	//for (var i = 0; i < array_length(target.Systems); i += 1)
	//{
	//	var col = $518700;
	//	draw_text_colour(topx + 3, topy + 27 + ((i + array_length(target.Weapons)) * 8), system_data(target.Systems[i][0], "name"), col, col, col, col, 1);
	//}
	
	//// Shield HP
	//for (var i = 0; i < target.Shield[2]; i += 1)
	//{
	//	var spr = 18;
	//	if (i < target.Shield) spr = 16;
	//	draw_sprite(spr_StatBars, spr, topx + 63 + (i * 2), topy + 11);
	//} // Draw X
	//for (var i = target.Shield[2] - (target.Shield[2] - target.MaxShield); i < target.Shield[2]; i += 2) draw_sprite(spr_StatBars, 19, topx + 63 + (i * 2), topy + 11);

	//// Engine HP
	//for (var i = 0; i < target.Engine[2]; i += 1)
	//{
	//	var spr = 18;
	//	if (i < target.Engine) spr = 17;
	//	draw_sprite(spr_StatBars, spr, topx + 63 + (i * 2), topy + 19);
	//} // Draw X
	//for (var i = target.Engine[2] - (target.Engine[2] - target.MaxEngine); i < target.Engine[2]; i += 2) draw_sprite(spr_StatBars, 19, topx + 63 + (i * 2), topy + 19);

	//// Weapons HP
	//for (var i = 0; i < array_length(target.Weapons); i += 1) // Loop through all Weapons
	//{
	//	for (var j = 0; j < target.Weapons[i][2]; j += 1)
	//	{
	//		var spr = 22;
	//		if (j < weapon_data(target.Weapons[i][0], "power") and weapon_data(target.Weapons[i][0], "power") <= target.Weapons[i][1]) spr = 21; // Fill bar (unless the Weapon cannot be powered)
	//		draw_sprite(spr_StatBars, spr, topx + 63 + (j * 4), topy + 27 + (i * 8));
	//		if (j >= target.Weapons[i][1]) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 4), topy + 27 + (i * 8)); // Draw X
	//	}
	//}
	
	//// Systems HP
	//for (var i = 0; i < array_length(target.Systems); i += 1) // Loop through all Systems
	//{
	//	for (var j = 0; j < target.Systems[i][2]; j += 1)
	//	{
	//		var spr = 22;
	//		if (j < system_data(target.Systems[i][0], "power") and system_data(target.Systems[i][0], "power") <= target.Systems[i][1]) spr = 21; // Fill bar (unless the System cannot be powered)
	//		draw_sprite(spr_StatBars, spr, topx + 63 + (j * 4), topy + 27 + ((array_length(target.Weapons) + i) * 8));
	//		if (j >= target.Systems[i][1]) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 4), topy + 27 + ((array_length(target.Weapons) + i) * 8)); // Draw X
	//	}
	//}
}
else if (SelectedState >= 6 and SelectedState < 50) // Battle screen
{
	// Darken screen
	if (SelectedState == 6 and Darken < 0.8) Darken += 0.017;
	else if (SelectedState >= 7 and Darken > 0) Darken -= 0.017;
	draw_set_alpha(Darken);
	draw_rectangle_colour(CamX, CamY, CamX + 160, CamY + 144, c_black, c_black, c_black, c_black, 0);
	draw_set_alpha(1);
	
	// StatBars x pos
	if (SelectedState == 6)
	{
		var difx = 14 - StatBarsX2;
		if (abs(difx) < 0.1) StatBarsX2 = 14 else StatBarsX2 += difx / 15;
	}
	else
	{
		var difx = -49 - StatBarsX2;
		if (abs(difx) < 0.1) StatBarsX2 = -49 else StatBarsX2 += difx / 15;
		
		// End Turn (reset variables)
		if (StatBarsX2 <= -48.7)
		{
			Selected.Moved = 1;
			deselect_ship();
		}
	}
	
	
	
	if (SelectedState >= 6) // Check if battle screen is still active
	{
		// Display StatBars of Selected
		var inst = Selected;

		// Starting coords of the top-left corner of the display 
		var topx = CamX + StatBarsX2;
		var topy = CamY + 75;
	
		draw_sprite(spr_StatBars, 0, topx, topy); // Hull
		for (var i = 0; i < inst.MaxHull; i += 1)
		{
			var spr = 3;
			if (i >= inst.Hull) spr = 6;
			draw_sprite(spr_StatBars, spr, topx + 10 + (i * 4), topy);
			if (i >= inst.MaxHull - 1) draw_sprite(spr_StatBars, 9, topx + 14 + (i * 4), topy); // End bit
		}
	
		draw_sprite(spr_StatBars, 1, topx, topy + 8); // Shield
		for (var i = 0; i < inst.Shield[2]; i += 1)
		{
			var spr = 4;
			if (i >= inst.Shield[0]) spr = 7;
			if (i >= inst.Shield[1]) spr = 12;
			else if (i >= inst.Shield[1] - inst.Shield[3]) spr = 14;
			draw_sprite(spr_StatBars, spr, topx + 10 + (i * 4), topy + 8);
			if (i >= inst.Shield[2] - 1) draw_sprite(spr_StatBars, 10, topx + 14 + (i * 4), topy + 8); // End bit
		}
	
		draw_sprite(spr_StatBars, 2, topx, topy + 16); // Engine
		for (var i = 0; i < inst.Engine[2]; i += 1)
		{
			var spr = 5;
			if (i >= inst.Engine[0]) spr = 8;
			if (i >= inst.Engine[1]) spr = 13;
			else if (i >= inst.Engine[1] - inst.Engine[3]) spr = 15;
			draw_sprite(spr_StatBars, spr, topx + 10 + (i * 4), topy + 16);
			if (i >= inst.Engine[2] - 1) draw_sprite(spr_StatBars, 11, topx + 14 + (i * 4), topy + 16); // End bit
		}
	
		// Display StatBars of Target
		var inst = Targets[| Target];

		// Starting coords of the top-left corner of the display 
		var topx = CamX + 161 - StatBarsX2;
		var topy = CamY + 75;
	
		draw_sprite_ext(spr_StatBars, 0, topx, topy, -1, 1, 0, c_white, 1); // Hull
		for (var i = 0; i < inst.MaxHull; i += 1)
		{
			var spr = 3;
			if (i >= inst.Hull) spr = 6;
			draw_sprite_ext(spr_StatBars, spr, topx - 10 - (i * 4), topy, -1, 1, 0, c_white, 1);
			if (i >= inst.MaxHull - 1) draw_sprite_ext(spr_StatBars, 9, topx - 14 - (i * 4), topy, -1, 1, 0, c_white, 1); // End bit
		}
	
		draw_sprite_ext(spr_StatBars, 1, topx, topy + 8, -1, 1, 0, c_white, 1); // Shield
		for (var i = 0; i < inst.Shield[2]; i += 1)
		{
			var spr = 4;
			if (i >= inst.Shield[0]) spr = 7;
			if (i >= inst.Shield[1]) spr = 12;
			else if (i >= inst.Shield[1] - inst.Shield[3]) spr = 14;
			draw_sprite_ext(spr_StatBars, spr, topx - 10 - (i * 4), topy + 8, -1, 1, 0, c_white, 1);
			if (i >= inst.Shield[2] - 1) draw_sprite_ext(spr_StatBars, 10, topx - 14 - (i * 4), topy + 8, -1, 1, 0, c_white, 1); // End bit
		}
	
		draw_sprite(spr_StatBars, 23, topx - 10, topy + 16); // Engine
		for (var i = 0; i < inst.Engine[2]; i += 1)
		{
			var spr = 5;
			if (i >= inst.Engine[0]) spr = 8;
			if (i >= inst.Engine[1]) spr = 13;
			else if (i >= inst.Engine[1] - inst.Engine[3]) spr = 15;
			draw_sprite_ext(spr_StatBars, spr, topx - 10 - (i * 4), topy + 16, -1, 1, 0, c_white, 1);
			if (i >= inst.Engine[2] - 1) draw_sprite_ext(spr_StatBars, 11, topx - 14 - (i * 4), topy + 16, -1, 1, 0, c_white, 1); // End bit
		}
		
		
		
		// Weapon Stats
		
		// Boxes
		for (var i = 0; i <= 24; i += 12) draw_sprite(spr_StatBars, 24, CamX + StatBarsX2 + i, CamY + 104);
		draw_sprite(spr_StatBars, 24, CamX + StatBarsX2 + 38, CamY + 104);
		for (var i = 0; i <= 24; i += 12) draw_sprite(spr_StatBars, 25, CamX + 151 - StatBarsX2 - i, CamY + 104);
		draw_sprite(spr_StatBars, 25, CamX + 151 - StatBarsX2 - 38, CamY + 104);
		
		// Numbers
		var col = $36e400;
		draw_text_colour(CamX + StatBarsX2 + 3, CamY + 106, weapon_data(Weapon, "damage"), col, col, col, col, 1);
		var col = $ffad29;
		draw_text_colour(CamX + StatBarsX2 + 15, CamY + 106, weapon_data(Weapon, "sdamage"), col, col, col, col, 1);
		var col = $27ecff;
		draw_text_colour(CamX + StatBarsX2 + 27, CamY + 106, weapon_data(Weapon, "speed"), col, col, col, col, 1);
		
		// Weapon Icons
		draw_sprite(spr_Icons, weapon_data(Weapon, "type") + 2, CamX + StatBarsX2 + 40, CamY + 106);
		
		
		
		// Draw ship sprites
		draw_sprite(spr_BlueShipsBattle, Selected.Class, CamX + StatBarsX2 + 2, CamY + 46);
		draw_sprite_ext(spr_RedShipsBattle, Selected.Class, CamX + 159 - StatBarsX2, CamY + 46, -1, 1, 0, c_white, 1);
	}
}

if (InfoBox == 1) // View ship
{
	TargetRooms = []; // eg. ["w0", "w1", "s0", "s1"]
	for (var i = 0; i < array_length(IBInst.Weapons); i += 1) TargetRooms[array_length(TargetRooms)] = "w" + string(i);
	for (var i = 0; i < array_length(IBInst.Systems); i += 1) TargetRooms[array_length(TargetRooms)] = "s" + string(i);
	
	
	
	// Top left corner of the option box
	var topx = CamX + 8;
	var topy = CamY + 8;
	
	// Draw box
	draw_sprite(spr_Options, 3, topx, topy);
	for (var i = 0; i < array_length(TargetRooms) + 5; i += 1) draw_sprite(spr_Options, 5, topx, topy + 10 + (i * 8));
	draw_sprite(spr_Options, 6, topx, topy + 10 + ((array_length(TargetRooms) + 5) * 8));
	
	// Option cursor
	draw_sprite(spr_Options, 7, topx + 2, topy + 50 + (IBOptionY * 8));
	
	// Hull
	var col = $e8f1ff;
	draw_text_colour(topx + 3, topy + 3, IBInst.Name + " (" + class_name(IBInst.Class) + ")", col, col, col, col, 1);
	var col = $c7c3c2;
	draw_text_colour(topx + 3, topy + 11, "Sharpshooter", col, col, col, col, 1);
	var col = $e8f1ff;
	draw_text_colour(topx + 3, topy + 27, "Move - 4", col, col, col, col, 1);
	draw_text_colour(topx + 3, topy + 35, "Missiles - " + string(IBInst.Missiles), col, col, col, col, 1);
	
	// Room Names (Shield, Engine, Weapons, Systems)
	for (var i = 0; i < array_length(TargetRooms); i += 1)
	{
		var name = "?";
		var col = $ffffff;
		
		switch (string_copy(TargetRooms[i], 1, 1)) // Check identifier of room (first letter in each element of TargetRooms)
		{
			//case "S":
			//	name = "Shield";
			//	col = $ffad29;
			//	break;
				
				//// Draw HP
				//for (var j = 0; j < Selected.Shield[2]; j += 1)
				//{
				//	var spr = 18;
				//	if (j < Selected.Shield[0] and j < Selected.Shield[1] - Selected.Shield[3]) spr = 16;
				//	draw_sprite(spr_StatBars, spr, topx + 63 + (j * 2), topy + 35);
				//}
				
				//// Draw X and O
				//for (var j = Selected.Shield[1]; j < Selected.Shield[2]; j += 2) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 2), topy + 35);
				//for (var j = Selected.Shield[1] - Selected.Shield[3]; j < Selected.Shield[1]; j += 2) draw_sprite(spr_StatBars, 20, topx + 63 + (j * 2), topy + 35);
				//break;
				
				
				
			//case "E":
			//	name = "Engine";
			//	col = $27ecff;
			//	break;
				
				//// Draw HP
				//for (var j = 0; j < Selected.Engine[2]; j += 1)
				//{
				//	var spr = 18;
				//	if (j < Selected.Engine[0] and j < Selected.Engine[1] - Selected.Engine[3]) spr = 17;
				//	draw_sprite(spr_StatBars, spr, topx + 63 + (j * 2), topy + 43);
				//}
				
				//// Draw X and O
				//for (var j = Selected.Engine[1]; j < Selected.Engine[2]; j += 2) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 2), topy + 43);
				//for (var j = Selected.Engine[1] - Selected.Engine[3]; j < Selected.Engine[1]; j += 2) draw_sprite(spr_StatBars, 20, topx + 63 + (j * 2), topy + 43);
				//break;
				
				
				
			case "w":
				var num = real(string_copy(TargetRooms[i], 2, 1));
				name = weapon_data(IBInst.Weapons[num][0], "name");
				var col_array = [0, $c7c3c2, $00a3ff, $ffad29, $36e400];
				col = col_array[weapon_data(IBInst.Weapons[num][0], "type") + 1];
				
				// Draw HP
				for (var j = 0; j < IBInst.Weapons[num][2]; j += 1)
				{
					var spr = 22;
					if (j < weapon_data(IBInst.Weapons[num][0], "power") and weapon_data(IBInst.Weapons[num][0], "power") <= IBInst.Weapons[num][1] - IBInst.Weapons[num][3]) spr = 21;
					draw_sprite(spr_StatBars, spr, topx + 63 + (j * 4), topy + 51 + (i * 8));
					
					// Draw X and O
					if (j >= IBInst.Weapons[num][1]) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 4), topy + 51 + (i * 8));
					else if (j >= IBInst.Weapons[num][1] - IBInst.Weapons[num][3]) draw_sprite(spr_StatBars, 20, topx + 63 + (j * 4), topy + 51 + (i * 8));
				}
				break;
				
				
			
			case "s":
				var num = real(string_copy(TargetRooms[i], 2, 1));
				name = system_data(IBInst.Systems[num][0], "name");
				col = $518700;
				
				// Draw HP
				for (var j = 0; j < IBInst.Systems[num][2]; j += 1)
				{
					var spr = 22;
					if (j < system_data(IBInst.Systems[num][0], "power") and system_data(IBInst.Systems[num][0], "power") <= IBInst.Systems[num][1] - IBInst.Systems[num][3]) spr = 21;
					draw_sprite(spr_StatBars, spr, topx + 63 + (j * 4), topy + 51 + (i * 8));
					
					// Draw X and O
					if (j >= IBInst.Systems[num][1]) draw_sprite(spr_StatBars, 19, topx + 63 + (j * 4), topy + 51 + (i * 8));
					else if (j >= IBInst.Systems[num][1] - IBInst.Systems[num][3]) draw_sprite(spr_StatBars, 20, topx + 63 + (j * 4), topy + 51 + (i * 8));
				}
				break;
		}
		
		draw_text_colour(topx + 3, topy + 51 + (i * 8), name, col, col, col, col, 1);
	}
}
else if (InfoBox == 2) // View Weapon
{
	// Top left corner of the option box
	var topx = CamX + 12;
	var topy = CamY + 26 + (Option * 8);
	
	// Draw box
	draw_sprite(spr_Options, 3, topx, topy);
	var lc = weapon_data(IBInst, "descLC");
	if (lc == 0)
	{
		for (var i = 0; i < 4; i += 1) draw_sprite(spr_Options, 5, topx, topy + 10 + (i * 8));
		draw_sprite(spr_Options, 6, topx, topy + 10 + (4 * 8));
	}
	else
	{
		for (var i = 0; i < 5 + lc; i += 1) draw_sprite(spr_Options, 5, topx, topy + 10 + (i * 8));
		draw_sprite(spr_Options, 6, topx, topy + 10 + ((5 + lc) * 8));
	}
	
	// Attack Stats
	var col = $e8f1ff;
	draw_text_colour(topx + 3, topy + 3, "Hull Dmg.      " + string(weapon_data(IBInst, "damage")), col, col, col, col, 1);
	draw_text_colour(topx + 3, topy + 11, "Shield Dmg.    " + string(weapon_data(IBInst, "sdamage")), col, col, col, col, 1);
	draw_text_colour(topx + 3, topy + 19, "Speed          " + string(weapon_data(IBInst, "speed")), col, col, col, col, 1);
	draw_text_colour(topx + 3, topy + 27, "Count          " + string(weapon_data(IBInst, "count")), col, col, col, col, 1);
	draw_text_colour(topx + 3, topy + 35, "Range          " + string(weapon_data(IBInst, "range")), col, col, col, col, 1);
	var col = $c7c3c2;
	draw_text_ext_colour(topx + 3, topy + 51, weapon_data(IBInst, "desc"), 7, 80, col, col, col, col, 1);
}



// Debug
//if (Selected >= 0)
//{
//	for (var _y = 0; _y < global.MAP_HEIGHT; _y += 1)
//	{
//		for (var _x = 0; _x < global.MAP_WIDTH; _x += 1)
//		{
//			draw_text(_x * 16, _y * 16, Selected.Map[# _x, _y]);
//		}
//	}
//}

draw_text(CamX + 1, CamY + 1, "FPS: " + string(fps));// + ", Instances: " + string(instance_count));