state("Refunct-Win32-Shipping")
{
    byte level : 0x01E14B78, 0xE0, 0x7B4, 0x80, 0x6FC, 0x20;
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
