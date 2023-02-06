// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!

int main(void) {
  // a row will only be printed if 16 characters are produced or CTRLD
  char buf[16];
  hex_read(buf);
  // TODO
}
