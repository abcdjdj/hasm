# HASM

### Introduction
A simple two-pass assembler for the HACK CPU's assembly language, written in Flex/Bison (Project 6 of [Nand2Tetris](https://www.nand2tetris.org/)).
Supports predefined symbols (KBD, R0-R15 etc.), labels and variables as well. 
Know more about the HACK assembly language [here](https://docs.wixstatic.com/ugd/44046b_89a8e226476741a3b7c5204575b8a0b2.pdf)

### Prerequisites

You need to have make, flex and bison installed on your machine. In case you don't, run the following command to install them.

###### Ubuntu
```
sudo apt install flex bison build-essential
```

###### Arch
```
sudo pacman -S base-devel
```

### Building

Run the following commands to clone and build HASM
```
git clone https://github.com/abcdjdj/hasm
cd hasm
make
```

### Usage
```
./hasm.out <asm file>
```
By default, the generated binary code will get printed to stdout
