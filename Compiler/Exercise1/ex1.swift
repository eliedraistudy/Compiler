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
    print("Welcome to Exercise 1:")
    print("Building a VM translator 1/2")
    print("---------------------\n\n")
}

func compute_exercise1() {
    
    ex1_introduction()
    
    translate_all_files(
        directory: URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/VMFiles01"))
    
    //  debug info
    print("Translation done...")
}
