//
//  VMTranslation.swift
//  Compiler
//
//  Created by Elie Drai on 21/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

enum Segment:
String{
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
String{
    case Label = "label"
    case Goto = "goto"
    case If_Goto = "if-goto"
}

enum Function:
String{
    case Function = "function"
    case Call = "call"
    case Return = "return"
}

enum Command:
String{
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
}

func remove_commentaries(command: [String]) -> [String]{
    var new_command = command
    
    var comment: Int? = nil
    for word in command{
        if(word.starts(with: "//")){
            comment = command.firstIndex(of: word)
        }
    }
    if(comment != nil){
        
    }
    return new_command
}


func translate(line: String){
    //  define the command
    var command: [String] = [String]line.split(separator: " ")
    
    //  suppress commentary
    command = remove_commentaries(command: command)
    
}
