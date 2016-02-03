#include "basic_screen.h"
#include "basic_io_ports.h"

// private functions

// Get memory offset from column and row value
unsigned int get_offset_from_row_col(unsigned int row, unsigned int col) {
  return BASIC_SCREEN_BYTES_PER_CELL *
         (((row + col / BASIC_SCREEN_MAX_COL) % BASIC_SCREEN_MAX_ROW) *
              BASIC_SCREEN_MAX_COL +
          col % BASIC_SCREEN_MAX_COL);
}

// Get row from memory offset
unsigned int get_row_from_offset(unsigned int offset) {
  return offset / BASIC_SCREEN_BYTES_PER_CELL / BASIC_SCREEN_MAX_COL;
}

// Get col from memory offset
unsigned int get_col_from_offset(unsigned int offset) {
  return (offset / BASIC_SCREEN_BYTES_PER_CELL) % BASIC_SCREEN_MAX_COL;
}

// Get current cursor offset in video memory
unsigned int get_current_cursor_offset() {
  unsigned int cursor_offset;
  // To get the cursor offset, which is a dword (long/32 bit) data:
  // We need to query port 0x3d4 with value 14 to request the cursor offset
  // high byte, and the same port with value 15 for the low byte.
  //
  // requesting the high byte:
  basic_io_ports_set_byte(BASIC_SCREEN_CTRL, 14 /*value*/);
  cursor_offset = basic_io_ports_get_byte(BASIC_SCREEN_DATA /*port*/);

  // requesting the lower byte:
  basic_io_ports_set_byte(BASIC_SCREEN_CTRL, 15);
  cursor_offset = cursor_offset << 8;
  cursor_offset += basic_io_ports_get_byte(BASIC_SCREEN_DATA);
  // What we have is the 'offset' in terms of video device, which use 'short'
  // for each cell. But we want the offset in terms of memory space, so we
  // need
  // to time the number of bytes used to represent one cell in video memory.
  cursor_offset *= BASIC_SCREEN_BYTES_PER_CELL;
  return cursor_offset;
}

// Set cursor offset in video memory
void set_cursor_offset(unsigned int offset) {
  offset /= BASIC_SCREEN_BYTES_PER_CELL;
  basic_io_ports_set_byte(BASIC_SCREEN_CTRL, 14);
  basic_io_ports_set_byte(BASIC_SCREEN_DATA, (unsigned char)(offset >> 8));
  basic_io_ports_set_byte(BASIC_SCREEN_CTRL, 15);
  basic_io_ports_set_byte(BASIC_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

void print_at_offset(const char* str, unsigned int offset) {
  while (*str != '\0') {
    char* cursor = (char*)(BASIC_SCREEN_VIDEO_MEMORY_BASE + offset);
    *cursor = *str;
    *(cursor + 1u) = BASIC_SCREEN_WHITE_ON_BLACK;
    offset += BASIC_SCREEN_BYTES_PER_CELL;
    str += 1;
  }
}

// public functions

// clear screen
void kclear_screen() {
  for (unsigned int i = 0u; i < BASIC_SCREEN_MAX_COL * BASIC_SCREEN_MAX_ROW;
       i++) {
    char* cursor = (char*)(BASIC_SCREEN_VIDEO_MEMORY_BASE +
                           i * BASIC_SCREEN_BYTES_PER_CELL);
    *cursor = ' ';
  }
}

// print at specified row and col
void kprint_at(const char* str, unsigned int row, unsigned int col) {
  unsigned int offset = get_offset_from_row_col(row, col);
  print_at_offset(str, offset);
}

// print at current location
void kprint(const char* str) {
  unsigned int offset = get_current_cursor_offset();
  print_at_offset(str, offset);
}

