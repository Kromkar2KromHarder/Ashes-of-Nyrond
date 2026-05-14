/* AREA Library by Gigaschatten */

//void main() {}

//return TRUE if oArea is active
int gsARGetIsAreaActive(object oArea);
//return x size of oArea
float gsARGetSizeX(object oArea);
//return y size of oArea
float gsARGetSizeY(object oArea);

int gsARGetIsAreaActive(object oArea)
{
    return GetLocalInt(oArea, "GS_ENABLED") &&
           GetLocalInt(oArea, "GS_TIMESTAMP") == GetLocalInt(GetModule(), "GS_TIMESTAMP");
}
//----------------------------------------------------------------
float gsARGetSizeX(object oArea)
{
    float fSize     = GetLocalFloat(oArea, "GS_AR_SIZE_X");
    if (fSize != 0.0) return fSize;

    location lLocation;
    vector vVector  = Vector();
    int nColor      = 0;
    fSize           = 1.0;

    while (fSize < 32.0)
    {
        vVector.x  = fSize;
        lLocation  = Location(oArea, vVector, 0.0);
        nColor     = GetTileMainLight1Color(lLocation);

        if (nColor < 0 || nColor > 32) break;

        fSize     += 1.0;
    }

    fSize          *= 10.0;
    SetLocalFloat(oArea, "GS_AR_SIZE_X", fSize);
    return fSize;
}
//----------------------------------------------------------------
float gsARGetSizeY(object oArea)
{
    float fSize     = GetLocalFloat(oArea, "GS_AR_SIZE_Y");
    if (fSize != 0.0) return fSize;

    location lLocation;
    vector vVector  = Vector();
    int nColor      = 0;
    fSize           = 1.0;

    while (fSize < 32.0)
    {
        vVector.y  = fSize;
        lLocation  = Location(oArea, vVector, 0.0);
        nColor     = GetTileMainLight1Color(lLocation);

        if (nColor < 0 || nColor > 32) break;

        fSize     += 1.0;
    }

    fSize          *= 10.0;
    SetLocalFloat(oArea, "GS_AR_SIZE_Y", fSize);
    return fSize;
}
