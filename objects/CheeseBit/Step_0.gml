image_angle += irandom_range(1, 4);

if (IsFading)
{
	image_alpha -= FadeSpeed;
	
	if (image_alpha <= 0)
	{
		instance_destroy(id);
	}
}