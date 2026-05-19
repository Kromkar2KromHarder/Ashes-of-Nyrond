#include "gs_inc_text"

//void main() {}

const int GS_ST_FOOD     = 1;
const int GS_ST_WATER    = 2;
const int GS_ST_REST     = 3;
const int GS_ST_SOBRIETY = 4;

void gsSTSetInitialState() {}
void gsSTProcessState() {}
void gsSTAdjustState(int nState, float fValue) {}
float gsSTGetState(int nState, object oCreature = OBJECT_SELF) { return 0.0; }
void gsSTPlayAnimation() {}
