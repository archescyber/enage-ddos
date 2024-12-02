# Network Attacker 

# Assembly Code Compatibility

The compatibility of assembly code depends on the architecture it was written for. If my code is written for the x86 architecture, it can run on Intel and AMD processors. If it is written for the ARM architecture, it will work on ARM-based devices.

In summary, to determine which processor architecture my code is compatible with, you should consider the compiler used or the writing style. If my code is x86-based, it is compatible with the x86 architecture; if it is ARM-based, it is compatible with the ARM architecture.

## Features

- **Protocol Selection**: Users can choose between UDP or TCP protocols.
- **Thread Control**: Users can specify the number of threads from 1 to 100.
- **Target IP and Port**: Users can input the target IP address and port number.
- **Proxy Support**: Users can specify a proxy file.
- **User Agent Support**: Users can specify a user agent file.

## Installation

1. **Required Tools**:
   ```You need to have the following tools installed on your system to run this project:
   - NASM (Netwide Assembler)
   - ld (GNU Linker)
3. **Compiling the Code**:
   ```bash
   nasm -f elf32 -o enage_ddos.o enage_ddos.asm
   ld -m elf_i386 -s -o enage_ddos enage_ddos.o

4. **Running the Program**:
   ```./enage_ddos```

## Usage

When the program starts, follow these steps:

`1. Protocol Selection: Choose a protocol based on the prompt "Select protocol (1: UDP, 2: TCP): ".`


`2. Thread Count: Enter a number of threads in response to "Enter number of threads (1-100): ".`


`3. Target Information: Provide the target IP address and port when prompted.`


# Contact

Feel free to contribute to the project by submitting issues or pull requests. All contributions are welcome!   
