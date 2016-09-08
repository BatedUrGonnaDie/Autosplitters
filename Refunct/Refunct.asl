state("Refunct-Win32-Shipping")
{
    byte level : 0x01D5DC14, 0xC, 0x54, 0x1C, 0x180, 0x50;
    int resets : 0x1DCF7DC;
}

start
{
    return current.resets > old.resets && current.resets > 2;
}

split
{
    return current.level > old.level;
}

reset
{
    return current.resets > old.resets;
}
