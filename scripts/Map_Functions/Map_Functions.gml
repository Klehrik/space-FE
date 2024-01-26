/// Map Functions

// Update the public UnitMap
function update_unit_map()
{
	ds_grid_clear(global.UnitMap, 0);
	with (obj_Ship) global.UnitMap[# PosX, PosY] = Team;
}

// Update a pathfinding map
function update_pathfind_map(X, Y)
{
	// Doing this terribleness to ensure that only Selected is calling this function
	// Now it can be called from whoever and still end up being called by Selected :)
	with (obj_Manager)
	{
		with (Selected)
		{
			ds_grid_clear(Map, 99); // Set distance of all tiles to 99
	
			Open = ds_list_create();
			ds_list_add(Open, [X, Y]);
			Map[# X, Y] = 0;
			
			while (ds_list_size(Open) > 0)
			{
				var i = Open[| 0];
		
				// Check the tiles in the four directions of the current tile
				var _x = [-1, 1, 0, 0];
				var _y = [0, 0, -1, 1];
				for (var j = 0; j < 4; j += 1)
				{
					if (i[0] + _x[j] >= 0 and i[0] + _x[j] < global.MAP_WIDTH and i[1] + _y[j] >= 0 and i[1] + _y[j] < global.MAP_HEIGHT)
					{
						if (Map[# i[0] + _x[j], i[1] + _y[j]] == 99 and global.UnitMap[# i[0] + _x[j], i[1] + _y[j]] <= 1) // Check if tile is 99 (unexplored)
						{
							Map[# i[0] + _x[j], i[1] + _y[j]] = Map[# i[0], i[1]] + 1; // Set value of checked tile to (current tile + 1)
							ds_list_add(Open, [i[0] + _x[j], i[1] + _y[j]]); // Add checked tile to the list
						}
					}
				}
				ds_list_delete(Open, 0);
			}
	
			ds_list_destroy(Open);
		}
	}
}