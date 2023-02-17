IsFading = false;
FadeSpeed = 0.05;

alarm[0] = game_get_speed(gamespeed_fps) / 2;
sprite_index = choose(spr_CheeseCrumb, spr_CheeseCrumb1,
	spr_CheeseCrumb2, spr_CheeseCrumb3);
	
image_xscale *= 2;
image_yscale *= 2;

direction = irandom_range(0, 360);
speed = 1;