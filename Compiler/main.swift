//
//  main.swift
//  Compiler
//
//  Created by Elie Drai on 03/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

func introduction() {
    print("===============================")
    print("Welcome to the compiler project")
    print("===============================")
    
    print("\n--------------------------------------------")
    print("Course: Fundamentals of programming language")
    print("Lecturer: Ariel Shtulman")
    print("Student: Elie Drai")
    print("ID: 120076030")
    print("--------------------------------------------\n\n")
}


func choice() -> String? {
    print("Please input a choice of exercise")
    print("0) Exercise 0")
    print("1) Exercise 1")
    print("2) Exercise 2")
    print("3) Exercise 3")
    print("4) Exercise 4")
    print("5) Exercise 5")
    
    print("\nYour choice: ")
    let response = readLine()
    
    
    return response
    
}

func compute(choice: String?){
    switch(choice){
    case "0":
        compute_exercise0()
        
    case "1":
        //compute_exercise1()
        compute_exercise1()
        
    case "2":
        //compute_exercise2()
        print("Sorry, not already built")
        
    case "3":
        //compute_exercise3()
        print("Sorry, not already built")
        
    case "4":
        //compute_exercise4()
        print("Sorry, not already built")
        
    case "5":
        //compute_exercise5()
        print("Sorry, not already built")
        
    default:
        print("Error in your input, please try another key")
    }
}

func main(){
    introduction()
    compute(choice: choice())
    print("\n\n\n")
}

main()
