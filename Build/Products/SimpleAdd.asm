//// This file is part of the materials accompanying the book 
//// "The Elements of Computing Systems" by Nisan and Schocken, 
//// MIT Press. Book site: www.idc.ac.il/tecs
//// File name: projects/07/StackArithmetic/SimpleAdd/SimpleAdd.vm

//// Pushes and adds two constants.
@7
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

@8
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

@SP
A=M-1
D=M
A=A-1
D=D+M
M=D
D=A+1
@SP
M=D

