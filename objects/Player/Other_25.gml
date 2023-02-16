/// @desc Player functions

init_sprites = function()
{
	var _i = 0; 
	repeat (argument_count div 2)
	{
		var _noPipe = asset_get_index("spr_AmberRework_" + argument[_i + 1]);
		if (_noPipe == -1) _noPipe = spr_AmberRework_Idle;
		
		sprites[$ argument[_i]] = _noPipe;
		_i += 2;
	}
};

change_sprite = function()
{
	sprite_index = get_sprite();
	image_index = 0;
	image_speed = 1;
};

get_sprite = function() {
	return sprites[$ fsm.get_current_state()];
};

check_input = function() {
	with (input) {
		hdir	= input_check("right") - input_check("left");
	}
};

move_and_collide_old = function()
{
	if (place_meeting(x + XSPEED, y, COLLISION_OBJECT))
    {
        yplus = 0;
        while (place_meeting(x + XSPEED, y - yplus, COLLISION_OBJECT) && yplus <= abs(1 * XSPEED))
		{
			yplus += 1;
		}
        if place_meeting(x + XSPEED, y - yplus, COLLISION_OBJECT)
        {
            while (!place_meeting(x + sign(XSPEED), y, COLLISION_OBJECT))
			{
				x += sign(XSPEED);
			}
            XSPEED = 0;
        }
        else
        {
            y -= yplus;
        }
    }
    x += XSPEED;

    if !place_meeting(x, y, COLLISION_OBJECT) && YSPEED >= 0 && place_meeting(x, y + 2 + abs(XSPEED), COLLISION_OBJECT)
    {
        while (!place_meeting(x, y + 1, COLLISION_OBJECT))
        {
            y += 1;
        }
    }

    if (place_meeting(x, y + YSPEED, COLLISION_OBJECT))
    {
        while (!place_meeting(x, y + sign(YSPEED), COLLISION_OBJECT))
        {
            y += sign(YSPEED);
        }
        YSPEED = 0;
    }
    y += YSPEED;
};

on_ground = function() {
	return (place_meeting(x, y + 1, COLLISION_OBJECT));	
};

apply_gravity = function()
{
	YSPEED += GRAVITY;
};

check_jump = function()
{
	if (input_check_pressed("jump"))
	{
		fsm.trigger("t_jump");
	}	
};

set_movement = function()
{
	var _dir = input.hdir;
	if (_dir != 0) facing = _dir;

	XSPEED = CURRENT_MOVE_SPEED * _dir;
};