/// Equipment Functions

// Find a value of a Weapon
function weapon_data(ID, val)
{
	switch (val)
	{
		case "name":
			var a = ["Light Blaster", "Heavy Blaster", "Dual Blaster", "Railgun",
			"Light Missile", "Heavy Missile", "Dual Missile", "Shield Breaker",
			"Light Laser", "Heavy Laser", "Focused Laser", "Hull Ripper", "Shield Cutter",
			"System Stunner", "Shield Boost",
			"Tri-Blaster", "Mega Laser", "System Stunner +", "Shield Boost +",
			"LRB Mk. I", "LRB Mk. II"];
			if (ID >= 0) return a[ID];
			else return "<Weapon Slot>";
			
		case "type":
			var a = [0, 0, 0, 0,   1, 1, 1, 1,   2, 2, 2, 2, 2,   3, 4,   0, 2, 3, 4,   0, 0];
			if (ID >= 0) return a[ID];
			else return 0;
			
		case "missiles":
			var a = [0, 0, 0, 0,   1, 1, 2, 1,   0, 0, 0, 0, 0,   0, 0,   0, 0, 0, 0,   0, 0];
			if (ID >= 0) return a[ID];
			else return 0;
		
		case "power":
			var a = [1, 2, 2, 3,   1, 2, 3, 3,   2, 3, 3, 3, 3,   2, 3,   3, 3, 3, 4,   0, 0];
			if (ID >= 0) return a[ID];
			else return 0;
			
		case "speed":
			var a = [3, 2, 2, 4,   2, 1, 2, 1,   0, 0, 0, 0, 0,   2, 0,   2, 0, 3, 0,   3, 3];
			if (ID >= 0) return a[ID];
			else return 0;
		
		case "range":
			var a = [1, 1, 1, 2,   1, 1, 1, 1,   2, 2, 4, 2, 2,   1, 1,   2, 3, 2, 1,   5, 6];
			if (ID >= 0) return a[ID];
			else return 0;
			
		case "damage":
			var a = [1, 3, 1, 4,   3, 4, 2, 2,   1, 2, 1, 1, 1,   4, 0,   2, 2, 6, 0,   2, 3];
			if (ID >= 0) return a[ID];
			else return 0;
			
		case "sdamage":
			var a = [1, 1, 1, 1,   3, 4, 2, 8,   0, 0, 0, 0, 2,   0, 0,   1, "?", 0, 0,  1, 2];
			if (ID >= 0) return a[ID];
			else return 0;
			
		case "count":
			var a = [1, 1, 2, 1,   1, 1, 2, 1,   1, 1, 1, 1, 1,   1, 0,   3, 1, 1, 0,   1, 1];
			if (ID >= 0) return a[ID];
			else return 0;
		
		case "rooms":
			var a = [1, 1, 1, 1,   1, 1, 1, 1,   2, 2, 2, 4, 2,   1, 0,   1, 2, 1, 0,   1, 1];
			if (ID >= 0) return a[ID];
			else return 0;
			
		case "image":
			var a = [0, 0, 0, 1,   2, 2, 2, 2,   0, 0, 1, 2, 3,   4, 0,   0, 0, 4, 0,   1, 1];
			if (ID >= 0) return a[ID];
			else return 0;
			
		case "desc":
			var a = ["", "", "", "Cooldown: 3 turns", // Blasters
			"Uses 1 Missile", "Uses 1 Missile", "Uses 2 Missiles", "Uses 1 Missile\nCooldown: 3 turns", // Missiles
			"Hits 2 rooms", "Hits 2 rooms", "Hits 2 rooms", "Hits 4 rooms\nCooldown: 3 turns", "Hits 2 rooms\nCooldown: 3 turns", // Lasers
			"Deals 4 Stun Damage\nCooldown: 3 turns", "", // Utility
			"", "Bypasses Shield", "Deals 6 Stun Damage\nCooldown: 3 turns", "", // Boss
			"", ""]; // Turret
			if (ID >= 0) return a[ID];
			else return "";
			
		case "descLC":
			var a = [0, 0, 0, 1,   1, 1, 1, 2,   1, 1, 1, 2, 2,   2, 0,   0, 1, 2, 0,   0, 0];
			if (ID >= 0) return a[ID];
			else return "";
	}
}

// Find a value of a System
function system_data(ID, val)
{
	switch (val)
	{
		case "name":
			var a = ["Blaster Def.", "Missile Def.", "Laser Shield",
			"Stun Shield", "Turbo Engine", "Missile Dupe."];
			if (ID >= 0) return a[ID];
			else return "<System Slot>";
		
		case "power":
			var a = [2, 2, 2, 3, 3, 2];
			if (ID >= 0) return a[ID];
			else return 0;
	}
}