



//



//push constant 3030
@3030
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//pop pointer 0
@5
D=A
@0
D=D+A
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//push constant 3040
@3040
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//pop pointer 1
@5
D=A
@1
D=D+A
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//push constant 32
@32
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//pop this 2
@THIS
D=A
@2
D=D+M
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//push constant 46
@46
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//pop that 6
@THAT
D=A
@6
D=D+M
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//push pointer 0
@5
D=A
@0
D=D+A
@SP
A=M
M=D
D=A+1
@SP
M=D

//push pointer 1
@5
D=A
@1
D=D+A
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

//push this 2
@THIS
D=A
@2
D=D+M
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

//push that 6
@THAT
D=A
@6
D=D+M
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

