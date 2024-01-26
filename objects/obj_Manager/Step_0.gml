/// Step

global.DT += 1;



// === Functions ===

function deselect_ship()
{
	if (ds_exists(Selected.Map, ds_type_grid)) ds_grid_destroy(Selected.Map); // Destroy Selected's pathfinding map
	Selected.Map = -4;
	Selected = -4;
	SelectedState = 0;
}

function undo_move()
{
	Selected.PosX = PrevPosX;
	Selected.PosY = PrevPosY;
	Selected.x = PrevPosX * 16;
	Selected.y = PrevPosY * 16;
	update_pathfind_map(PrevPosX, PrevPosY);
	SelectedState = 0;
	Option = 0;
	OptionY = 0;
	OptionState = 0;
	Selected.Engine[0] += MoveCost;
}

// =================



// Music
if (SelectedState == 6)
{
	if (Music1Vol > 0) Music1Vol -= 0.01;
	if (Music2Vol < 1) Music2Vol += 0.01;
}
else
{
	if (Music1Vol < 1) Music1Vol += 0.01;
	if (Music2Vol > 0) Music2Vol -= 0.01;
}

Music1Vol = clamp(Music1Vol, 0, 1);
Music2Vol = clamp(Music2Vol, 0, 1);
audio_sound_gain(Music1, Music1Vol, 0);
audio_sound_gain(Music2, Music2Vol, 0);



// Move Cursor destination
if (SelectedState == 0 and InfoBox == 0)
{
	if (CsrMoveT > 0) CsrMoveT -= 1;
	else
	{
		if (keyboard_check(vk_left) and CsrXTo > 0) { CsrXTo -= 1; CsrMoveT = 8 / (keyboard_check(ord("X")) + 1); }
		if (keyboard_check(vk_right) and CsrXTo < global.MAP_WIDTH - 1) { CsrXTo += 1; CsrMoveT = 8 / (keyboard_check(ord("X")) + 1); }
		if (keyboard_check(vk_up) and CsrYTo > 0) { CsrYTo -= 1; CsrMoveT = 8 / (keyboard_check(ord("X")) + 1); }
		if (keyboard_check(vk_down) and CsrYTo < global.MAP_HEIGHT - 1) { CsrYTo += 1; CsrMoveT = 8 / (keyboard_check(ord("X")) + 1); }
	}
}

// Move Cursor sprite to destination smoothly
var difx = CsrXTo - CsrX;
var dify = CsrYTo - CsrY;
if (abs(difx) < 0.1) CsrX = CsrXTo else CsrX += difx / 3;
if (abs(dify) < 0.1) CsrY = CsrYTo else CsrY += dify / 3;



// Selected
var option_delay = 10;

if (InfoBox == 0)
{
	if (Selected < 0) // No ship selected
	{
		// Manage ship stats
		with (obj_Ship)
		{	
			if (Hull <= 0) instance_destroy();
		
			Hull = min(Hull, MaxHull);
			Shield[0] = min(Shield[0], Shield[1] - Shield[3]);
			Engine[0] = min(Engine[0], Engine[1] - Engine[3]);
		}
	
		if (keyboard_check_pressed(ord("Z"))) // Select ship
		{
			// Search for ship being selected
			with (obj_BlueShip)
			{
				if (Moved == -1 and PosX == other.CsrXTo and PosY == other.CsrYTo)
				{
					other.Selected = id;
					other.SelectedState = 0; // 0 - Choose Move, 1 - Moving, 2 - Choose Attack, etc.
					other.Option = 0;
					other.OptionY = 0;
					other.OptionState = 0;
			
					update_unit_map(); // Update UnitMap
			
					// Create pathfinding map (and destroy previous one if it exists)
					if (ds_exists(Map, ds_type_grid)) ds_grid_destroy(Map);
					Map = ds_grid_create(global.MAP_WIDTH, global.MAP_HEIGHT);
					update_pathfind_map(PosX, PosY);
				
					break;
				}
			}
		}
		else if (keyboard_check_pressed(ord("C"))) // View ship
		{
			// Search for ship being viewed
			with (obj_Ship)
			{
				if (PosX == other.CsrXTo and PosY == other.CsrYTo)
				{
					other.InfoBox = 1;
					other.IBInst = id;
					other.IBOption = 0;
					other.IBOptionY = 0;
					other.IBOptionMoveT = 0;
				
					break;
				}
			}
		}
	}
	else if (SelectedState == 0) // Ship - Move state
	{
		var cursorMoving = keyboard_check(vk_left) or keyboard_check(vk_right) or keyboard_check(vk_up) or keyboard_check(vk_down);
	
		if (keyboard_check_pressed(ord("Z"))) // Move ship
		{
			var move = min(Selected.Engine[1], Selected.MaxMove);
			var empty = global.UnitMap[# CsrXTo, CsrYTo] == 0;
			if (CsrXTo == Selected.PosX and CsrYTo == Selected.PosY)  SelectedState = 1; // Do not move
			else if (Selected.Map[# CsrXTo, CsrYTo] <= move and empty and Selected.Engine[0] >= 1) { MoveCost = 1; Selected.Engine[0] -= MoveCost; SelectedState = 1; } // Normal move
			else if (Selected.Map[# CsrXTo, CsrYTo] <= move * 2 and empty and Selected.Engine[0] >= 3) { MoveCost = 3; Selected.Engine[0] -= MoveCost; SelectedState = 1; } // Far move
			else deselect_ship();
		
			if (SelectedState == 1) // Update pathfinding map to new destination
			{
				PrevPosX = Selected.PosX;
				PrevPosY = Selected.PosY;
				update_pathfind_map(CsrXTo, CsrYTo);
			}
		}
		else if (keyboard_check_pressed(ord("X")) and !cursorMoving) deselect_ship(); // Deselect ship
		else if (keyboard_check_pressed(ord("C"))) // View ship
		{
			// Search for ship being viewed
			with (obj_Ship)
			{
				if (PosX == other.CsrXTo and PosY == other.CsrYTo)
				{
					other.InfoBox = 1;
					other.IBInst = id;
					other.IBOption = 0;
					other.IBOptionY = 0;
					other.IBOptionMoveT = 0;
				
					break;
				}
			}
		}
	}
	else if (SelectedState == 2) // Ship - Action state
	{
		// Move select cursor destination
		if (OptionMoveT > 0) OptionMoveT -= 1;
		else
		{
			if (keyboard_check(vk_up)) { Option -= 1; OptionMoveT = option_delay; }
			if (keyboard_check(vk_down)) { Option += 1; OptionMoveT = option_delay; }
		}
	
		if (Option < 0) Option = OptionState + 1;
		else if (Option > OptionState + 1) Option = 0;
	
		// Smoothly move select cursor
		var dify = Option - OptionY;
		if (abs(dify) < 0.1) OptionY = Option else OptionY += dify / 2;
	
		if (keyboard_check_pressed(ord("Z"))) // Select Option
		{
			if (OptionState == 0) // End, Cancel
			{
				if (Option == 0) // End move
				{
					Selected.Moved = 1;
					deselect_ship();
				}
				else undo_move(); // Undo move
			}
			else // Attack, End, Cancel
			{
				if (Option == 0) SelectedState = 3;
				else if (Option == 1) // End move
				{
					Selected.Moved = 1;
					deselect_ship();
				}
				else undo_move(); // Undo move
			}
		}
		else if (keyboard_check_pressed(ord("X"))) undo_move(); // Undo move
	}
	else if (SelectedState == 3) // Select weapon
	{
		// Move select cursor destination
		if (OptionMoveT > 0) OptionMoveT -= 1;
		else
		{
			if (keyboard_check(vk_up)) { Option -= 1; OptionMoveT = option_delay; }
			if (keyboard_check(vk_down)) { Option += 1; OptionMoveT = option_delay; }
		}
	
		if (Option < 0) Option = array_length(Selected.Weapons) - 1;
		else if (Option > array_length(Selected.Weapons) - 1) Option = 0;
	
		// Smoothly move select cursor
		var dify = Option - OptionY;
		if (abs(dify) < 0.1) OptionY = Option else OptionY += dify / 2;
	
		Weapon = Selected.Weapons[Option];
		if (keyboard_check_pressed(ord("Z")) and weapon_data(Weapon[0], "power") <= Weapon[1] - Weapon[3] and Selected.Missiles >= weapon_data(Weapon[0], "missiles"))
		{	
			if (ds_exists(Targets, ds_type_list)) ds_list_destroy(Targets);
			Targets = ds_list_create();
			Target = 0;
		
			// Get range of selected Weapon
			Weapon = Weapon[0];
			var range = weapon_data(Weapon, "range");
		
			// Add all enemies within range to Targets
			with (obj_RedShip) { if (abs(other.CsrXTo - PosX) + abs(other.CsrYTo - PosY) <= range) ds_list_add(other.Targets, id); }
		
			if (ds_list_size(Targets) > 0) SelectedState = 4;
		}
		else if (keyboard_check_pressed(ord("X"))) { SelectedState = 2; Option = 0; OptionY = 0; } // Go back
		else if (keyboard_check_pressed(ord("C"))) // View Weapon
		{
			other.InfoBox = 2;
			other.IBInst = Selected.Weapons[Option][0];
			other.IBOption = 0;
			other.IBOptionY = 0;
			other.IBOptionMoveT = 0;
		}
	}
	else if (SelectedState == 4) // Select target
	{
		Option = 0;
		OptionY = 0;
	
		// Move select cursor destination
		if (keyboard_check_pressed(vk_left) or keyboard_check_pressed(vk_down)) Target -= 1;
		else if (keyboard_check_pressed(vk_right) or keyboard_check_pressed(vk_up)) Target += 1;
	
		if (Target < 0) Target = ds_list_size(Targets) - 1;
		else if (Target >= ds_list_size(Targets)) Target = 0;
	
		// Move map cursor to target
		CsrXTo = Targets[| Target].PosX;
		CsrYTo = Targets[| Target].PosY;
	
		if (keyboard_check_pressed(ord("Z")))
		{
			SelectedState = 5;
		
			// Create an array of the Target's rooms
			TargetID = Targets[| Target];
			TargetRooms = ["S", "E"]; // eg. ["S", "E", "w0", "w1", "s0", "s1"]
			for (var i = 0; i < array_length(TargetID.Weapons); i += 1) TargetRooms[array_length(TargetRooms)] = "w" + string(i);
			for (var i = 0; i < array_length(TargetID.Systems); i += 1) TargetRooms[array_length(TargetRooms)] = "s" + string(i);
		
			if (ds_exists(ToHit, ds_type_list)) ds_list_destroy(ToHit);
			ToHit = ds_list_create();
		}
		else if (keyboard_check_pressed(ord("X"))) { SelectedState = 3; CsrXTo = Selected.PosX; CsrYTo = Selected.PosY; } // Go back
		else if (keyboard_check_pressed(ord("C"))) // View ship
		{
			// Search for ship being viewed
			with (obj_Ship)
			{
				if (PosX == other.CsrXTo and PosY == other.CsrYTo)
				{
					other.InfoBox = 1;
					other.IBInst = id;
					other.IBOption = 0;
					other.IBOptionY = 0;
					other.IBOptionMoveT = 0;
				
					break;
				}
			}
		}
	}
	else if (SelectedState == 5) // Target what?
	{
		// Move select cursor destination
		if (OptionMoveT > 0) OptionMoveT -= 1;
		else
		{
			if (keyboard_check(vk_up)) { Option -= 1; OptionMoveT = option_delay; }
			if (keyboard_check(vk_down)) { Option += 1; OptionMoveT = option_delay; }
		}
	
		if (Option < 0) Option = array_length(TargetRooms) - 1;
		else if (Option > array_length(TargetRooms) - 1) Option = 0;
	
		// Smoothly move select cursor
		var dify = Option - OptionY;
		if (abs(dify) < 0.1) OptionY = Option else OptionY += dify / 2;
	
		if (keyboard_check_pressed(ord("Z")))
		{
			// Add selected room to hit list (support for weapons that hit multiple rooms)
			if (ds_list_find_index(ToHit, TargetRooms[Option]) < 0) ds_list_add(ToHit, TargetRooms[Option]);
		
			if (ds_list_size(ToHit) >= weapon_data(Weapon, "rooms") or ds_list_size(ToHit) >= array_length(TargetRooms)) // Enter battle screen
			{
				SelectedState = 6;
				Darken = 0;
				StatBarsX2 = -49;
			
				WeaponC = weapon_data(Weapon, "count");
				WeaponT = 30;
			
				Selected.Missiles -= weapon_data(Weapon, "missiles");
			}
		}
		else if (keyboard_check_pressed(ord("X"))) SelectedState = 4; // Go back
	}
	else if (SelectedState == 6) // Battle Screen
	{
		if (StatBarsX2 >= 14) // Run sequence when bars and ships have finished sliding in
		{
			if (WeaponC > 0) // Player shoots
			{
				if (WeaponT > 0) WeaponT -= 1; // Delay
				else
				{
					WeaponT = 30;
					WeaponC -= 1; // <- disable for testing
				
					switch (weapon_data(Weapon, "type"))
					{					
						case 0: // Blasters
							WeaponT = 100;
							var proj = instance_create_depth(CamX + 48, CamY + 53, 0, obj_Proj);
							with (proj)
							{
								Damage = weapon_data(other.Weapon, "damage");
								SDamage = weapon_data(other.Weapon, "sdamage");
								Speed = weapon_data(other.Weapon, "speed");
								Miss = 0;
								motion_set(0, Speed);
								image_index = weapon_data(other.Weapon, "image");
							}
							audio_play_sound(sfx_Blaster, 1, 0);
							instance_create_depth(CamX + 48, CamY + 53, 0, obj_Effect);
							break;
						
						case 1: // Missiles
							WeaponT = 120;
							var proj = instance_create_depth(CamX + 48, CamY + 53, 0, obj_Proj);
							with (proj)
							{
								Damage = weapon_data(other.Weapon, "damage");
								SDamage = weapon_data(other.Weapon, "sdamage");
								Speed = weapon_data(other.Weapon, "speed");
								Miss = 0;
								motion_set(0, Speed);
								image_index = weapon_data(other.Weapon, "image");
							}
							audio_play_sound(sfx_Blaster, 1, 0);
							instance_create_depth(CamX + 48, CamY + 53, 0, obj_Effect);
							break;
						
						case 2: // Lasers
							WeaponT = 140;
							var proj = instance_create_depth(CamX + 48, CamY + 53, 0, obj_Proj);
							with (proj)
							{
								Damage = weapon_data(other.Weapon, "damage");
								SDamage = weapon_data(other.Weapon, "sdamage");
								Speed = weapon_data(other.Weapon, "speed");
								Miss = 0;
								Type = 1;
								X = other.CamX + 120;
								Room = 0;
								sprite_index = spr_Laser;
								image_index = weapon_data(other.Weapon, "image");
							}
							audio_play_sound(sfx_Laser, 1, 0);
							instance_create_depth(CamX + 48, CamY + 53, 0, obj_Effect);
							break;
						
						case 3: // Stun
							WeaponT = 120;
							var proj = instance_create_depth(CamX + 48, CamY + 53, 0, obj_Proj);
							with (proj)
							{
								Damage = weapon_data(other.Weapon, "damage");
								Speed = weapon_data(other.Weapon, "speed");
								Miss = 0;
								Type = 2;
								motion_set(0, Speed);
								image_index = weapon_data(other.Weapon, "image");
							}
							audio_play_sound(sfx_Blaster, 1, 0);
							instance_create_depth(CamX + 48, CamY + 53, 0, obj_Effect);
							break;
					}
				}
			}
			else // End battle (temporary)
			{
				if (WeaponT > 0) WeaponT -= 1;
				else SelectedState = 7;
			}
		
			// Proj Check
			with (obj_Proj)
			{
				if (Type == 0) // Blasters and Missiles
				{
					if (x >= other.CamX + 120 and Miss == 0)
					{
						// Random chance to hit that increases as the projectile passes by the ship
						// Hit range: x 120 ~ x 140
						if (irandom_range(1, 100) <= (((x - other.CamX) - 120) / 20) * 100)
						{
							if (other.TargetID.Engine[0] >= Speed) // Check if dodged
							{
								other.TargetID.Engine[0] = max(0, other.TargetID.Engine[0] - Speed);
								Miss = 1;
								audio_play_sound(sfx_Miss, 1, 0);
								var num = instance_create_depth(x, y - 8, 0, obj_HitNum);
								num.Text = "Miss";
								num.Colour = $27ecff;
							}
							else
							{
								other.TargetID.Engine[0] = 0;
						
								if (other.TargetID.Shield[0] > 0) // Shield hit
								{
									other.TargetID.Shield[0] = max(0, other.TargetID.Shield[0] - SDamage);
							
									var num = instance_create_depth(x, y - 8, 0, obj_HitNum);
									num.Text = SDamage;
									num.Colour = $ffad29;
								}
								else // Hull hit
								{
									other.TargetID.Hull = max(0, other.TargetID.Hull - Damage);
							
									// Room damage
									switch (string_copy(other.ToHit[| 0], 1, 1))
									{
										case "S":
											other.TargetID.Shield[1] = max(0, other.TargetID.Shield[1] - Damage);
											other.TargetID.Shield[0] = min(other.TargetID.Shield[0], other.TargetID.Shield[1]);
											break;
										
										case "E":
											other.TargetID.Engine[1] = max(0, other.TargetID.Engine[1] - Damage);
											other.TargetID.Engine[0] = min(other.TargetID.Engine[0], other.TargetID.Engine[1]);
											break;
										
										case "w":
											var num = real(string_copy(other.ToHit[| 0], 2, 1));
											other.TargetID.Weapons[num][1] = max(0, other.TargetID.Weapons[num][1] - Damage);
											break;
										
										case "s":
											var num = real(string_copy(other.ToHit[| 0], 2, 1));
											other.TargetID.Systems[num][1] = max(0, other.TargetID.Systems[num][1] - Damage);
											break;
									}
							
									var num = instance_create_depth(x, y - 8, 0, obj_HitNum);
									num.Text = Damage;
									num.Colour = $36e400;
								}
						
								audio_play_sound(sfx_Missile, 1, 0);
								var eff = instance_create_depth(x, y, 0, obj_Effect);
								eff.sprite_index = spr_ProjHit;
								instance_destroy();
							}
						}
					}
				}
			
				else if (Type == 1) // Lasers
				{
					instance_create_depth(other.CamX + 48, other.CamY + 53, 0, obj_Effect);
					var eff = instance_create_depth(X, y, 0, obj_Effect);
					eff.sprite_index = spr_ProjHit;
				
				
				
					if (X - (other.CamX + 120) > ceil(20 / ds_list_size(other.ToHit)) * Room)
					{
						if (other.TargetID.Shield[0] > 0) // Shield hit
						{
							other.TargetID.Shield[0] = max(0, other.TargetID.Shield[0] - SDamage);
							
							var num = instance_create_depth(X + 4, y - 8, 0, obj_HitNum);
							num.Text = SDamage;
							num.Colour = $ffad29;
						}
						else // Hull hit
						{
							other.TargetID.Hull = max(0, other.TargetID.Hull - Damage);
							
							// Room damage
							switch (string_copy(other.ToHit[| Room], 1, 1))
							{
								case "S":
									other.TargetID.Shield[1] = max(0, other.TargetID.Shield[1] - Damage);
									other.TargetID.Shield[0] = min(other.TargetID.Shield[0], other.TargetID.Shield[1]);
									break;
										
								case "E":
									other.TargetID.Engine[1] = max(0, other.TargetID.Engine[1] - Damage);
									other.TargetID.Engine[0] = min(other.TargetID.Engine[0], other.TargetID.Engine[1]);
									break;
										
								case "w":
									var num = real(string_copy(other.ToHit[| Room], 2, 1));
									other.TargetID.Weapons[num][1] = max(0, other.TargetID.Weapons[num][1] - Damage);
									break;
										
								case "s":
									var num = real(string_copy(other.ToHit[| Room], 2, 1));
									other.TargetID.Systems[num][1] = max(0, other.TargetID.Systems[num][1] - Damage);
									break;
							}
							
							var num = instance_create_depth(X + 4, y - 8, 0, obj_HitNum);
							num.Text = Damage;
							num.Colour = $36e400;
						}

						Room += 1;
					}
				
				
				
					X += 0.34;
					if (X >= other.CamX + 140) instance_destroy();
				}
			
				else if (Type == 2) // Stun
				{
					if (x >= other.CamX + 120 and Miss == 0)
					{
						// Random chance to hit that increases as the projectile passes by the ship
						// Hit range: x 120 ~ x 140
						if (irandom_range(1, 100) <= (((x - other.CamX) - 120) / 20) * 100)
						{
							if (other.TargetID.Engine[0] >= Speed) // Check if dodged
							{
								other.TargetID.Engine[0] = max(0, other.TargetID.Engine[0] - Speed);
								Miss = 1;
								audio_play_sound(sfx_Miss, 1, 0);
								var num = instance_create_depth(x, y - 8, 0, obj_HitNum);
								num.Text = "Miss";
								num.Colour = $27ecff;
							}
							else
							{
								other.TargetID.Engine[0] = 0;
							
								// Stun damage
								switch (string_copy(other.ToHit[| 0], 1, 1))
								{
									case "S":
										other.TargetID.Shield[3] += Damage;
										break;
										
									case "E":
										other.TargetID.Engine[3] += Damage;
										break;
										
									case "w":
										var num = real(string_copy(other.ToHit[| 0], 2, 1));
										other.TargetID.Weapons[num][3] += Damage;
										break;
										
									case "s":
										var num = real(string_copy(other.ToHit[| 0], 2, 1));
										other.TargetID.Systems[num][3] += Damage;
										break;
								}
							
								var num = instance_create_depth(x, y - 8, 0, obj_HitNum);
								num.Text = Damage;
								num.Colour = $9c7683;
						
								audio_play_sound(sfx_Missile, 1, 0);
								var eff = instance_create_depth(x, y, 0, obj_Effect);
								eff.sprite_index = spr_ProjHit;
								instance_destroy();
							}
						}
					}
				}
			}
		}
	
	
	
		//if (keyboard_check_pressed(ord("X"))) // Exit battle screen (temporary)
		//{
		//	SelectedState = 7;
		//}
	}
}

else if (InfoBox == 1) // View ship
{	
	// Move select cursor destination
	if (IBOptionMoveT > 0) IBOptionMoveT -= 1;
	else
	{
		if (keyboard_check(vk_up)) { IBOption -= 1; IBOptionMoveT = option_delay; }
		if (keyboard_check(vk_down)) { IBOption += 1; IBOptionMoveT = option_delay; }
	}
	
	if (IBOption < 0) IBOption = array_length(TargetRooms) - 1;
	else if (IBOption > array_length(TargetRooms) - 1) IBOption = 0;
	
	// Smoothly move select cursor
	var dify = IBOption - IBOptionY;
	if (abs(dify) < 0.1) IBOptionY = IBOption else IBOptionY += dify / 2;
	
	if (keyboard_check_pressed(ord("X"))) InfoBox = 0; // Close
}
else if (InfoBox == 2) // View Weapon / System
{
	if (keyboard_check_pressed(ord("X"))) InfoBox = 0; // Close
}



// Get Camera destination
if (CsrX * 16 >= CamXTo + 128) CamXTo += 16;
if (CsrX * 16 <= CamXTo + 16) CamXTo -= 16;
if (CsrY * 16 >= CamYTo + 111) CamYTo += 16;
if (CsrY * 16 <= CamYTo + 16) CamYTo -= 16;

// Clamp Camera destination within bounds
CamXTo = clamp(CamXTo, 0, (global.MAP_WIDTH * 16) - 160);
CamYTo = clamp(CamYTo, 0, (global.MAP_HEIGHT * 16) - 144);

// If on the borders, shift 1 pixel to display the border lines (the .4 is because GMS is wack)
if (CamXTo == (global.MAP_WIDTH * 16) - 160) CamXTo = (global.MAP_WIDTH * 16) - 160 + 1.4;
else if (CamXTo == 1) CamXTo = 0;
if (CamYTo == (global.MAP_HEIGHT * 16) - 144) CamYTo = (global.MAP_HEIGHT * 16) - 144 + 1.4;
else if (CamYTo == 1) CamYTo = 0;

// Move Camera to destination smoothly
var difx = CamXTo - CamX;
var dify = CamYTo - CamY;
if (abs(difx) < 1) CamX = CamXTo else CamX += difx / 12;
if (abs(dify) < 1) CamY = CamYTo else CamY += dify / 12;
camera_set_view_pos(view_camera, CamX, CamY);

show_debug_message(string(mouse_x) + " " + string(mouse_y));