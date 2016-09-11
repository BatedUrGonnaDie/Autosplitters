state("Refunct-Win32-Shipping")
{
    int level  : 0x01C79B64, 0xD0, 0x18, 0x2B0, 0xEC, 0xA0;
    int resets : 0x01DFF57C, 0x4, 0x0, 0x780, 0x38C, 0xA4;
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
    return current.resets > old.resets && current.level == 0;
}
