//
//  VMTranslation.swift
//  Compiler
//
//  Created by Elie Drai on 25/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

func error() -> String{
    return "Error during the translation"
}

func Line(value: String) -> String{
    return value + "\n"
}

class VMCommand{
    
    var command: String
    var fileName: String
    var count: Int
    
    //  CTOR
    init(line: String, file: String, counter: Int){
        command = line
        fileName = String(file.dropLast(4))
        count = counter
    }
    
    
    //  METHODS
    
    func translate() -> String{
        /*
         The purpose of this function is to translate the main command
         */
        
        
        //  case of commentary
        if (command.starts(with: Command.Commentary.rawValue)) {
            //        translated_command = ""
            //        *** I wrote return here because in the continuation, the program can analyse the rest of the command and it's not necessary ***
            return ""
            
        }
        var translated_command: String = "//\(command)\n"
        let list = command.split(separator: " ")
        
        switch(list.count) {
            
        case 0:
            //  NO-OP
            translated_command = ""
            
        case 1:
            //  operation case
            translated_command += translate_operation()
            
        case 3:
            //  stack case
            if(list[0] == "pop"){
                translated_command += translate_pop(command: list)
            }
            else if(list[0] == "push"){
                translated_command += translate_push(command: list)
            }
            //translated_command += translate_stack(command: list)
        
            
        default:
            //  error in the script
            translated_command += error()
        }
        
        return translated_command
    }
    
    
    ///  OPERATIONS REGION
    
    private func translate_operation() -> String{
        switch(command) {
            
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
    
    private func translate_unary_operation(param: Command) -> String {
        /*
         Private function to translate unaries commands
         */
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
        
        result += "@SP\n"
        result += "A=M-1\n"
        result += operationVM + "\n"
//        result += "D=A+1\n"
//        result += "@SP\n"
//        result += "M=D\n"
        
        return result
    }
    
    private func translate_binary_operation(param: Command) -> String {
        /*
         Private function to translate binaries commands
         */

        var operationVM = ""
        
        switch param {
        case .Add:
            operationVM += "D=M+D"
            
        case .Sub:
            operationVM += "D=M-D"
            
        case .And:
            operationVM += "D=M&D"
            
        case .Or:
            operationVM += "D=M|D"
            
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
    
    private func translate_trinary_operation(param: Command) -> String {
        /*
         Private function to translate trinaries operations
         */
        
        var operationVM = ""
        let label1 = "IF_TRUE\(count)"
        let label2 = "IF_FALSE\(count)"
        
        switch param {
        case .Eq:
            operationVM = "D;JEQ"
            
        case .Lt:
            operationVM = "D;JLT"
            
        case .Gt:
            operationVM = "D;JGT"
            
        default:
            operationVM = "ERROR"
        }
        
        var result = ""
        
        result += "@SP\n"
        result += "A=M-1\n"
        result += "D=M\n"
        result += "A=A-1\n"
        
        if(param == .Eq){
            result += "D=D-M\n"
        }
        else{
            result += "D=M-D\n"
        }
        
        // Loading in A Register the target to jump if D = 0 (the condition is met)
        result += "@\(label1)\n"
        result += operationVM + "\n"
        
        result += "D=0\n"
        result += "@SP\n"
        result += "A=M-1\n"
        result += "A=A-1\n"
        result += "M=D\n"
        
        result += "@\(label2)\n"
        result += "0;JMP\n"
        
        result += "(\(label1))\n"
        result += "D=-1\n"
        result += "@SP\n"
        result += "A=M-1\n"
        result += "A=A-1\n"
        result += "M=D\n"

        result += "(\(label2))\n"
        result += "@SP\n"
        result += "M=M-1\n"
        
        return result
    }
    
    /////////////////////////////////////////
    
    //  PUSH and POP REGION
    
    private func translate_stack(command: [Substring]) -> String {
        var str: String = ""
        let arg = command[2]
        var key: String
        var base: Int
        
        let seg = String(command[1])
        
        switch(seg) {
            
        case Segment.Constant.rawValue:
            str = "@\(arg)\n"
            str += "D=A\n"
            
        case Segment.Local.rawValue:
            key = "LCL"
            str+="@\(key)\n"
            str+="D=A\n"
            str+="@\(arg)\n"
            str+="D=D+M\n"
            
        case Segment.Argument.rawValue:
            key = "ARG"
            str+="@\(key)\n"
            str+="D=A\n"
            str+="@\(arg)\n"
            str+="D=D+M\n"
            
        case Segment.Static.rawValue:
            str+="@\(fileName).\(arg)\n"
            
        case Segment.That.rawValue:
            key = "THAT"
            str+="@\(key)\n"
            str+="D=A\n"
            str+="@\(arg)\n"
            str+="D=D+M\n"
            
        case Segment.This.rawValue:
            key = "THIS"
            str+="@\(key)\n"
            str+="D=A\n"
            str+="@\(arg)\n"
            str+="D=D+M\n"
            
        case Segment.Temp.rawValue:
            base = 3
            str+="@\(base)\n"
            str+="D=A\n"
            str+="@\(arg)\n"
            str+="D=D+A\n"
            
        case Segment.Pointer.rawValue:
            base = 5
            str+="@\(base)\n"
            str+="D=A\n"
            str+="@\(arg)\n"
            str+="D=D+A\n"
            
        default:
            return error()
        }
        
        
        switch String(command[0]) {
        case Command.Push.rawValue:
            //  push common code
            str+=push_command()
            
        case Command.Pop.rawValue:
            // pop common code
            str+=pop_command()
            
        default:
            return error()
        }
        
        return str
    }
    
    private func pop_command() -> String {
        var str = ""
        str+="@R13\n"
        str+="M=D\n"
        str+="@SP\n"
        str+="A=M-1\n"
        str+="D=M\n"
        str+="@R13\n"
        str+="A=M\n"
        str+="M=D\n"
        return str
    }
    
    private func push_command() -> String{
        var str = ""
        str+="@SP\n"
        str+="A=M\n"
        str+="M=D\n"
        str+="D=A+1\n"
        str+="@SP\n"
        str+="M=D\n"
        return str
    }
    
    private func pushD() -> String {
        var str = ""
        str += "@SP\n"
        str += "A=M\n"
        str += "M=D\n"
        str += "@SP\n"
        str += "M=M+1\n"
        return str
    }
    
    private func translate_push(command: [Substring]) -> String{
        
        //  command struct:
        //  push [seg] [arg]
        var str: String = ""
        let arg = command[2]
        var key: String
        var base: Int
        let seg = String(command[1])
        
        
        switch(seg){
            
        case Segment.Constant.rawValue:
            //  constant
            str += "@\(arg)\n"
            str += "D=A\n"
            str += pushD()
            return str
            
        case Segment.Temp.rawValue:
            //  temp
            var val = 5
            val += Int(arg)!
            str += "@\(val)\n"
            str += "D=M\n"
            str += pushD()
            return str
            
        case Segment.Local.rawValue:
            //  lcl
            str += "@\(arg)\n"
            str += "D=A\n"
            str += "@LCL\n"
            str += "A=M+D\n"
            str += "D=M\n"
            str += pushD()
            return str
            
        case Segment.This.rawValue:
            //  this
            str += "@\(arg)\n"
            str += "D=A\n"
            str += "@THIS\n"
            str += "A=M+D\n"
            str += "D=M\n"
            str += pushD()
            return str
            
        case Segment.That.rawValue:
            //  that
            str += "@\(arg)\n"
            str += "D=A\n"
            str += "@THAT\n"
            str += "A=M+D\n"
            str += "D=M\n"
            str += pushD()
            return str
            
        case Segment.Argument.rawValue:
            //  arg
            str += "@\(arg)\n"
            str += "D=A\n"
            str += "@ARG\n"
            str += "A=M+D\n"
            str += "D=M\n"
            str += pushD()
            return str
            
        case Segment.Static.rawValue:
            //  static to do
            str = "@\(fileName).\(arg)\n"
            /*
            //  python
            str += "D=M\n"
            str += "@SP\n"
            str += "A=M\n"
            str += "M=D\n"
            str += "D=A+1\n"
            str += "@SP\n"
            str += "M=D\n"
            */
            
            //  raph
            str += "@\(fileName).\(arg)\n"
            str += "D=M\n"
            str += pushD()
 
            return str
            
        case Segment.Pointer.rawValue:
            //  pointer
            let c = Int(arg)!
            if(c==0){
                str += "@THIS\n"
            }
            else if(c==1){
                str += "@THAT\n"
            }
            str += "D=M\n"
            str += pushD()
            return str
            
        default:
            return error()
        }
    }
    
    private func translate_pop(command: [Substring]) -> String{
        var str = ""
        let arg = command[2]
        var key: String
        var base: Int
        let seg = String(command[1])
        
        //  popD
        str += "@SP\n"
        str += "A=M-1\n"
        str += "D=M\n"
        
        switch(seg){
        case Segment.Temp.rawValue:
            //  case temp
            var val = 5
            val += Int(arg)!
            str += "@\(val)\n"
            str += "M=D\n"
            str += "@SP\n"
            str += "M=M-1\n"
            return str
            
            
        case Segment.Local.rawValue:
            // case local
            str += "@LCL\n"
            str += "A=M\n"
            let val = Int(arg)!
            if(val>=1){
                for _ in 1...val{
                    str += "A=A+1\n"
                }
            }
            
            str += "M=D\n"
            str += "@SP\n"
            str += "M=M-1\n"
            return str
            
        case Segment.This.rawValue:
            //  case this
            str += "@THIS\n"
            str += "A=M\n"
            let val = Int(arg)!
            if(val>=1){
                for _ in 1...val{
                    str += "A=A+1\n"
                }
            }
            str += "M=D\n"
            str += "@SP\n"
            str += "M=M-1\n"
            return str
            
        case Segment.That.rawValue:
            //  case that
            str += "@THAT\n"
            str += "A=M\n"
            let val = Int(arg)!
            if(val>=1){
                for _ in 1...val{
                    str += "A=A+1\n"
                }
            }
            str += "M=D\n"
            str += "@SP\n"
            str += "M=M-1\n"
            return str
            
        case Segment.Argument.rawValue:
            //  case argument
            str += "@ARG\n"
            str += "A=M\n"
            let val = Int(arg)!
            if(val>=1){
                for _ in 1...val{
                    str += "A=A+1\n"
                }
            }
            str += "M=D\n"
            str += "@SP\n"
            str += "M=M-1\n"
            return str
            
        case Segment.Static.rawValue:
            //  case static
            str = "@\(fileName).\(arg)\n"
            /*
            //  python
            str += "D=M\n"
            str += "@R13\n"
            str += "M=D\n"
            str += "@SP\n"
            str += "A=M-1\n"
            str += "D=M\n"
            str += "@R13\n"
            str += "A=M\n"
            str += "M=D\n"
            */
            //  raph
            str += popD()
            str += "@\(fileName).\(arg)\n"
            str += "M=D\n"
            str += "@SP\n"
            str += "M=M-1\n"
            
            
            return str
            
        case Segment.Pointer.rawValue:
            //  case pointer
            let val = Int(arg)!
            if(val == 0){
                str += "@THIS\n"
            }
            else if(val == 1){
                str += "@THAT\n"
            }
            str += "M=D\n"
            str += "@SP\n"
            str += "M=M-1\n"
            
        default:
            return error()
        }
        
        
        return str
    }
    
    private func popD() -> String {
        var str = ""
        str += "@SP\n"
        str += "A=M-1\n"
        str += "D=M\n"
        return str
    }
    
    /////////////////////////////////////////
    
    
}
