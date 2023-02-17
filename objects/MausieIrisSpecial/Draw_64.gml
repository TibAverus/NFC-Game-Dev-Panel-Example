if (!IsShowing)
	return;

var ypos = display_get_gui_height() - sprite_get_height(spr_IrisFace);
var xposMausie = display_get_gui_width() - 150;
scribble("[fnt_Sque][rainbow]SQUE!").align(fa_center, fa_middle)
	.draw(display_get_gui_width() / 2, display_get_gui_height() - 50);

draw_sprite(spr_IrisFace, 1, 150, ypos);

draw_sprite(spr_MausieFace, 1, xposMausie, ypos);