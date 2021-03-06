
cpu "8085.tbl"
hof "int8"

org 9000h

JMP START

DIV16:
MVI A, 00H
STA 9200H
STA 9201H
STA 9202H
STA 9203H
MVI B,00H
CALL 030EH
PUSH D
CALL 030EH
POP H
LOP2:
MOV A,L
SUB E
MOV L,A
MOV A,H
SBB D
MOV H,A
JC LOOP3
INX B
JMP LOP2
LOOP3:DAD D
SHLD 9202H
MOV A, B
SUI 1CH
MOV B, A
DCR C
MOV L,C
MOV H,B
SHLD 9200H
RET


MULT16:
MVI B,00H
CALL 030EH
PUSH D
CALL 030EH
MVI A, 00H
STA 9200H
STA 9201H
STA 9202H
STA 9203H
POP B

LOOP:
MOV A,B
CPI 00H
JNZ MAINLOOP
MOV A,C
CPI 00h
JZ RESULT
MAINLOOP:
DCX B
LHLD 9200H
DAD D
SHLD 9200H
JNC P1
LHLD 9202H
INX H
SHLD 9202H
P1:
JMP LOOP

RESULT:
RET

ADD8:
MVI B ,01H
CALL 030EH
LXI H ,9300H
MOV M,E
CALL 030EH
MOV A,E
LXI h, 9300H
MOV E, M
ADD E
STA 9200H

JNC CARRY0
LXI H ,9201H
MVI M,01H
JMP THERE1
CARRY0:NOP
LXI H ,9201H
MVI M,00H
THERE1:NOP
MVI A,01H
RET

MULT8:
MVI B ,01H
CALL 030EH
LXI H ,9300H
MOV M,E
CALL 030EH
MOV A,E
LXI H, 9300H
MOV E, M
MVI D, 00H
LXI H, 0000H
LOOP1:NOP
DAD D
DCR A
JNZ LOOP1
SHLD 9200H

MVI A,05H
RET


ADD16:
MVI B ,00H
CALL 030EH
PUSH D
CALL 030EH
POP H
DAD D
PUSH H
LXI H ,9200H
POP D
MOV M,E
LXI H ,9201H
MOV M,D
MVI A,02H
JNC CARRY1
LXI H ,9202H
MVI M,01H
JMP THERE
CARRY1:NOP
LXI H ,9202H
MVI M,00H
THERE:NOP
RET

SUB8:
MVI B ,01H
CALL 030EH
LXI H ,9300H
MOV M,E
CALL 030EH
MOV A,E
LXI h, 9300H
MOV E, M
SUB E
STA 9200H
MVI A,03H
RET

SUB16:
MVI B ,00H
CALL 030EH
PUSH D
CALL 030EH
POP H
MOV A,E
SUB L
MOV E,A
JPE M1
ADD H
MOV H,A
MOV A,D
SUB H
MOV D,A
JMP E1
M1:NOP
MOV A,D
SUB H
MOV D,A
E1:NOP
LXI H,9200H
MOV M,D
LXI H,9201H
MOV M,E
MVI A,04H
RET

MOD16:
MVI A, 00H
STA 9200H
STA 9201H
STA 9202H
STA 9203H
MVI B,00H
CALL 030EH
PUSH D
CALL 030EH
POP H
LOP222:
MOV A,L
SUB E
MOV L,A
MOV A,H
SBB D
MOV H,A
JC LOOP322
CPI 00H
JNZ TEMP1122
MOV A, L
CPI 00H
JZ LOP422
TEMP1122:
INX B
JMP LOP222
LOOP322:DAD D
LOP422:
SHLD 9200H
RET

SELECT:NOP
CPI 01H
JZ ADD8
CPI 02H
JZ ADD16
CPI 03H
JZ SUB8
CPI 04H
JZ SUB16
CPI 05H
JZ MULT8
CPI 06H
JZ MULT16
CPI 07H
JZ DIV16
CPI 08H
JZ MOD16

RET

START:NOP
MVI B ,01H
CALL 030EH
MOV A,E
CALL SELECT
RST 5
