state("Refunct-Win32-Shipping")
{
    byte button_count : 0x018ACA38, 0x504, 0x480, 0xCC, 0x4c, 0x20;
    float height : 0x18AEF84;
}

start
{
    return current.height <= -4800 && current.button_count == 0;
}

split
{
    return old.button_count < current.button_count;
}

reset
{
    return current.height <= -4800;
}
