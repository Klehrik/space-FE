/// Init

surface_resize(application_surface, 160, 144);
randomize();

depth = -1000;

global.DT = 0;

global.MAP_WIDTH = 40;
global.MAP_HEIGHT = 20;

global.UnitMap = ds_grid_create(global.MAP_WIDTH, global.MAP_HEIGHT);

// Music
Music1 = audio_play_sound(mus_Map1, 0, 1);
Music2 = audio_play_sound(mus_Battle1, 0, 1);
Music1Vol = 1;
Music2Vol = 0;
audio_sound_gain(Music2, 0, 0);

// Cursor
CsrX = 0;
CsrY = 0;
CsrXTo = 0;
CsrYTo = 0;
CsrMoveT = 0;

Selected = -4;
SelectedState = 0;

StatBarsX = -49; // -49, 4
StatBarsInst = -4;

// Option Box (after moving)
Option = 0;
OptionY = 0;
OptionState = 0;
OptionMoveT = 0;

// Camera
CamX = 0;
CamY = 0;
CamXTo = 0;
CamYTo = 0;

// Attacking variables
Targets = -4;
Target = 0;
TargetID = -4;
TargetRooms = [];

// Battle variables
Darken = 0;
StatBarsX2 = -49; // -49, 14
Weapon = 0;
WeaponC = 0;
WeaponT = 0;
EWeapon = 0;
ToHit = -4; // Rooms to hit

// Info Box
InfoBox = 0;
InfoBoxInst = -4;
IBOption = 0;
IBOptionY = 0;
IBOptionMoveT = 0;

for (var i = 0; i < 30; i += 1)
{
	instance_create_depth(0, 0, 0, obj_BlueShip);
	for (var j = 0; j < 3; j += 1) instance_create_depth(0, 0, 0, obj_RedShip);
}

for (var i = 0; i < (global.MAP_WIDTH * global.MAP_HEIGHT) / 3; i += 1) instance_create_depth(0, 0, 0, obj_Star);