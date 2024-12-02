# Network Attacker

**Network Attacker** is a software tool that allows users to send UDP or TCP packets to a specific target IP address for network testing purposes. The software is designed to perform basic packet sending for network stress testing. However, it is essential to use this tool only for legal and ethical purposes.

## Features

- Supports both UDP and TCP protocols.
- Allows users to specify target IP address and port.
- Can utilize proxy and user agent files.
- Multi-threading support for improved performance.
- Designed for use in legal testing environments.

## Usage

Follow the steps below to use the software:

### Requirements

- Linux operating system (this software is designed to work on Linux systems).
- 32-bit processor assembly code.
- Tools like `netcat` or other network testing utilities may be helpful.

### Compilation and Running

1. **Compiling the Code:**

   This software is written in Assembly. To compile, use the following commands:

   ```bash
   nasm -f elf32 -o network_attacker.o network_attacker.asm
   ld -m elf_i386 -o network_attacker network_attacker.o

## Running the Software:

To run the software:

```./network_attacker```

After running, the software will prompt you for the following information:

Protocol Selection: Choose either UDP or TCP.

Target IP Address: Enter the IP address of the target.

Target Port: Specify the port number for the target.

Number of Threads: Enter the number of threads (1-100).

Proxy File: If you want to use a proxy file, provide its name.

User Agent File: If you want to use a user agent file, provide its name.


## Configuration

Protocol Selection: You can choose between UDP (Option 1) or TCP (Option 2) for packet sending.

Threads: Specify the number of threads to use for sending packets (1-100).

Target IP and Port: Provide the target IP address and port to which the packets will be sent.

Proxy and User Agent Files: Optionally, specify files for proxies and user agents that will be used during the attack.


## Disclaimer

Network Attacker is intended for educational and research purposes only. The software should only be used in a controlled and legal environment. Unauthorized use of this tool for malicious purposes is illegal and unethical. The author is not responsible for any damages caused by the misuse of this tool.
