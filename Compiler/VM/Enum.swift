//
//  Enum.swift
//  Compiler
//
//  Created by Elie Drai on 24/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

enum Segment:
String {
    case Local = "local"
    case Argument = "argument"
    case This = "this"
    case That = "that"
    case Pointer = "pointer"
    case Static = "static"
    case Constant = "constant"
    case Temp = "temp"
}

enum Branching:
String {
    case Label = "label"
    case Goto = "goto"
    case If_Goto = "if-goto"
    case If_True = "IF_TRUE"
    case If_False = "IF_FALSE"
    case End_Program = "END_OF_PROGRAM"
}

enum Function:
String {
    case Function = "function"
    case Call = "call"
    case Return = "return"
}

enum Command:
String {
    case Push = "push"
    case Pop = "pop"
    case Add = "add"
    case Sub = "sub"
    case Neg = "neg"
    case Eq = "eq"
    case Gt = "gt"
    case Lt = "lt"
    case And = "and"
    case Or = "or"
    case Not = "not"
    case Commentary = "//"
}
