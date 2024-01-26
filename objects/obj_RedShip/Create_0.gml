/// Init

image_speed = 0;
sprite_index = choose(spr_RedCruiser, spr_RedFighter);
image_index = 2;

PosX = irandom_range(0, global.MAP_WIDTH - 1);
PosY = irandom_range(0, global.MAP_HEIGHT - 1);

Map = -4;
Moved = -1;

// Stats
Team = 2;
Name = "Rebel";
Class = 0;
Hull = 2;
MaxHull = 2;
Shield = [0, 0, 0, 0]; // [Value, MaxHP, MaxMaxHP, Stun]
Engine = [3, 3, 3, 0]; // [Value, MaxHP, MaxMaxHP, Stun]
MaxMove = 5;
Weapons = [[0, 2, 2, 0]]; // [Weapon ID, HP, MaxHP, Stun]
Missiles = 5;
Systems = []; // [System ID, HP, MaxHP, Stun]

Team = 2;
Name = "Rebel";
Class = 0;
Hull = 8;
MaxHull = 8;
Shield = [8, 8, 8, 0]; // [Value, MaxHP, MaxMaxHP, Stun]
Engine = [8, 8, 8, 0]; // [Value, MaxHP, MaxMaxHP, Stun]
MaxMove = 5;
Weapons = [[0, 4, 4, 0], [4, 4, 4, 0], [9, 4, 4, 0], [9, 4, 4, 0]]; // [Weapon ID, HP, MaxHP, Stun]
Missiles = 5;
Systems = [[0, 4, 4, 0], [0, 4, 4, 0], [3, 4, 4, 0]]; // [System ID, HP, MaxHP, Stun]

//Team = 2;
//Name = "Rebel";
//Class = 0;
//Hull = 8;
//MaxHull = 8;
//Shield = [8, 8, 8, 0]; // [Value, MaxHP, MaxMaxHP, Stun]
//Engine = [8, 8, 8, 0]; // [Value, MaxHP, MaxMaxHP, Stun]
//MaxMove = 5;
//Weapons = [[0, 1, 2, 0], [4, 0, 2, 0], [9, 2, 4, 0], [9, 3, 4, 2]]; // [Weapon ID, HP, MaxHP, Stun]
//Missiles = 5;
//Systems = [[0, 3, 4, 1], [0, 3, 4, 2], [3, 4, 4, 1]]; // [System ID, HP, MaxHP, Stun]