



//


//push constant 10
@10
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//pop local 0
@LCL
D=A
@0
D=D+M
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//push constant 21
@21
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//push constant 22
@22
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//pop argument 2
@ARG
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

//pop argument 1
@ARG
D=A
@1
D=D+M
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//push constant 36
@36
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//pop this 6
@THIS
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

//push constant 42
@42
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//push constant 45
@45
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//pop that 5
@THAT
D=A
@5
D=D+M
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//pop that 2
@THAT
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

//push constant 510
@510
D=A
@SP
A=M
M=D
D=A+1
@SP
M=D

//pop temp 6
@3
D=A
@6
D=D+A
@R13
M=D
@SP
A=M-1
D=M
@R13
A=M
M=D

//push local 0
@LCL
D=A
@0
D=D+M
@SP
A=M
M=D
D=A+1
@SP
M=D

//push that 5
@THAT
D=A
@5
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

//push argument 1
@ARG
D=A
@1
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

//push this 6
@THIS
D=A
@6
D=D+M
@SP
A=M
M=D
D=A+1
@SP
M=D

//push this 6
@THIS
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

//push temp 6
@3
D=A
@6
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
