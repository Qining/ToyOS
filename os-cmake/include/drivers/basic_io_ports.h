#ifndef TOYOS_DRIVERS_BASIC_IO_PORTS_H
#define TOYOS_DRIVERS_BASIC_IO_PORTS_H

/**
 * @brief Get a byte from a given io port.
 *
 * @param port The port.
 *
 * @return The byte returned from the io port.
 */
unsigned char basic_io_ports_get_byte(unsigned short port);

/**
 * @brief Set a byte to a specified io port.
 *
 * @param port The port.
 * @param data The byte value.
 */
void basic_io_ports_set_byte(unsigned short port, unsigned char data);

/**
 * @brief Get a word (two bytes) from a given io port.
 *
 * @param port The port.
 *
 * @return The returned word from the specified port.
 */
unsigned short basic_io_ports_get_word(unsigned short port);

/**
 * @brief Set a word to a specified io port.
 *
 * @param port The port.
 * @param data The word value.
 */
void basic_io_ports_set_word(unsigned short port, unsigned short data);

#endif // TOYOS_DRIVERS_BASIC_IO_PORTS_H
