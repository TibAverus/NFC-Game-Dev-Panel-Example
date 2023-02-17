//scribble("Current state: " + string(fsm.get_current_state())).draw(50, 50);
draw_set_color(c_black);
draw_rectangle(50, 80, 210, 50, false);
scribble("[fnt_CheeseFont][spr_Cheese][wave] collected: " + string(CheeseCollected)).draw(50, 50);