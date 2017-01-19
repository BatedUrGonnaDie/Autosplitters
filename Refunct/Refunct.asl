state("Refunct-Win32-Shipping")
{
    int   level               : 0x01E0804C, 0x788, 0x78, 0x2B0, 0x10C, 0xA0;
    int   resets              : 0x01E0804C, 0x788, 0x78, 0x2B0, 0x10C, 0xA4;
    int   startSeconds        : 0x01E0804C, 0x788, 0x78, 0x2B0, 0x10C, 0xA8;
    float startPartialSeconds : 0x01E0804C, 0x788, 0x78, 0x2B0, 0x10C, 0xAC;
    int   endSeconds          : 0x01E0804C, 0x788, 0x78, 0x2B0, 0x10C, 0xB0;
    float endPartialSeconds   : 0x01E0804C, 0x788, 0x78, 0x2B0, 0x10C, 0xB4;
}

start
{
    return current.resets > old.resets;
}

split
{
    return current.level > old.level;
}

reset
{
    return current.resets > old.resets;
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
