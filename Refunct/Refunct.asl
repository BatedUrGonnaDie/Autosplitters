state("Refunct-Win32-Shipping")
{
    int level : 0x1DCF7DC; // TODO: fix address
    int resets : 0x1DCF7DC; // TODO: fix address (must be right after level so +32bit = +0x20)
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
