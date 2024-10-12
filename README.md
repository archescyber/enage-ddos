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

3. **Running the Program**:
   ```./enage_ddos```

Usage

When the program starts, follow these steps:

1. Protocol Selection: Choose a protocol based on the prompt "Select protocol (1: UDP, 2: TCP): ".


2. Thread Count: Enter a number of threads in response to "Enter number of threads (1-100): ".


3. Target Information: Provide the target IP address and port when prompted.



License

This project is licensed under the MIT License.

Contact

For any issues or suggestions, please contact [your email address here].

### README File Explanations:
- **Description**: Summarizes what the project is and its purpose.
- **Features**: Lists the core features of the software.
- **Installation**: Provides instructions on how to set up the project and compile the code.
- **Usage**: Guides users through the process of running the program.
- **License**: Specifies the licensing information.
- **Contact**: A section for users to reach out with questions or suggestions.
