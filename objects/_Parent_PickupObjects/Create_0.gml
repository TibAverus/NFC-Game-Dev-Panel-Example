function PickUp()
{
	show_debug_message("Item picked up with id: " + string(id));
	instance_destroy(id);
}