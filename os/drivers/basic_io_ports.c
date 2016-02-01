unsigned char basic_io_ports_get_byte(unsigned short port) {
  unsigned char result;
  
  // "=a" (result) means, 'result' should be the dst register of the
  // instruction.
  // It seems that result is mapped to %%al, and port is mapped to %%dx.
  // "a" means 'eax' register (actually only the lower 8 bits are used here).
  // "d" means 'edx'.
  // "in" is the opcode.
  // Note the syntax is different from nasm.
  // nasm is like Intel, dst register goes first.
  // Here is like AT&T, dst register goes last.
  // TODO: understand the embedded asm syntax.
  __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
  return result;
}

void basic_io_ports_set_byte(unsigned short port, unsigned char data) {
  // Note here we have a comma, and we have empty output areas!
  // This is because we have two input areas, and we don't have dst reg.
  __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

unsigned short basic_io_ports_get_word(unsigned short port) {
  unsigned short result;
  // Note here we use %%ax instead of %%al
  __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
  return result;
}

void basic_io_ports_set_word(unsigned short port, unsigned short data) {
  __asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
