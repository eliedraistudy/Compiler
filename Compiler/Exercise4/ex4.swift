//
//  ex4.swift
//  Compiler
//
//  Created by Elie Drai on 04/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

func ex4_translate_all_files(directory: URL){
    
    var files_list =
        get_all_files(
            from: directory)
    
    for fileName in files_list{
        //  get the file
        let filePath = directory.path + "/" + fileName
        let fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
        if fileURL.pathExtension == "jack"{
            JACKFile.init(input: fileURL).compile()
            print("\(fileName) tokenized successfully")
        }
    }
}

func ex4_introduction(){
    print("\n\n")
    print("---------------------")
    print("Welcome to Exercise 4")
    print("Compiler I")
    print("---------------------")
}

func compute_exercise4(){
    
    ex4_introduction()
    
    ex4_translate_all_files(
        directory: URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/JACKFiles04") )
    
    print("Compiled successfully")
    
}
