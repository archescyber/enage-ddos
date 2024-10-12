# Enage Network DDoS

## Description

Enage Network DDoS is a simulation software that allows users to perform DDoS attacks on target IP addresses using various protocols (UDP and TCP). This software enables users to launch attacks with the number of threads they specify according to their chosen protocol.

## Features

- **Protocol Selection**: Users can choose between UDP or TCP protocols.
- **Thread Control**: Users can specify the number of threads from 1 to 100.
- **Target IP and Port**: Users can input the target IP address and port number.
- **Proxy Support**: Users can specify a proxy file.
- **User Agent Support**: Users can specify a user agent file.

## Installation

1. **Required Tools**: You need to have the following tools installed on your system to run this project:
   - NASM (Netwide Assembler)
   - ld (GNU Linker)

2. **Compiling the Code**:
   ```bash
   nasm -f elf32 -o enage_ddos.o enage_ddos.asm
   ld -m elf_i386 -s -o enage_ddos enage_ddos.o
