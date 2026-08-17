#include <stdio.h>

#include "version.h"

#if !defined(App_VERSION_MAJOR)
#define App_VERSION_MAJOR 0
#warning "App_VERSION_MAJOR defined but empty. Fallback to 0."
#endif

#if !defined(App_VERSION_MINOR)
#define App_VERSION_MINOR 0
#warning "App_VERSION_MINOR defined but empty. Fallback to 0."
#endif

#if !defined(App_VERSION_PATCH)
#define App_VERSION_PATCH 0
#warning "App_VERSION_PATCH defined but empty. Fallback to 0."
#endif

#if !defined(App_VERSION)
#define App_VERSION "0.0.0"
#warning "App_VERSION_PATCH defined but empty. Fallback to 0.0.0."
#endif

void main() {
  printf("Integer version: %d.%d.%d\n", App_VERSION_MAJOR, App_VERSION_MINOR, App_VERSION_PATCH);
  printf("String version: %s\n", App_VERSION);
}
