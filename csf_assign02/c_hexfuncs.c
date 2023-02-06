// C implementation of hexdump functions

#include <unistd.h>  // this is the only system header file you may include!
#include "hexfuncs.h"


unsigned hex_read(char data_buf[]) {
  unsigned bytes = 0;
  bytes = read(STDIN_FILENO,data_buf,16);
  return bytes;
}

void hex_write_string(const char s[]) {
  // TODO: implement
}

void hex_format_offset(unsigned offset, char sbuf[]) {
  // TODO: implement
}

void hex_format_byte_as_hex(unsigned char byteval, char sbuf[]) {
  // TODO: implement
}

char hex_to_printable(unsigned char byteval) {
  // TODO: implement
}