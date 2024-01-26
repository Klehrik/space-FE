/// Init

image_speed = 0;
sprite_index = choose(spr_BlueCruiser, spr_BlueFighter);

PosX = irandom_range(0, (global.MAP_WIDTH / 2) - 1);
PosY = irandom_range(0, global.MAP_HEIGHT - 1);

Map = -4;
Moved = -1;

// Stats
Team = 1;
Name = char_name();
Class = 0;
Hull = 4;
MaxHull = 4;
Shield = [2, 2, 2, 0]; // [Value, MaxHP, MaxMaxHP, Stun]
Engine = [4, 4, 4, 0]; // [Value, MaxHP, MaxMaxHP, Stun]
MaxMove = 5;
Weapons = [[0, 2, 2, 0], [4, 2, 2, 0]]; // [Weapon ID, HP, MaxHP, Stun]
Missiles = 10;
Systems = [[-4, 2, 2, 0]]; // [System ID, HP, MaxHP, Stun]

Weapons = [[0, 4, 4, 0], [3, 4, 4, 0], [4, 4, 4, 0], [7, 4, 4, 0], [8, 4, 4, 0], [10, 4, 4, 0], [11, 4, 4, 0], [12, 4, 4, 0], [13, 4, 4, 0]]; // [Weapon ID, HP, MaxHP, Stun]

//Team = 1;
//Class = 0;
//Hull = 3;
//MaxHull = 4;
//Shield = 0;
//MaxShield = 1; // Max Shield (can be damaged)
//MaxMaxShield = 2; // Original Max Shield value
//Engine = 2;
//MaxEngine = 3; // Max Engine (can be damaged)
//MaxMaxEngine = 4; // Original Max Engine value
//MaxMove = 5;
//Weapons = [[2, 0], [2, 4]]; // [HP, Weapon ID]
//Missiles = 10;
//Systems = [[1, -4]]; // [HP, System ID]