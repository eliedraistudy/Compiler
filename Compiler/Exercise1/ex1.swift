//
//  ex1.swift
//  Compiler
//
//  Created by Elie Drai on 04/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

func translate_all_files(directory: URL){
    //  function to translate all files in the debug directory
    
    let files_list =
        get_all_files(
            from: directory)
    
    //  ITERATE OVER EACH FILE
    for fileName in  files_list{
        //  get the file
        let filePath = directory.path + "/" + fileName
        let fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
        
        //  if the file is of type "vm"
        if fileURL.pathExtension == "vm"{
            //  debug info
            print("Translate the file: \(fileName)")
            VMFile.init(inputFilePath: fileURL).translate()
        }
    }
}


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
