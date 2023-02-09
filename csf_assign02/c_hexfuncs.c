// C implementation of hexdump functions

#include <unistd.h>  // this is the only system header file you may include!
#include "hexfuncs.h"

// Read up to 16 bytes from standard input into data_buf.
// Returns the number of characters read.
unsigned hex_read(char data_buf[]) {
  unsigned bytes = 0;
  bytes = read(STDIN_FILENO,data_buf,16);
  return bytes;
}

// Write given nul-terminated string to standard output.
void hex_write_string(const char s[]) {

  
  write(STDOUT_FILENO,s,string_length(s));
  //alex will do this !
  // TODO: implement
}

int string_length(const char s[]) {
  char *ptr = &s[0];

  while(*ptr!='\0') {
    ptr++;
    
  }
  return (ptr - &s[0]);
  
}



// Format an unsigned value as an offset string consisting of exactly 8
// hex digits.  The formatted offset is stored in sbuf, which must
// have enough room for a string of length 8.
void hex_format_offset(unsigned offset, char sbuf[]) {
  for(int i = 3; i >= 0; i--) {
    unsigned char byte = 0xFF & offset >> (8*i);
    char buf[3];
    hex_format_byte_as_hex(byte, buf);
    sbuf[7-(2*i)] = buf[1];
    sbuf[7-(2*i+1)] = buf[0];
  }
  sbuf[8] = '\0';
}

const char HEX_DIGITS[16] = {'0', '1', '2', '3', '4', '5', '6', '7', '8',
                             '9','a','b','c','d', 'e', 'f'};

// Format a byte value (in the range 0-255) as string consisting
// of two hex digits.  The string is stored in sbuf.
void hex_format_byte_as_hex(unsigned char byteval, char sbuf[]) {
  sbuf[0] = HEX_DIGITS[byteval >> 4];
  sbuf[1] = HEX_DIGITS[byteval & 0x0F];
  sbuf[2] = '\0';
}

// Convert a byte value (in the range 0-255) to a printable character
// value.  If byteval is already a printable character, it is returned
// unmodified.  If byteval is not a printable character, then the
// ASCII code for '.' should be returned.
char hex_to_printable(unsigned char byteval) {
  // maybe not 38 and 126 limit? check disc
  if (byteval >= 38 && byteval <= 126)
    return byteval;
  return '.';
}