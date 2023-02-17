fsm = new SnowState("off");

fsm
	.event_set_default_function("draw", function()
	{
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	})
.add("off",
{
	enter: function()
	{
		sprite_index = spr_TV_On;
		image_index = 0;
		image_speed = 0;
	}
})
.add("turning_on",
{
	enter: function()
	{
		sprite_index = spr_TV_On;
		image_speed = 1;
	},
	step: function()
	{
		if (AnimationEnd())
		{
			fsm.change("turned_on");
		}
	}
})
.add("turned_on",
{
	enter: function()
	{
		sprite_index = spr_TV_Loop;
		image_speed = 1;
	},
	step: function()
	{
		
	}
})
.add("turning_off",
{
	enter: function()
	{
		sprite_index = spr_TV_Off;
		image_speed = 1;
	},
	step: function()
	{
		if (AnimationEnd())
		{
			fsm.change("off");
		}
	}
});