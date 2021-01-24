state("Refunct-Win32-Shipping") {
	int   cubes               : 0x1FBF9EC, 0xC0, 0xA4;
	int   buttons             : 0x1FBF9EC, 0xC0, 0xA8;
	int   resets              : 0x1FBF9EC, 0xC0, 0xAC;
	int   startSeconds        : 0x1FBF9EC, 0xC0, 0xB0;
	float startPartialSeconds : 0x1FBF9EC, 0xC0, 0xB4;
	int   endSeconds          : 0x1FBF9EC, 0xC0, 0xB8;
	float endPartialSeconds   : 0x1FBF9EC, 0xC0, 0xBC;
}

startup {
	var eB = new Dictionary<int, int> {
		{7, 2},
		{10, 2},
		{18, 2},
		{26, 3},
		{28, 2}
	};

	settings.Add("Split on buttons:");
	settings.Add("Split on cubes:");

	for (int i = 1, bN = 1; i <= 31; ++i, ++bN)
		if (eB.ContainsKey(i))
			for (int j = 1; j <= eB[i]; ++j) {
				settings.Add("b" + bN, j == eB[i] ? true : false, "Button " + i + "-" + j, "Split on buttons:");
				settings.SetToolTip("b" + bN, (j == 1 ? "First" : j == 2 ? "Second" : "Third") + " button of " + i);
				if (j < eB[i]) ++bN;
			}
		else
			settings.Add("b" + bN, true, "Button " + i, "Split on buttons:");

	for (int i = 1; i <= 18; ++i)
		settings.Add("c" + i, false, "Cube " + i, "Split on cubes:");

	vars.buttons = 0;
}

start {
	if (old.resets < current.resets) {
		vars.buttons = current.buttons;
		return true;
	}
}

split {
	if (old.resets < current.resets && current.buttons != 0) vars.buttons = 0;

	if (current.buttons > vars.buttons) {
		++vars.buttons;
		return settings["b" + vars.buttons.ToString()];
	}

	if (old.cubes < current.cubes)
		return settings["c" + current.cubes.ToString()];
}

reset {
	return old.resets < current.resets && current.buttons == 0;
}

gameTime {
	if (current.endSeconds > current.startSeconds) {
		float s = (float)(current.endSeconds - current.startSeconds);
		float ms = current.endPartialSeconds - current.startPartialSeconds;
		return TimeSpan.FromSeconds(s + ms);
	}
}
