



//


//push constant 111
@111
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//push constant 333
@333
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//push constant 888
@888
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//pop static 8
@StaticTest.8
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//pop static 3
@StaticTest.3
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//pop static 1
@StaticTest.1
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//push static 3
@StaticTest.3
@SP
A=M
M=D
D=A+1
@SP
M=D

//push static 1
@StaticTest.1
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

//push static 8
@StaticTest.8
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

