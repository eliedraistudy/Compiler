



//



//push constant 17
@17
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//push constant 17
@17
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//eq
@SP
A=M-1
D=M
A=A-1
D=D-M
@IF_TRUE
D;JEQ
@0
D=A
@End_Program
0;JMP
(If_True)
@1
D=A
(End_Program)
@SP
A=M-1
A=A-1
M=D
@SP
M=M-1

//push constant 892
@892
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//push constant 891
@891
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//lt
@SP
A=M-1
D=M
A=A-1
D=D-M
@IF_TRUE
D;JLT
@0
D=A
@End_Program
0;JMP
(If_True)
@1
D=A
(End_Program)
@SP
A=M-1
A=A-1
M=D
@SP
M=M-1

//push constant 32767
@32767
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//push constant 32766
@32766
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//gt
@SP
A=M-1
D=M
A=A-1
D=D-M
@IF_TRUE
D;JGT
@0
D=A
@End_Program
0;JMP
(If_True)
@1
D=A
(End_Program)
@SP
A=M-1
A=A-1
M=D
@SP
M=M-1

//push constant 56
@56
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//push constant 31
@31
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//push constant 53
@53
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//add
@SP
A=M-1
D=M
A=A-1
D=D+M
M=D
D=A+1
@SP
M=D

//push constant 112
@112
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//sub
@SP
A=M-1
D=M
A=A-1
D=D-M
M=D
D=A+1
@SP
M=D

//neg
@0
A=M-1
M=-M
D=A+1
@SP
M=D

//and
@SP
A=M-1
D=M
A=A-1
D=D&M
M=D
D=A+1
@SP
M=D

//push constant 82
@82
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//or
@SP
A=M-1
D=M
A=A-1
D=D|M
M=D
D=A+1
@SP
M=D

//

