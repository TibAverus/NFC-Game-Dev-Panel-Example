/// @desc State machine transitions

fsm
	.add_transition("t_transition", "idle", "walk",
		function()
		{
			return input.hdir != 0;
		})
	.add_transition("t_transition", "walk", "idle",
		function()
		{
			return input.hdir == 0;
		})
	.add_transition("t_transition", ["walk", "idle"], "jump",
		function()
		{
			return input_check(["jump", "up"]);
		})
	.add_transition("t_transition", ["jump", "walk", "idle"], "fall",
		function()
		{
			return !on_ground() && YSPEED > 0;
		})
	.add_transition("t_transition", "fall", "idle",
		function()
		{
			return on_ground();
		})
	.add_transition("t_transition", "idle", "sleep_start",
		function()
		{
			return input_check("down");
		})
	.add_transition("t_transition", "sleep_loop", "wakeup",
		function()
		{
			return input_check(["left", "right", "jump"]);
		});