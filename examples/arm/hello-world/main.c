#include <intrinsics.h>
#include <stdio.h>
   
void main() {
   while (1) {
     printf("Hello world!\n");
     __no_operation();
   }
}

