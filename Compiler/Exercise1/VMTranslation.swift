//
//  VMTranslation.swift
//  Compiler
//
//  Created by Elie Drai on 21/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

// ***** MEMORY TREATMENT *****

func error() -> String {
    return "Error in the script\n"
}

func translate_pop(command: [Substring]) -> String {
    return ""
}

func translate_push(command: [Substring]) -> String {
    
    var str: String = ""
    let number = command[2]
    
    let seg = String(command[1])
    
    switch(seg) {
        
        case Segment.Constant.rawValue:
            str = "@\(number)\n"
            str += "D=A\n"
            str += "@SP\n"
            str += "A=M\n"
            str += "M=D\n"
            str += "@SP\n"
            str += "M=M+1\n"
        
        case Segment.Local.rawValue: break
        
        case Segment.Argument.rawValue: break
        
        case Segment.Static.rawValue: break
        
        case Segment.That.rawValue: break
        
        case Segment.This.rawValue: break
        
        case Segment.Temp.rawValue: break
        
        case Segment.Pointer.rawValue: break
        
        default:
            return error()
    }
    return str
}

// ***** OPERATIONS TREATMENT ***** //

func translate_unary_operation(param: Command) -> String {
    
    var operationVM = ""
    
    switch param {
        case .Neg:
            operationVM += "M=-M"
        
        case .Not:
            operationVM += "M=!M"
        
        default:
            operationVM += ""
    }
    
    var result = ""
    
    result += "@0\n"
    result += "A=M-1\n"
    result += operationVM + "\n"
    result += "D=A+1\n"
    result += "@SP\n"
    result += "M=D\n"
    
    return result
}

func translate_binary_operation(param: Command) -> String {
 
    var operationVM = ""
    
    switch param {
        case .Add:
            operationVM += "D=D+M"
        
        case .Sub:
             operationVM += "D=D-M"
        
        case .And:
            operationVM += "D=D&M"
        
        case .Or:
            operationVM += "D=D|M"
        
        default:
            operationVM += ""
    }
    
    var result = ""
    
    result += "@SP\n"
    result += "A=M-1\n"
    result += "D=M\n"
    result += "A=A-1\n"
    result += operationVM + "\n"
    result += "M=D\n"
    result += "D=A+1\n"
    result += "@SP\n"
    result += "M=D\n"
    
    return result
}

func translate_trinary_operation(param: Command) -> String {
    
    var operationVM = ""
    
    switch param {
        case .Eq:
            operationVM += "D;JEQ"
        
        case .Lt:
            operationVM += "D;JLT"
        
        case .Gt:
            operationVM += "D;JGT"
        
        default:
            operationVM += ""
    }
    
    var result = ""
    
    result += "@SP\n"
    result += "A=M-1\n"
    result += "D=M\n"
    result += "A=A-1\n"
    result += "D=D-M\n"
    // Loading in A Register the target to jump if D = 0 (the condition is met)
    result += "@\(Branching.If_True.rawValue)\n"
    result += operationVM + "\n"
    // Writing in the first comparator register the value 0 (FAILURE)
    result += "@0\n"
    result += "D=A\n"
    result += "@\(Branching.End_Program)\n"
    result += "0;JMP\n"
//    result += "@SP\n"
//    result += "A=M-1\n"
//    result += "A=A-1\n"
//    result += "M=D\n"
//    result += "@\(Branching.If_False.rawValue)\n"
//    result += "0;JMP\n"
    // Declaration of the label IF_TRUE
    result += "(\(Branching.If_True))\n"
    // Writing in the first comparator register the value 1 (SUCCESS)
    result += "@1\n"
    result += "D=A\n"
    result += "(\(Branching.End_Program))\n"
    result += "@SP\n"
    result += "A=M-1\n"
    result += "A=A-1\n"
    result += "M=D\n"
//    result += "(\(Branching.If_False.rawValue))\n"
    result += "@SP\n"
    result += "M=M-1\n"
    
    return result
}


func translate_operation(operation: String) -> String {
    
    switch(operation) {
        
        // Unary operations : Neg, Not
        case Command.Neg.rawValue:
            return translate_unary_operation(param: .Neg)
        
        case Command.Not.rawValue:
            return translate_unary_operation(param: .Not)
        
        
        // Binary operations : Add, Sub, And, Or
        case Command.Add.rawValue:
            return translate_binary_operation(param: .Add)
        
        case Command.Sub.rawValue:
            return translate_binary_operation(param: .Sub)
        
        case Command.And.rawValue:
            return translate_binary_operation(param: .And)
        
        case Command.Or.rawValue:
            return translate_binary_operation(param: .Or)
        
        
        // Trinary Operations : Equal, LowerThan, GreaterThan
        case Command.Eq.rawValue:
            return translate_trinary_operation(param: .Eq)
        
        case Command.Lt.rawValue:
            return translate_trinary_operation(param: .Lt)
        
        case Command.Gt.rawValue:
            return translate_trinary_operation(param: .Gt)
        
        default:
            return error()
        }
}


func translate(command: String) -> String {
    
    var translated_command: String = ""
    
    //  case of commentary
    if (command.starts(with: Command.Commentary.rawValue)) {
//        translated_command = ""
//        *** I wrote return here because in the continuation, the program can analyse the rest of the command and it's not necessary ***
        return translated_command
    }
    
    let list = command.split(separator: " ")
    
    switch(list.count) {
        
        case 0:
            //  NO-OP
            translated_command = ""
        
        case 1:
            //  operation case
            translated_command = translate_operation(operation: command)
        
        case 3:
            //  stack case
            if (list[0].elementsEqual(Command.Push.rawValue)) {
                translated_command = translate_push(command: list)
            }
            
            if (list[1].elementsEqual(Command.Pop.rawValue)) {
                translated_command = translate_pop(command: list)
            }
        
        default:
            //  error in the script
            translated_command = error()
    }
    
    return translated_command
}
