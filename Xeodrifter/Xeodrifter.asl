state("XeodrifterSteam")
{
    int   abilities : 0xAC208;
    int   health    : 0x630028;
    int   gun       : 0xAC20C;
    ulong frames    : 0xAC290;
}

startup
{
    vars.timerModel = new TimerModel { CurrentState = timer };
    settings.Add("health", false, "Split on Health Pickups");
    settings.Add("gun", false, "Split on Gun Upgrade Pickups");
}

update
{
    if (current.health < old.health || current.gun < old.gun)
    {
        int back_splits = (old.health - current.health) + (old.gun - current.gun);
        for (int i = 0; i < back_splits; i++) { vars.timerModel.UndoSplit(); }
    }
}

start
{
    return current.frames == 0 && old.frames > 0;
}

split
{
    if (settings["health"])
    {
        if (current.health > old.health) { return true; }
    }
    if (settings["gun"])
    {
        if (current.gun > old.gun) { return true; }
    }
    if (current.abilities > old.abilities)
    {
        return true;
    }
}

reset
{
    return current.frames == 0 && old.frames > 0;
}

gameTime
{
    return TimeSpan.FromSeconds(current.frames / 60);
}
