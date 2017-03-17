state("Refunct-Win32-Shipping")
{
    int   level               : 0x02081908, 0xBC, 0x18, 0x2B4, 0xF4, 0xAC;
    int   resets              : 0x02081908, 0xBC, 0x18, 0x2B4, 0xF4, 0xB0;
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
