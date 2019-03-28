//
//  ex1.swift
//  Compiler
//
//  Created by Elie Drai on 04/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation


func ex1_introduction()
{
    print("\n\n")
    print("---------------------")
    print("Welcome to Exercise 1: \nBuilding a VM translator")
    print("---------------------\n\n")
}

func compute_exercise1() {
    
    ex1_introduction()
    
    //print("Please, enter the file name with the .vm extension:")
    let fileName = "StaticTest.vm"
    
    
    let fileURL = URL.init(fileURLWithPath: fileName)
    print("Your input file is: \(fileURL.absoluteString)")
    
    //  translate the file
    VMFile.init(inputFilePath: fileURL).translate()
    
    //  debug info
    print("Translation done...")
    print("Your output file is at \(fileURL.deletingLastPathComponent())")
}
