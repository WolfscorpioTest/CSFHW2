// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!

int main(void) {
  // a row will only be printed if 16 characters are produced or CTRLD
  char buf[16];
  hex_read(buf);
  char *s = "Hello";
  //hex_write_string(s);
  hex_format_offset(8, buf);
  hex_format_byte_as_hex(236, buf);
  hex_to_printable(69);
  // TODO
  return 0;
}
