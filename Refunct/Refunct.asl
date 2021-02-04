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
	var extraButtons = new Dictionary<int, int>
	{
		{7, 2},
		{10, 2},
		{18, 2},
		{26, 3},
		{28, 2}
	};

	settings.Add("Split on buttons:");
	settings.Add("Split on cubes:");

	for (int cluster = 1, actualButtonNumber = 1; cluster <= 31; ++cluster, ++actualButtonNumber)
	{
		if (extraButtons.ContainsKey(cluster))
		{
			for (int buttonInCluster = 1; buttonInCluster <= extraButtons[cluster]; ++buttonInCluster)
			{
				settings.Add("b" + actualButtonNumber, true, "Button " + cluster + "-" + buttonInCluster, "Split on buttons:");
				settings.SetToolTip("b" + actualButtonNumber, new[]{"First", "Second", "Third"}[buttonInCluster - 1] + " button of " + cluster);
				if (buttonInCluster < extraButtons[cluster]) ++actualButtonNumber;
			}
		}
		else
		{
			settings.Add("b" + actualButtonNumber, true, "Button " + cluster, "Split on buttons:");
		}
	}

	for (int cube = 1; cube <= 18; ++cube)
		settings.Add("c" + cube, false, "Cube " + cube, "Split on cubes:");

	vars.buttons = 0;
	vars.timerModel = new TimerModel { CurrentState = timer };
	
	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

update
{
	if (old.resets < current.resets)
	{
		vars.buttons = 0;
		if (current.buttons == 0 && settings.ResetEnabled)
			vars.timerModel.Reset();
	}
}

start
{
	if (old.resets < current.resets)
	{
		vars.buttons = current.buttons;
		return true;
	}
}

split
{
	if (current.buttons > vars.buttons)
	{
		++vars.buttons;
		return settings["b" + vars.buttons.ToString()];
	}

	if (old.cubes < current.cubes)
		return settings["c" + current.cubes.ToString()];
}

reset
{
	return false;
}

gameTime
{
	if (current.endSeconds > current.startSeconds)
	{
		float s = (float)(current.endSeconds - current.startSeconds);
		float ms = current.endPartialSeconds - current.startPartialSeconds;
		return TimeSpan.FromSeconds(s + ms);
	}
}
