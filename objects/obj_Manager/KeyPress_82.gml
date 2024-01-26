/// Reset

ds_grid_destroy(global.UnitMap);
if (Selected >= 0) { if (Selected.Map != -4) ds_grid_destroy(Selected.Map); }
audio_stop_all();

room_restart();