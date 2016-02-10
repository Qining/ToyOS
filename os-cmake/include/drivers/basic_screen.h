#ifndef TOYOS_DRIVERS_BASIC_SCREEN_H
#define TOYOS_DRIVERS_BASIC_SCREEN_H

// basic terminal video base address
#define BASIC_SCREEN_VIDEO_MEMORY_BASE 0xb8000

// basic terminal height and width
#define BASIC_SCREEN_MAX_ROW 25u
#define BASIC_SCREEN_MAX_COL 80u

// basic terminal color
typedef enum {
  BASIC_SCREEN_WHITE_ON_BLACK = 0x0f,
  BASIC_SCREEN_RED_ON_BLACK = 0xf4,
} BASIC_SCREEN_TERM_COLOR;

// basic terminal io ports
#define BASIC_SCREEN_CTRL 0x3d4
#define BASIC_SCREEN_DATA 0x3d5

// bytes per position in basic terminal screen
#define BASIC_SCREEN_BYTES_PER_CELL 2u

// function to interact with basic terminal
void kclear_screen();
void kprint_at(const char* str, unsigned int row, unsigned int col);
void kprint(const char* str);

#endif // TOYOS_DRIVERS_BASIC_SCREEN_H
