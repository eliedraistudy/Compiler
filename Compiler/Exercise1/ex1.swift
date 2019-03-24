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
    print("Welcome to Exercise 1: Building a VM translator")
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






func compute_exercise1(){
    
    ex1_introduction()
}
