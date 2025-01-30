/*

run the following commands to configure: 
# gcc br.c -o br
# chown root br
# chmod u+s  br
# mv br /usr/local/bin/
# setcap cap_dac_override+ep /usr/local/bin/br

*/

#include <stdlib.h>
#include <stdio.h>
#define BUFSIZE 10

int main(int argc, char **argv) {
  FILE *fp;
  char scurr[BUFSIZE];
  long new, curr, incr, min = 1;

  /* An argument with an integer increment must be supplied */
  if (argc != 2 || (incr = strtol(argv[1], NULL, 10)) == 0) { return(1); }

  /* Retrieve the current brightness and increment it in the brightness file */
  if ((fp = fopen("/sys/class/backlight/nvidia_wmi_ec_backlight/brightness", "r+")) 
      && fgets(scurr, BUFSIZE, fp)) {
    curr = strtol(scurr, NULL, 10);
    rewind(fp);
    new = curr + incr;
    if (new < min) { new = min; }
    fprintf(fp, "%ld\n", new);
    fclose(fp);
  } else { return(2); }

  return(0);
}
