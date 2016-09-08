state("Refunct-Win32-Shipping")
{
    byte level : 0x01E17CB0, 0x7A8, 0x6AC, 0x63C, 0x68, 0x20; // TODO: fix address
    //integer restarts // TODO: find address
}

start
{
    // TODO: replace uncommented with commented
    //return current.restarts == 1 && old.restarts == 0;
    return current.level == 0 && old.level != 0;
}

split
{
    return current.level > old.level;
}

reset
{
    // TODO: replace uncommented with commented
    //return current.restarts > old.restarts;
    return current.level == 0 && old.level != 0;
}
