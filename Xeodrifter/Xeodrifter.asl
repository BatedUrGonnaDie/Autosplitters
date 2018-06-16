state("XeodrifterSteam")
{
    byte  paused    : 0x62D34A;
    int   location  : 0xA9900;
    int   text_box  : 0x62D390;
    ulong frames    : 0xAC290;
}

start
{
    return current.frames == 0 && old.frames > 0;
}

split
{
    if (old.text_box == 0 && current.text_box == 1 && (current.location == 155 || current.location == 166) && current.paused == 0)
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
