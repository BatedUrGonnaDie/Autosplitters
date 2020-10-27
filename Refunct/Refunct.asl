state("Refunct-Win32-Shipping")
{
    int   cubes               : 0x1FBF9EC, 0xC0, 0x9C;
    int   level               : 0x1FBF9EC, 0xC0, 0xA8;
    int   resets              : 0x1FBF9EC, 0xC0, 0xAC;
    int   startSeconds        : 0x1FBF9EC, 0xC0, 0xB0;
    float startPartialSeconds : 0x1FBF9EC, 0xC0, 0xB4;
    int   endSeconds          : 0x1FBF9EC, 0xC0, 0xB8;
    float endPartialSeconds   : 0x1FBF9EC, 0xC0, 0xBC;
}

init
{
    vars.levelTime = timer.CurrentTime.RealTime;
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
    settings.Add("levelsplits", true, "Split on level rise");
    for (var index = 1; index <= 31; ++index)
        settings.Add("l" + index.ToString(), true, "Level " + index.ToString() + " (button " + levelButtons[index - 1].ToString() + ")", "levelsplits");

    settings.Add("cubesplits", false, "Split on cube collect");
    for (var index = 1; index <= 18; ++index)
        settings.Add("c" + index.ToString(), true, "Cube " + index.ToString(), "cubesplits");
}

start
{
    if (current.resets != old.resets)
    {
        vars.levelTime = timer.CurrentTime.RealTime;
        return true;
    }
    return false;
}

split
{
    if (current.level != old.level && settings["l" + current.level.ToString()] && 
        (timer.CurrentTime.RealTime - vars.levelTime).TotalSeconds > 0.25)
    {
        vars.levelTime = timer.CurrentTime.RealTime;
        return true;
    }
    return
        current.cubes != old.cubes && settings["c" + current.cubes.ToString()] ||
        current.resets != old.resets;
}

reset
{
    if (current.resets != old.resets && current.level != 1)
    {
        vars.levelTime = timer.CurrentTime.RealTime;
        return true;
    }
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
