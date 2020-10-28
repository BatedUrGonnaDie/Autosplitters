state("Refunct-Win32-Shipping")
{
	int   subButtons          : 0x1F82E94, 0x274, 0x0, 0x8, 0x24, 0x0, 0x90;
	int   cubes               : 0x1FBF9EC, 0xC0, 0x9C;
	int   level               : 0x1FBF9EC, 0xC0, 0xA8;
	int   resets              : 0x1FBF9EC, 0xC0, 0xAC;
	int   startSeconds        : 0x1FBF9EC, 0xC0, 0xB0;
	float startPartialSeconds : 0x1FBF9EC, 0xC0, 0xB4;
	int   endSeconds          : 0x1FBF9EC, 0xC0, 0xB8;
	float endPartialSeconds   : 0x1FBF9EC, 0xC0, 0xBC;
}

startup
{
	int[] levelButtons = {
		1, 2, 3, 4, 5, 6,
		8, 9, 10,
		12, 13, 14, 15, 16, 17, 18, 19,
		21, 22, 23, 24, 25, 26, 27, 28,
		31, 32,
		34, 35, 36, 37
	};
	settings.Add("l", true, "Split on levels");
	for (var index = 1; index <= 31; ++index)
		settings.Add(index.ToString(), true, "Level " + index.ToString() + " (button " + levelButtons[index - 1].ToString() + ")", "l");

	settings.Add("b", false, "Split on sub-level buttons (experimental)");
	settings.Add("6-0", true, "Button 7 (level 6)", "b");
	settings.Add("9-0", true, "Button 11 (level 9)", "b");
	settings.Add("17-0", true, "Button 20 (level 17)", "b");
	settings.Add("25-0", true, "Button 29 (level 25)", "b");
	settings.Add("25-1", true, "Button 30 (level 25)", "b");
	settings.Add("27-0", true, "Button 33 (level 27)", "b");

	settings.Add("c", false, "Split on cubes");
	for (var index = 1; index <= 18; ++index)
		settings.Add("c" + index.ToString(), true, "Cube " + index.ToString(), "c");
}

init
{
	vars.splitTime = Environment.TickCount;
	vars.subButton = 0;
}

start
{
	if (current.resets != old.resets)
	{
		vars.splitTime = Environment.TickCount;
		vars.subButton = 0;
		return true;
	}
}

split
{
	if (current.level != old.level && settings[current.level.ToString()])
	{
		int time = Environment.TickCount;
		if (time - vars.splitTime > 200)
		{
			vars.splitTime = time;
			vars.subButton = 0;
			return true;
		}
	}
	if (current.subButtons != old.subButtons && settings[current.level.ToString() + "-" + vars.subButton.ToString()])
	{
		int time = Environment.TickCount;
		if (time - vars.splitTime > 200)
		{
			vars.splitTime = time;
			++vars.subButton;
			return true;
		}
	}
	return current.cubes != old.cubes && settings["c" + current.cubes.ToString()] ||
		current.resets != old.resets;
}

reset
{
	if (current.resets != old.resets && current.level != 1)
	{
		vars.splitTime = Environment.TickCount;
		vars.subButton = 0;
		return true;
	}
}

gameTime
{
	if (current.endSeconds > current.startSeconds)
		return TimeSpan.FromSeconds(
			Convert.ToDouble(current.endSeconds - current.startSeconds) +
			Convert.ToDouble(current.endPartialSeconds - current.startPartialSeconds)
		);
}
