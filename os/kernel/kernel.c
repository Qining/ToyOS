#include "../drivers/basic_io_ports.h"

const unsigned int TERM_VIDEO_MEM_BASE = 0xb8000;
const unsigned int TERM_WIDTH = 80u;
const unsigned int TERM_HEIGHT = 25u;
const unsigned int BYTES_PER_PRINT_CHAR = 2u;

const char MSG_WELCOME[] = "ToyOS: <kernel> Welcome!\n";

void dummy_test_entrypoint() {
  // This is an empty dummy function.
  // Added to force us to create a kernel entry function
  // instead of jumping to kernel.c:0x00(this value is wrong)
  // directly. (?)
}

void flush_term_screen() {
  for (unsigned int i = 0u; i < TERM_WIDTH * TERM_HEIGHT; i++) {
    char* cursor = (char*)(TERM_VIDEO_MEM_BASE + i * BYTES_PER_PRINT_CHAR);
    *cursor = ' ';
  }
}

char* calculate_term_cursor_memory_address(unsigned int row, unsigned int col) {
  unsigned int bucket_loc = row * TERM_WIDTH + col;
  return (char*)(TERM_VIDEO_MEM_BASE + bucket_loc * BYTES_PER_PRINT_CHAR);
}

void print_string_kernel(const char* str, unsigned int row, unsigned int col) {
  while(*str != '\0') {
    char* cursor = calculate_term_cursor_memory_address(row, col);
    *cursor = *str;
    col++;
    row += col / TERM_WIDTH;
    col = col % TERM_WIDTH;
    str++;
  }
}

// BEGIN_PM => KERNEL_ADDR (kernel_entry.nasm) => main
// Note we don't have a large stack.
void main() {
  flush_term_screen();
  print_string_kernel(MSG_WELCOME, 0u,0u);

  unsigned int cursor_position;
  // To get the cursor position:
  // We need to query port 0x3d4 with value 14 to request the cursor position
  // high byte, and the same port with value 15 for the low byte.
  //
  // requesting the high byte:
  basic_io_ports_set_byte(0x3d4/*port*/, 14/*value*/);
  cursor_position = basic_io_ports_get_byte(0x3d5/*port*/);

  // requesting the lower byte:
  basic_io_ports_set_byte(0x3d4, 15);
  cursor_position = cursor_position << 8;
  cursor_position += basic_io_ports_get_byte(0x3d5);

  // we write a 'X' to the cursor postion.
  // it seems that we lost the welcome msg. (?)
  unsigned int vga_offset = BYTES_PER_PRINT_CHAR * cursor_position;
  char* vga = (char*) TERM_VIDEO_MEM_BASE;
  vga[vga_offset] = 'X';
  vga[vga_offset+1u] = 0x0f;
}
