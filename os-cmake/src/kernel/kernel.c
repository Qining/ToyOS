#include "../drivers/basic_io_ports.h"
#include "../drivers/basic_screen.h"

const char MSG_WELCOME[] = "ToyOS: <kernel> Welcome!\n";

void dummy_test_entrypoint() {
  // This is an empty dummy function.
  // Added to force us to create a kernel entry function
  // instead of jumping to kernel.c:0x00(this value is wrong)
  // directly. (?)
}

// BEGIN_PM => KERNEL_ADDR (kernel_entry.nasm) => main
// Note we don't have a large stack.
void main() {
  kclear_screen();
  kprint_at(MSG_WELCOME, 0u,0u);
}
