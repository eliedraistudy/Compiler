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
