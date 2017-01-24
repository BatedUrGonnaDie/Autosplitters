state("Refunct-Win32-Shipping")
{
    int   level               : 0x01F16C84, 0x61C, 0xA8;
    int   resets              : 0x01F16C84, 0x61C, 0xAC;
    int   startSeconds        : 0x01F16C84, 0x61C, 0xB0;
    float startPartialSeconds : 0x01F16C84, 0x61C, 0xB4;
    int   endSeconds          : 0x01F16C84, 0x61C, 0xB8;
    float endPartialSeconds   : 0x01F16C84, 0x61C, 0xBC;
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
