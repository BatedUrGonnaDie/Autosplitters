state("Refunct-Win32-Shipping")
{
	int   cubes               : 0x1FBF9EC, 0xC0, 0xA4;
	int   buttons             : 0x1FBF9EC, 0xC0, 0xA8;
	int   resets              : 0x1FBF9EC, 0xC0, 0xAC;
	int   startSeconds        : 0x1FBF9EC, 0xC0, 0xB0;
	float startPartialSeconds : 0x1FBF9EC, 0xC0, 0xB4;
	int   endSeconds          : 0x1FBF9EC, 0xC0, 0xB8;
	float endPartialSeconds   : 0x1FBF9EC, 0xC0, 0xBC;
}

startup
{
	settings.Add("buttons", true, "Split on buttons");
	for (var index = 1; index <= 37; ++index)
		settings.Add(index.ToString(), true, "Button " + index.ToString(), "buttons");

	settings.Add("cubes", false, "Split on cubes");
	for (var index = 1; index <= 18; ++index)
		settings.Add("c" + index.ToString(), true, "Cube " + index.ToString(), "cubes");
}

start
{
	return current.resets != old.resets;
}

split
{
	return current.buttons != old.buttons && settings[current.buttons.ToString()] ||
		current.cubes != old.cubes && settings["c" + current.cubes.ToString()] ||
		current.resets != old.resets;
}

reset
{
	return current.resets != old.resets && current.buttons == 0;
}

gameTime
{
	if (current.endSeconds > current.startSeconds)
		return TimeSpan.FromSeconds(
			Convert.ToDouble(current.endSeconds - current.startSeconds) +
			Convert.ToDouble(current.endPartialSeconds - current.startPartialSeconds)
		);
}
