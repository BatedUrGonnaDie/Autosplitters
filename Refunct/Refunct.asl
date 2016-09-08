state("Refunct-Win32-Shipping")
{
    byte button_count : 0x01E17CB0, 0x7A8, 0x6AC, 0x63C, 0x68, 0x20;
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
