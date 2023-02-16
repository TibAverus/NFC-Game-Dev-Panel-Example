function OnFrame(frame)
{
    return image_index >= frame && image_index < frame + 1 / sprite_get_speed(sprite_index);
}