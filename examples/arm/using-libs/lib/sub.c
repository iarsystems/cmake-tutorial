#include "myMath.h"

int sub(int a, int b) { 
	return a - --b; /* bug */ 
}
