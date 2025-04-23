#include <ctype.h>
#include <limits.h>
#include <math.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#include "caller.h"
#include "callee.h"

// ARR30-C: Violation example (Using Past-the-End Index)
static int *table = NULL;
static size_t size = 0;
 
int insert_in_table(size_t pos, int value) {
  if (size < pos) {
    int *tmp;
    size = pos + 1;
    tmp = (int *)realloc(table, sizeof(*table) * size);
    if (tmp == NULL) {
      return -1;   /* Failure */
    }
    table = tmp;
  }
 
  table[pos] = value;
  return 0;
}

// ARR30-C: Violation example (Null Pointer Arithmetic)
char *init_block(size_t block_size, size_t offset,
                 char *data, size_t data_size) {
  char *buffer = malloc(block_size);
  if (data_size > block_size || block_size - data_size < offset) {
    /* Data won't fit in buffer, handle error */
  }
  memcpy(buffer + offset, data, data_size);
  return buffer;
}

// ARR30-C: Violation example (Pointer Past Flexible Array Member)
struct S {
  size_t len;
  char buf[];  /* Flexible array member */
};

const char *find(const struct S *s, int c) {
  const char *first = s->buf;
  const char *last  = s->buf + s->len;

  while (first++ != last) { /* Undefined behavior */
    if (*first == (unsigned char)c) {
      return first;
    }
  }
  return NULL;
}

void handle_error(void) {
  struct S *s = (struct S *)malloc(sizeof(struct S));
  if (s == NULL) {
    /* Handle error */
  }
  s->len = 0;
  find(s, 'a');
}

// FLP30-C: Violation example
void float_loop(void) {
  for (float x = 0.1f; x <= 1.0f; x += 0.1f) {
    /* Loop may iterate 9 or 10 times */
  }
}

// FLP30-C: Violation example
void flp30_2(void) {
  for (float x = 100000001.0f; x <= 100000010.0f; x += 1.0f) {
    /* Loop may not terminate */
  }
}

// FLP32-C: Violation example (sqrt())
double sqroot(double x) {
  double result;
  result = sqrt(x);
  return result;
}

// FLP37-C: Violation example
struct S2 {
  int i;
  float f;
};
  
bool are_equal(const struct S2 *s1, const struct S2 *s2) {
  if (!s1 && !s2)
    return true;
  else if (!s1 || !s2)
    return false;
  return 0 == memcmp(s1, s2, sizeof(struct S2));
}

// INT33-C: Violation example
signed long func(signed long s_a, signed long s_b) {
  signed long result;
  if ((s_a == LONG_MIN) && (s_b == -1)) {
    /* Handle error */
  } else {
    result = s_a / s_b;
  }
  /* ... */
  return result;
}

// MEM34-C: Violation example
enum { BUFSIZE = 256 };
int f1(void) {
  char *text_buffer = (char *)malloc(BUFSIZE);
  if (text_buffer == NULL) {
    return -1;
  }
  return 0;
}  

enum { STR_SIZE = 32 };
size_t str32(const char *source) {
  char c_str[STR_SIZE];
  size_t ret = 0;

  if (source) {
    c_str[sizeof(c_str) - 1] = '\0';
    strncpy(c_str, source, sizeof(c_str));
    ret = strlen(c_str);
  } else {
    /* Handle null pointer */
  }
  return ret;
}

// DCL38-C: Violation example
struct flexArrayStruct {
  int num;
  int data[1];
};

void dcl38(size_t array_size) {
  /* Space is allocated for the struct */
  struct flexArrayStruct *structP
    = (struct flexArrayStruct *)
     malloc(sizeof(struct flexArrayStruct)
          + sizeof(int) * (array_size - 1));
  if (structP == NULL) {
    /* Handle malloc failure */
  }

  structP->num = array_size;

  /*
   * Access data[] as if it had been allocated
   * as data[array_size].
   */
  for (size_t i = 0; i < array_size; ++i) {
    structP->data[i] = 1;
  }
}

size_t count_preceding_whitespace(const char *s) {
  const char *t = s;
  size_t length = strlen(s) + 1;
  while (isspace(*t) && (t - s < length)) {
    ++t;
  }
  return t - s;
}

int main() {
  caller();
}

