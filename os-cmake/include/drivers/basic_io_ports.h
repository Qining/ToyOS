#ifndef TOYOS_DRIVERS_BASIC_IO_PORTS_H
#define TOYOS_DRIVERS_BASIC_IO_PORTS_H

unsigned char basic_io_ports_get_byte(unsigned short port);
void basic_io_ports_set_byte(unsigned short port, unsigned char data);
unsigned short basic_io_ports_get_word(unsigned short port);
void basic_io_ports_set_word(unsigned short port, unsigned short data);

#endif // TOYOS_DRIVERS_BASIC_IO_PORTS_H
