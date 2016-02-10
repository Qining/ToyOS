#include "drivers/basic_screen.h"
#include "drivers/basic_io_ports.h"



/**
 * @name Private functions
 * @{ */

/**
 * @brief Get memory offset from column and row number.
 *
 * @param row
 * @param col
 *
 * @return The memory offset which can be used with video memory base address to
 * get the complete address for the cell specified by row and col number.
 */
unsigned int get_offset_from_row_col(unsigned int row, unsigned int col) {
  return BASIC_SCREEN_BYTES_PER_CELL *
         (((row + col / BASIC_SCREEN_MAX_COL) % BASIC_SCREEN_MAX_ROW) *
              BASIC_SCREEN_MAX_COL +
          col % BASIC_SCREEN_MAX_COL);
}

/**
 * @brief Get row number from a given memory offset.
 *
 * @param offset
 *
 * @return The row number.
 */
unsigned int get_row_from_offset(unsigned int offset) {
  return offset / BASIC_SCREEN_BYTES_PER_CELL / BASIC_SCREEN_MAX_COL;
}

/**
 * @brief Get col number from a given memory offset.
 *
 * @param offset
 *
 * @return The column number.
 */
unsigned int get_col_from_offset(unsigned int offset) {
  return (offset / BASIC_SCREEN_BYTES_PER_CELL) % BASIC_SCREEN_MAX_COL;
}

/**
 * @brief Get the memory offset of the current cursor position.
 *
 * @return The memory offset.
 */
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

/**
 * @brief Set the cursor to point to a specified memory position.
 *
 * @param offset The specified memory offset.
 */
void set_cursor_offset(unsigned int offset) {
  offset /= BASIC_SCREEN_BYTES_PER_CELL;
  basic_io_ports_set_byte(BASIC_SCREEN_CTRL, 14);
  basic_io_ports_set_byte(BASIC_SCREEN_DATA, (unsigned char)(offset >> 8));
  basic_io_ports_set_byte(BASIC_SCREEN_CTRL, 15);
  basic_io_ports_set_byte(BASIC_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

/**
 * @brief Set the contents of video memory starting at specified offset. This
 * will print the corresponding string with "white on black" color.
 *
 * @param str Null-terminated string.
 * @param offset The video memory offset.
 */
void print_at_offset(const char* str, unsigned int offset) {
  while (*str != '\0') {
    char* cursor = (char*)(BASIC_SCREEN_VIDEO_MEMORY_BASE + offset);
    *cursor = *str;
    *(cursor + 1u) = BASIC_SCREEN_WHITE_ON_BLACK;
    offset += BASIC_SCREEN_BYTES_PER_CELL;
    str += 1;
  }
}
/**  @} */


/**
 * @name Public functions.
 * @{ */

/**
 * @brief Clear the screen.
 */
void kclear_screen() {
  for (unsigned int i = 0u; i < BASIC_SCREEN_MAX_COL * BASIC_SCREEN_MAX_ROW;
       i++) {
    char* cursor = (char*)(BASIC_SCREEN_VIDEO_MEMORY_BASE +
                           i * BASIC_SCREEN_BYTES_PER_CELL);
    *cursor = ' ';
  }
}

/**
 * @brief Print null-terminated string at specified position.
 *
 * @param str The null-terminated string.
 * @param row The row number.
 * @param col The column number.
 */
void kprint_at(const char* str, unsigned int row, unsigned int col) {
  unsigned int offset = get_offset_from_row_col(row, col);
  print_at_offset(str, offset);
}

/**
 * @brief Print null-terminated string at current cursor position.
 *
 * @param str The null-terminated string.
 */
void kprint(const char* str) {
  unsigned int offset = get_current_cursor_offset();
  print_at_offset(str, offset);
}
/**  @} */
