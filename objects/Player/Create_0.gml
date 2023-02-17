XSPEED			= 0;
YSPEED			= 0;
WALK_SPEED		= 3;
JUMP_HEIGHT		= -10;

event_user(15);


facing = image_xscale;
mask_index = spr_Mausie_COLLISIONMASK;

input = {};
check_input();

sprites = {};
init_sprites(
	"fall", "Fall",
	"idle", "Idle",
	"jump", "Jump",
	"sleep_start", "SleepStart",
	"sleep_loop", "SleepLoop",
	"wakeup", "Wakeup",
	"walk", "Walk");

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
		XSPEED = 0;
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
		set_movement();
		move_and_collide_old();
		apply_gravity();
	}
})
.add("jump",
{
	enter: function()
	{
		XSPEED = 0;
		change_sprite();
	},
	step: function()
	{
		if (OnFrame(5))
			YSPEED = JUMP_HEIGHT;
		
		
		if (image_index > 5)
			set_movement();
		
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
		set_movement();
		move_and_collide_old();
		apply_gravity();
	}
})
.add("sleep_start",
{
	enter: function()
	{
		XSPEED = 0;
		change_sprite();
	},
	step: function()
	{
		if (AnimationEnd())
		{
			fsm.change("sleep_loop");
		}
		move_and_collide_old();
		apply_gravity();
	}
	
})
.add("sleep_loop",
{
	enter: function()
	{
		XSPEED = 0;
		change_sprite();
	},
	step: function()
	{
		move_and_collide_old();
		apply_gravity();
	}
})
.add("wakeup",
{
	enter: function()
	{
		XSPEED = 0;
		change_sprite();
	},
	step: function()
	{
		if (AnimationEnd())
		{
			fsm.change("idle");
		}
		move_and_collide_old();
		apply_gravity();
	}
});


event_user(14);