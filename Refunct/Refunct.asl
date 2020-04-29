state("Refunct-Win32-Shipping")
{
    int   plusbuttons         : 0x1E32A90, 0x16C, 0x88, 0x24, 0x0, 0x90;
    int   cubes               : 0x1FBF9FC, 0xC0, 0x9C;
    int   level               : 0x1FBF9FC, 0xC0, 0xA8;
    int   resets              : 0x1FBF9FC, 0xC0, 0xAC;
    int   startSeconds        : 0x1FBF9FC, 0xC0, 0xB0;
    float startPartialSeconds : 0x1FBF9FC, 0xC0, 0xB4;
    int   endSeconds          : 0x1FBF9FC, 0xC0, 0xB8;
    float endPartialSeconds   : 0x1FBF9FC, 0xC0, 0xBC;
}

startup
{
    settings.Add("normalsplits", true, "Split when pressing progressive buttons");
    settings.Add("1", true, "Button 1 (split 1)", "normalsplits");
    settings.Add("2", true, "Button 2 (split 2)", "normalsplits");
    settings.Add("3", true, "Button 3 (split 3)", "normalsplits");
    settings.Add("4", true, "Button 4 (split 4)", "normalsplits");
    settings.Add("5", true, "Button 5 (split 5)", "normalsplits");
    settings.Add("6", true, "Button 6 (split 6)", "normalsplits");
    settings.Add("7", true, "Button 8 (second button of split 7)", "normalsplits");
    settings.Add("8", true, "Button 9 (split 8)", "normalsplits");
    settings.Add("9", true, "Button 10 (split 9)", "normalsplits");
    settings.Add("10", true, "Button 12 (second button of split 10)", "normalsplits");
    settings.Add("11", true, "Button 13 (split 11)", "normalsplits");
    settings.Add("12", true, "Button 14 (split 12)", "normalsplits");
    settings.Add("13", true, "Button 15 (split 13)", "normalsplits");
    settings.Add("14", true, "Button 16 (split 14)", "normalsplits");
    settings.Add("15", true, "Button 17 (split 15)", "normalsplits");
    settings.Add("16", true, "Button 18 (split 16)", "normalsplits");
    settings.Add("17", true, "Button 19 (split 17)", "normalsplits");
    settings.Add("18", true, "Button 21 (second button of split 18)", "normalsplits");
    settings.Add("19", true, "Button 22 (split 19)", "normalsplits");
    settings.Add("20", true, "Button 23 (split 20)", "normalsplits");
    settings.Add("21", true, "Button 24 (split 21)", "normalsplits");
    settings.Add("22", true, "Button 25 (split 22)", "normalsplits");
    settings.Add("23", true, "Button 26 (split 23)", "normalsplits");
    settings.Add("24", true, "Button 27 (split 24)", "normalsplits");
    settings.Add("25", true, "Button 28 (split 25)", "normalsplits");
    settings.Add("26", true, "Button 31 (third button of split 26)", "normalsplits");
    settings.Add("27", true, "Button 32 (split 27)", "normalsplits");
    settings.Add("28", true, "Button 34 (second button of split 28)", "normalsplits");
    settings.Add("29", true, "Button 35 (split 29)", "normalsplits");
    settings.Add("30", true, "Button 36 (split 30)", "normalsplits");
    settings.Add("31", true, "Button 37 (split 31)", "normalsplits");

    settings.Add("plusbuttonsplits", false, "Split when pressing non-progressive buttons");
    settings.Add("6.1", false, "Button 7 (first button of split 7)", "plusbuttonsplits");
    settings.Add("9.1", false, "Button 11 (first button of split 10)", "plusbuttonsplits");
    settings.Add("17.1", false, "Button 20 (first button of split 18)", "plusbuttonsplits");
    settings.Add("25.1", false, "Button 29 (first button of split 26)", "plusbuttonsplits");
    settings.Add("25.2", false, "Button 30 (second button of split 26)", "plusbuttonsplits");
    settings.Add("27.1", false, "Button 33 (first button of split 28)", "plusbuttonsplits");

    settings.Add("cubesplits", true, "Split when collecting cubes");
}

init
{
    vars.numPlusButton = 0;
}

update
{
    if (current.level != old.level)
    {
        vars.numPlusButton = 0;
    }
    else if (current.plusbuttons != old.plusbuttons)
    {
        vars.numPlusButton++;
    }
}

start
{
    return current.resets > old.resets;
}

split
{
    return
        (current.level > old.level && settings[current.level.ToString()]) ||
        (current.cubes > old.cubes && settings["cubesplits"]) ||
        (current.plusbuttons > old.plusbuttons && vars.numPlusButton > 0 && settings[current.level.ToString() + "." + vars.numPlusButton.ToString()]) ||
        current.resets > old.resets;
}

reset
{
    return current.resets > old.resets && current.level == 0;
}

gameTime
{
    if (current.endSeconds > current.startSeconds)
    {
        return TimeSpan.FromSeconds(
            Convert.ToDouble(current.endSeconds - current.startSeconds) +
            Convert.ToDouble(current.endPartialSeconds - current.startPartialSeconds)
        );
    }
}
