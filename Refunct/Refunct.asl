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

init
{
	vars.buttons = 0;
	vars.cubes = 0;
}

update
{
	if (old.resets != current.resets) {
		vars.buttons = current.buttons;
		vars.cubes = current.cubes;
		if (current.buttons == 0)
			new TimerModel {CurrentState = timer}.Reset();
	}
}

start
{
	if (current.resets != old.resets)
	{
		vars.buttons = current.buttons;
		vars.cubes = current.cubes;
		return true;
	}
}

split
{
	if (current.buttons > vars.buttons)
	{
		++vars.buttons;
		return settings[vars.buttons.ToString()];
	}
	if (current.cubes > vars.cubes)
	{
		++vars.cubes;
		return settings["c" + vars.cubes.ToString()];
	}
	return current.resets != old.resets;
}

gameTime
{
	if (current.endSeconds > current.startSeconds)
		return TimeSpan.FromSeconds(
			Convert.ToDouble(current.endSeconds - current.startSeconds) +
			Convert.ToDouble(current.endPartialSeconds - current.startPartialSeconds)
		);
}
