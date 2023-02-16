XSPEED			= 0;
YSPEED			= 0;
GRAVITY			= 0.6;
WALK_SPEED		= 3;
JUMP_HEIGHT		= -14;

facing = image_xscale;

input = {};
check_input();

sprites = {};
init_sprites();

fsm = new SnowState("idle");

fsm
	.event_set_default_function("draw", function()
	{
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		image_xscale = facing;
	})
.add("idle",
{
	enter: function()
	{
		change_sprite();
	},
	step: function()
	{
		move_and_collide_old();
		apply_gravity();
	},
	leave: function()
	{
		
	}
})
.add("walk",
{
	enter: function()
	{
		change_sprite();
	},
	step: function()
	{
		move_and_collide_old();
		apply_gravity();
	}
})
.add("jump",
{
	enter: function()
	{
		change_sprite();
	},
	step: function()
	{
		if (AnimationEnd())
		{
			image_speed = 0;
			image_index = image_number - 1;
		}
		
		move_and_collide_old();
		apply_gravity();
	},
	leave: function()
	{
		
	}
})
.add("fall",
{
	enter: function()
	{
		change_sprite();
	},
	step: function()
	{
		move_and_collide_old();
		apply_gravity();
	}
});