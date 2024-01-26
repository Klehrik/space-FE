/// Step

depth = -y;



// Update sprite position based on grid position
x += sign((PosX * 16) - x) * 2;
y += sign((PosY * 16) - y) * 2;



if (obj_Manager.Selected == id) { if (obj_Manager.SelectedState == 0) image_index = 4; }
else image_index = 0;

// Move to new destination
if (Map != -4)
{
	var pos = Map[# PosX, PosY];
	
	if (x == PosX * 16 and y == PosY * 16) // Check if not moving
	{
		if (pos > 0) // Find next tile to move to
		{
			var _x = [1, 0, -1, 0];
			var _y = [0, -1, 0, 1];
			for (var i = 0; i < 4; i += 1)
			{
				if (PosX + _x[i] >= 0 and PosX + _x[i] < global.MAP_WIDTH and PosY + _y[i] >= 0 and PosY + _y[i] < global.MAP_HEIGHT)
				{
					if (Map[# PosX + _x[i], PosY + _y[i]] < pos)
					{
						PosX += _x[i]; 
						PosY += _y[i];
						image_index = i;
						break;
					}
				}
			}
		}
		else if (obj_Manager.SelectedState == 1) obj_Manager.SelectedState = 2; // Return ping to notify move completion
	}
}