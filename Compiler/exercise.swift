//
//  exercise.swift
//  Compiler
//
//  Created by Elie Drai on 04/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

class Exercise{
    /*
     A class to help computing standard operations for exercises
     */
    var number: Int
    
    init(number: Int){
        self.number = number
    }
    
    func introduction(){
        print("\n\n")
        print("---------------------")
        print("Welcome to Exercise \(number)")
        print("---------------------")
    }
}
