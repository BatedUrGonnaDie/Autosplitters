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
	timer.CurrentTimingMethod = TimingMethod.GameTime;
	vars.timerModel = new TimerModel { CurrentState = timer };

	string[] buttonNames = { "1", "2", "3", "4", "5", "6", "7-1", "7-2", "8", "9", "10-1", "10-2", "11", "12", "13", "14", "15", "16", "17", "18-1", "18-2", "19", "20", "21", "22", "23", "24", "25", "26-1", "26-2", "26-3", "27", "28-1", "28-2", "29", "30", "31" };

	settings.Add("buttons", true, "Split on buttons");
	for (var index = 1; index <= 37; ++index)
		settings.Add(index.ToString(), true, "Button " + buttonNames[index - 1], "buttons");

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
	if (current.resets != old.resets)
	{
		vars.buttons = current.buttons;
		vars.cubes = current.cubes;
		if (current.buttons == 0 && settings.ResetEnabled)
			vars.timerModel.Reset();
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
	return current.resets != old.resets && current.buttons > 0;
}

reset
{
	return false;
}

gameTime
{
	if (current.endSeconds > current.startSeconds)
		return TimeSpan.FromSeconds(
			Convert.ToDouble(current.endSeconds - current.startSeconds) +
			Convert.ToDouble(current.endPartialSeconds - current.startPartialSeconds)
		);
}
