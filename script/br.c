/*
 * br — brightness wrapper around brightnessctl(1)
 * Usage: br <+N|-N>
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char **argv) {
  long incr;
  char delta[32];

  if (argc != 2 || (incr = strtol(argv[1], NULL, 10)) == 0)
    return 1;

  if (incr > 0)
    snprintf(delta, sizeof(delta), "+%ld", incr);
  else
    snprintf(delta, sizeof(delta), "%ld-", -incr);

  execlp("brightnessctl", "brightnessctl", "-q", "s", delta, (char *)NULL);
  perror("execlp");
  return 2;
}
