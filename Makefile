CC = g++
CFLAGS = -Wall -m64 -g
SFMLFLAGS = -lsfml-graphics -lsfml-window -lsfml-system

all: main.o fern.o
	$(CC) $(CFLAGS) -no-pie main.o fern.o $(SFMLFLAGS) -o main

fern.o: fern.s
	nasm -f elf64 -g -o fern.o fern.s

main.o: main.cpp
	$(CC) -c main.cpp -o main.o

clean:
	rm -f *.o
