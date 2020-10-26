state("Refunct-Win32-Shipping") {
	int plusButtons           : 0x1F82E94, 0x274, 0x0, 0x8, 0x24, 0x0, 0x90;
	byte cubes                : 0x1FBF9EC, 0xC0, 0x9C;
	byte level                : 0x1FBF9EC, 0xC0, 0xA8;
	int resets                : 0x1FBF9EC, 0xC0, 0xAC;
	int startSeconds          : 0x1FBF9EC, 0xC0, 0xB0;
	float startPartialSeconds : 0x1FBF9EC, 0xC0, 0xB4;
	int endSeconds            : 0x1FBF9EC, 0xC0, 0xB8;
	float endPartialSeconds   : 0x1FBF9EC, 0xC0, 0xBC;
}

startup {
	vars.sW = new Stopwatch();
	vars.plusB = new HashSet<int> {6, 10, 19, 28, 32};

	settings.Add("normalSplits", true, "Split when raising the next set of platfoms");
		settings.Add("1", true, "Button 1 (split 1)", "normalSplits");
		settings.Add("2", true, "Button 2 (split 2)", "normalSplits");
		settings.Add("3", true, "Button 3 (split 3)", "normalSplits");
		settings.Add("4", true, "Button 4 (split 4)", "normalSplits");
		settings.Add("5", true, "Button 5 (split 5)", "normalSplits");
		settings.Add("6", true, "Button 6 (split 6)", "normalSplits");
		settings.Add("7", true, "Button 8 (second button of split 7)", "normalSplits");
		settings.Add("8", true, "Button 9 (split 8)", "normalSplits");
		settings.Add("9", true, "Button 10 (split 9)", "normalSplits");
		settings.Add("10", true, "Button 12 (second button of split 10)", "normalSplits");
		settings.Add("11", true, "Button 13 (split 11)", "normalSplits");
		settings.Add("12", true, "Button 14 (split 12)", "normalSplits");
		settings.Add("13", true, "Button 15 (split 13)", "normalSplits");
		settings.Add("14", true, "Button 16 (split 14)", "normalSplits");
		settings.Add("15", true, "Button 17 (split 15)", "normalSplits");
		settings.Add("16", true, "Button 18 (split 16)", "normalSplits");
		settings.Add("17", true, "Button 19 (split 17)", "normalSplits");
		settings.Add("18", true, "Button 21 (second button of split 18)", "normalSplits");
		settings.Add("19", true, "Button 22 (split 19)", "normalSplits");
		settings.Add("20", true, "Button 23 (split 20)", "normalSplits");
		settings.Add("21", true, "Button 24 (split 21)", "normalSplits");
		settings.Add("22", true, "Button 25 (split 22)", "normalSplits");
		settings.Add("23", true, "Button 26 (split 23)", "normalSplits");
		settings.Add("24", true, "Button 27 (split 24)", "normalSplits");
		settings.Add("25", true, "Button 28 (split 25)", "normalSplits");
		settings.Add("26", true, "Button 31 (third button of split 26)", "normalSplits");
		settings.Add("27", true, "Button 32 (split 27)", "normalSplits");
		settings.Add("28", true, "Button 34 (second button of split 28)", "normalSplits");
		settings.Add("29", true, "Button 35 (split 29)", "normalSplits");
		settings.Add("30", true, "Button 36 (split 30)", "normalSplits");
		settings.Add("31", true, "Button 37 (split 31)", "normalSplits");
	settings.Add("plusButtonSplits", false, "Split when pressing non-progressive buttons");
		settings.Add("6.1", false, "Button 7 (first button of split 7)", "plusButtonSplits");
		settings.Add("9.1", false, "Button 11 (first button of split 10)", "plusButtonSplits");
		settings.Add("17.1", false, "Button 20 (first button of split 18)", "plusButtonSplits");
		settings.Add("25.1", false, "Button 29 (first button of split 26)", "plusButtonSplits");
		settings.Add("25.2", false, "Button 30 (first button of split 26)", "plusButtonSplits");
		settings.Add("27.1", false, "Button 33 (first button of split 28)", "plusButtonSplits");
	settings.Add("cubeSplits", false, "Split when collecting cubes");
		for (var i = 1; i <= 18; i++) settings.Add("cube" + i.ToString(), false, "Cube Number " + i.ToString(), "cubeSplits")
	settings.Add("rando", false, "Enable Randomizer features");
		settings.Add("seeded", false, "Spliting on every button (mostly for seeded runs)", "rando");
}

init {
	vars.numPlusButton = 0;
}

update {
	if (current.level != old.level)
		if (vars.plusB.Contains(current.level)) vars.sW.Start();
		else {
			vars.sW.Reset();
			vars.numPlusButton = 0;
		}
}

start {
	return current.resets > old.resets;
}

split {
	if (settings["rando"]) return settings["seeded"] ? current.level != old.level && current.level != 0 : current.level != old.level && current.level == 31;
	else {
		if (current.plusButtons != old.plusButtons && vars.sW.ElapsedMilliseconds > 100) {
			vars.numPlusButton++;
			return settings[current.level.ToString() + "." + vars.numPlusButton.ToString()];
		} else
			return
				current.level > old.level && settings[current.level.ToString()] ||
				current.cubes > old.cubes && settings["cube" + current.cubes.ToString()] ||
				current.resets > old.resets;
	}
}

reset {
	return settings["rando"] ? current.resets > old.resets : current.resets > old.resets && current.level == 0;
}

gameTime {
	if (current.endSeconds > current.startSeconds)
		return TimeSpan.FromSeconds(
			Convert.ToDouble(current.endSeconds - current.startSeconds) +
			Convert.ToDouble(current.endPartialSeconds - current.startPartialSeconds)
		);
}
