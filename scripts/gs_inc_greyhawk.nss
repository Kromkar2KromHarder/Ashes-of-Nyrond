//void main() {}

string gsGWGetMonthName(int nMonth)
{
    switch (nMonth)
    {
    case 1:  return "Fireseek";
    case 2:  return "Readying";
    case 3:  return "Coldeven";
    case 4:  return "Planting";
    case 5:  return "Flocktime";
    case 6:  return "Wealsun";
    case 7:  return "Reaping";
    case 8:  return "Goodmonth";
    case 9:  return "Harvester";
    case 10: return "Patchwall";
    case 11: return "Ready'reat";
    case 12: return "Sunsebb";
    }
    return "Unknown";
}

string gsGWGetDayName(int nDay)
{
    switch (nDay % 7)
    {
    case 1: return "Starday";
    case 2: return "Sunday";
    case 3: return "Moonday";
    case 4: return "Godsday";
    case 5: return "Waterday";
    case 6: return "Earthday";
    case 0: return "Freeday";
    }
    return "Unknown";
}
