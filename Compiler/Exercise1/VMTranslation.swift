//
//  VMTranslation.swift
//  Compiler
//
//  Created by Elie Drai on 21/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation



func error() -> String{
    return "Error in the script\n"
}

func translate_pop(command: [Substring]) -> String{
    return ""
}

func translate_push(command: [Substring]) -> String{
    
    var str: String = ""
    let number = command[2]
    
    let seg = String(command[1])
    
    switch(seg){
        
    case Segment.Constant.rawValue:
        str = "@\(number)\n"
        str+="D=A\n"
        str+="@SP\n"
        str+="A=M\n"
        str+="M=D\n"
        str+="@SP\n"
        str+="M=M+1\n"
        
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


func translate_binary_operation(param: Command) -> String{
    
    return ""
}

func translate_unary_operation(param: Command) -> String{
    
    return ""
}

func translate_operation(operation: String) -> String{
    
    switch(operation){
        
    case Command.Add.rawValue:
        return translate_binary_operation(param: .Add)
        
    case Command.Sub.rawValue:
        return translate_binary_operation(param: .Sub)
        
    case Command.And.rawValue:
        return translate_binary_operation(param: .And)
        
    case Command.Or.rawValue:
        return translate_binary_operation(param: .Or)
        
    case Command.Eq.rawValue:
        return translate_binary_operation(param: .Eq)
        
    case Command.Lt.rawValue:
        return translate_binary_operation(param: .Lt)
        
    case Command.Gt.rawValue:
        return translate_binary_operation(param: .Gt)
        
    case Command.Neg.rawValue:
        return translate_unary_operation(param: .Neg)
        
    case Command.Not.rawValue:
        return translate_unary_operation(param: .Not)
        
    default:
        return "Error in the script"
    }
}

func translate(command: String) -> String{
    
    var translated_command: String = ""
    
    
    //  case of commentary
    if(command.starts(with: Command.Commentary.rawValue)){
        translated_command = ""
    }
    
    let list = command.split(separator: " ")
    
    switch(list.count){
        
    case 0:
        //  NO-OP
        translated_command = ""
        
    case 1:
        //  operation case
        translated_command = translate_operation(operation: command)
    
    case 3:
        //  stack case
        if(list[0].elementsEqual(Command.Push.rawValue)){
            translated_command = translate_push(command: list)
        }
        
        if(list[1].elementsEqual(Command.Pop.rawValue)){
            translated_command = translate_pop(command: list)
        }
    
        
    default:
        //  error in the script
        translated_command = error()
    }
    
    return translated_command
}
