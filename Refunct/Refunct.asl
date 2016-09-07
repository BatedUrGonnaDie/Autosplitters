state("Refunct-Win32-Shipping")
{
    byte button_count : 0x01C79B64, 0x15C, 0x630, 0x118, 0x68, 0x20;
}

start
{
    return current.button_count == 0 && old.button_count != 0;
}

split
{
    return old.button_count < current.button_count;
}

reset
{
    return current.button_count == 0 && old.button_count != 0;
}
