function PickUp()
{
	repeat(irandom_range(6, 12))
	{
		instance_create_layer(x, y - 20, "Instances",
			CheeseBit);
	}
	CheeseCollected++;
	instance_destroy(id);
}