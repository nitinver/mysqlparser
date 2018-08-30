#!/bin/bash 

./lemon select2.y


g++ -c -std=c++14 -ggdb select2.c 
g++ -c -std=c++14 -ggdb select_lex.cpp
g++ -std=c++14 -ggdb select2.o select_lex.o -o select
