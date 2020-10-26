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
    settings.Add("levelsplits", true, "Split on level rise");
    settings.Add("cubesplits", false, "Split on cube collect");
}

start
{
    if (current.resets > old.resets)
    {
        vars.levelTime = timer.CurrentTime.RealTime;
        return true;
    }
    return false;
}

split
{
    if (current.level > old.level && settings["levelsplits"] && 
        (timer.CurrentTime.RealTime - vars.levelTime).TotalSeconds > 1.0)
    {
        vars.levelTime = timer.CurrentTime.RealTime;
        return true;
    }
    return
        current.cubes > old.cubes && settings["cubesplits"] ||
        current.resets > old.resets;
}

reset
{
    if (current.resets > old.resets && current.level == 0)
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
