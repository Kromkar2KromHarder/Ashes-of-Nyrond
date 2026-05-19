void gsAdvanceTime()
{
    int nHour   = GetTimeHour();
    int nMinute = GetTimeMinute() + 5;

    if (nMinute >= 60)
    {
        nMinute -= 60;
        nHour   += 1;
    }
    if (nHour >= 24)
    {
        nHour = 0;
    }

    SetTime(nHour, nMinute, 0, 0);
    DelayCommand(60.0, gsAdvanceTime());
}

void main()
{
    gsAdvanceTime();
}
