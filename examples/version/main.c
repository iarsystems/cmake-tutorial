#include <stdio.h>

#include "version.h"

void main() {
  printf("%d.%d.%d\n", Project_VERSION_MAJOR, Project_VERSION_MINOR, Project_VERSION_PATCH);
}
