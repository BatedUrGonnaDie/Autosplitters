state("Refunct-Win32-Shipping")
{
    int   level               : 0x01F2A33C, 0x388, 0xAC;
    int   resets              : 0x01F2A33C, 0x388, 0xB0;
    int   startSeconds        : 0x01F2A33C, 0x388, 0xB4;
    float startPartialSeconds : 0x01F2A33C, 0x388, 0xB8;
    int   endSeconds          : 0x01F2A33C, 0x388, 0xBC;
    float endPartialSeconds   : 0x01F2A33C, 0x388, 0xC0;
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
