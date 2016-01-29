const unsigned int TERM_VIDEO_MEM_BASE = 0xb8000;
unsigned int TERM_WIDTH = 80u;
unsigned int TERM_HEIGHT = 25u;
unsigned int BYTES_PER_PRINT_CHAR = 2u;

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
  return (char*)(BYTES_PER_PRINT_CHAR *
                     (((row % TERM_HEIGHT) + col / TERM_WIDTH) * TERM_WIDTH +
                      (col % TERM_WIDTH)) +
                 TERM_VIDEO_MEM_BASE);
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
  char* video_memory = (char*) TERM_VIDEO_MEM_BASE;
  *video_memory = 'X';

  flush_term_screen();
  print_string_kernel(MSG_WELCOME, 1u,0u);
}
