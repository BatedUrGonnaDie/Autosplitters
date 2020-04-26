state("Refunct-Win32-Shipping") {
    int   cubes               : 0x1FBF9FC, 0xC0, 0x9C;
    int   plusbuttons         : 0x1E32A90, 0x16C, 0x88, 0x24, 0x0, 0x90;
    int   level               : 0x1FBF9FC, 0xC0, 0xA8;
    int   paused              : 0x1E31200, 0x0, 0x660, 0x428;
    int   resets              : 0x1FBF9FC, 0xC0, 0xAC;
    int   startSeconds        : 0x1FBF9FC, 0xC0, 0xB0;
    float startPartialSeconds : 0x1FBF9FC, 0xC0, 0xB4;
    int   endSeconds          : 0x1FBF9FC, 0xC0, 0xB8;
    float endPartialSeconds   : 0x1FBF9FC, 0xC0, 0xBC;
}

startup {
    settings.Add("normalsplits", true, "splits when pressing progressive buttons");
        settings.Add("1", true, "button 1 (split 1)", "normalsplits");
        settings.Add("2", true, "button 2 (split 2)", "normalsplits");
        settings.Add("3", true, "button 3 (split 3)", "normalsplits");
        settings.Add("4", true, "button 4 (split 4)", "normalsplits");
        settings.Add("5", true, "button 5 (split 5)", "normalsplits");
        settings.Add("6", true, "button 6 (split 6)", "normalsplits");
        settings.Add("7", true, "button 8 (second button of split 7)", "normalsplits");
        settings.Add("8", true, "button 9 (split 8)", "normalsplits");
        settings.Add("9", true, "button 10 (split 9)", "normalsplits");
        settings.Add("10", true, "button 12 (second button of split 10)", "normalsplits");
        settings.Add("11", true, "button 13 (split 11)", "normalsplits");
        settings.Add("12", true, "button 14 (split 12)", "normalsplits");
        settings.Add("13", true, "button 15 (split 13)", "normalsplits");
        settings.Add("14", true, "button 16 (split 14)", "normalsplits");
        settings.Add("15", true, "button 17 (split 15)", "normalsplits");
        settings.Add("16", true, "button 18 (split 16)", "normalsplits");
        settings.Add("17", true, "button 19 (split 17)", "normalsplits");
        settings.Add("18", true, "button 21 (second button of split 18)", "normalsplits");
        settings.Add("19", true, "button 22 (split 19)", "normalsplits");
        settings.Add("20", true, "button 23 (split 20)", "normalsplits");
        settings.Add("21", true, "button 24 (split 21)", "normalsplits");
        settings.Add("22", true, "button 25 (split 22)", "normalsplits");
        settings.Add("23", true, "button 26 (split 23)", "normalsplits");
        settings.Add("24", true, "button 27 (split 24)", "normalsplits");
        settings.Add("25", true, "button 28 (split 25)", "normalsplits");
        settings.Add("26", true, "button 31 (third button of split 26)", "normalsplits");
        settings.Add("27", true, "button 32 (split 27)", "normalsplits");
        settings.Add("28", true, "button 34 (second button of split 28)", "normalsplits");
        settings.Add("29", true, "button 35 (split 29)", "normalsplits");
        settings.Add("30", true, "button 36 (split 30)", "normalsplits");
        settings.Add("31", true, "button 37 (split 31)", "normalsplits");
    settings.Add("plusbuttonsplits", false, "splits when pressing non-progressive buttons");
        settings.Add("6.1", false, "button 7 (first button of split 7)", "plusbuttonsplits");
        settings.Add("9.1", false, "button 11 (first button of split 10)", "plusbuttonsplits");
        settings.Add("17.1", false, "button 20 (first button of split 18)", "plusbuttonsplits");
        settings.Add("25.1", false, "button 29 (first button of split 26)", "plusbuttonsplits");
        settings.Add("25.2", false, "button 30 (second button of split 26)", "plusbuttonsplits");
        settings.Add("27.1", false, "button 33 (first button of split 28)", "plusbuttonsplits");
    settings.Add("cubesplits", true, "splits when collecting cubes");
    settings.Add("pausestart", true, "start timer when unpausing (for testing purposes)");
}

init {
    vars.currPlusLevel = "";
    vars.numPlusButton = 0;
}

update {
    if (current.level != old.level) {
        vars.numPlusButton = 0;
        print ("numPlusButton is now " + vars.numPlusButton);
    }
    
    if (current.level == old.level && current.plusbuttons != old.plusbuttons) {
        vars.numPlusButton = vars.numPlusButton + 1;
        vars.currPlusLevel = current.level.ToString() + "." + vars.numPlusButton.ToString();
        print ("numPlusButton is now " + vars.numPlusButton);
        print ("currPlusLevel is now " + vars.currPlusLevel);
    }
}

start {
    return current.resets > old.resets || current.paused < old.paused && settings["pausestart"];
}

split {
    return
        current.level > old.level && settings[current.level.ToString()] ||
        current.resets > old.resets ||
        current.plusbuttons != old.plusbuttons && vars.numPlusButton > 0 && settings[vars.currPlusLevel] ||
        current.cubes != old.cubes && settings["cubesplits"];
}

reset {
    return current.resets > old.resets && current.level == 0;
}

gameTime {
    if (current.endSeconds > current.startSeconds) {
        return TimeSpan.FromSeconds(
            Convert.ToDouble(current.endSeconds - current.startSeconds) +
            Convert.ToDouble(current.endPartialSeconds - current.startPartialSeconds)
        );
    }
}
