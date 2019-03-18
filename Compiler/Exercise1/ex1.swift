//
//  ex1.swift
//  Compiler
//
//  Created by Elie Drai on 04/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation


func ex1_introduction(){
    print("\n\n")
    print("---------------------")
    print("Welcome to Exercise 1")
    print("---------------------")
}

func push(command_list: [Substring]) -> String{
    /*
     Function to translate push command
     */
    var operation = ""
    
    switch(command_list[1]){
        
    case "constant":
        //  the constant case
        operation = "@\(command_list[2])\n"
        operation+="D=A\n"
        operation+="@SP\n"
        operation+="A=M\n"
        operation+="M=D\n"
        operation+="@SP\n"
        operation+="M=M+1\n"
        
    default:
        //  default case
        return ""
    }
    
    return operation
}


func translate(command: String)->String{
    /*
     Function to translate every kind of command from vm to hack
     */
    let command_list = command.split(separator: " ")
    
    if command_list[0] == "//"{
        return ""
    }
    
    switch(command_list[0]){
        
    case "//":
        //  commentary case
        return ""
        
    case "push":
        //  push case
        return push(command_list: command_list)
        
    case "pop":
        //  pop case
        return ""
        
    default:
        //  default case
        return ""
        
    }
}





func translate_push(command: String) -> String{
    var str: String = ""
    
    let str_command = command.split(separator: " ")
    
    //  simple 'push constant number'
    if(str_command[1] == "constant"){
        let number = str_command[2]
        
        str = "@\(number)\n"
        str+="D=A\n"
        str+="@SP\n"
        str+="A=M\n"
        str+="M=D\n"
        str+="@SP\n"
        str+="M=M+1\n"
    }
    
    return str
}

func compute_exercise1(){
    
    ex1_introduction()
}
