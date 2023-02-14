// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!

void write_offset(int offset) {
  char offbuf[9];
  hex_format_offset(offset,offbuf);
  hex_write_string(offbuf);
  hex_write_string(": ");

}

void add_spaces(int x) {
  if(x<16){
    for(int i = 16-x; i > 0; i--) {
      hex_write_string("   ");
    }
    
  }
}

int main(void) {
  // a row will only be printed if 16 characters are produced or CTRLD
  unsigned offset =0;
  for(;;){
    char buf[17];
    unsigned x = hex_read(buf);
    buf[16] = '\0';
    if(x==0){
      break;
    }

    write_offset(offset);

    for(int i = 0 ; i < x ; i++) {
      unsigned char byte = buf[i];
      char hbuf[3];
      hex_format_byte_as_hex(byte, hbuf);
      hex_write_string(hbuf);
      hex_write_string(" ");
    }

    add_spaces(x);
    hex_write_string(" ");
    for(int i = 0; i < x; i++) {
      char sbuf[2];
      sbuf[0] = hex_to_printable(buf[i]);
      sbuf[1] = '\0';
      
      hex_write_string(sbuf);
      
    }
    
    if(x<16){
      
      hex_write_string("\n");
      
      break;
    }
    
    hex_write_string("\n");
    offset = offset + 16;
  }



  //read to fill buffer 
  //print the address
  //print the hex values
  //print the string versions
  //print a new line if you reach 16 bytes
  //repeat 
  //one function that takes shit from buffer
  //one function that prints specific component from each line

  return 0;
}

