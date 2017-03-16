state("Refunct-Win32-Shipping")
{
    int   level               : 0x020D8908, 0x1AC, 0x18, 0x2B4, 0xF0, 0xAC;
    int   resets              : 0x020D8908, 0x1AC, 0x18, 0x2B4, 0xF0, 0xB0;
    int   startSeconds        : 0x020D8908, 0x1AC, 0x18, 0x2B4, 0xF0, 0xB4;
    float startPartialSeconds : 0x020D8908, 0x1AC, 0x18, 0x2B4, 0xF0, 0xB8;
    int   endSeconds          : 0x020D8908, 0x1AC, 0x18, 0x2B4, 0xF0, 0xBC;
    float endPartialSeconds   : 0x020D8908, 0x1AC, 0x18, 0x2B4, 0xF0, 0xC0;
}

start
{
    return current.resets > old.resets;
}

split
{
    return current.level > old.level || current.resets > old.resets;
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
