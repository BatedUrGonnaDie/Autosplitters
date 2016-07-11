
state("Refunct-Win32-Shipping")
{
    byte button_count : 0x01909C54, 0x134, 0x23c, 0x104, 0x4c, 0x20;

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
