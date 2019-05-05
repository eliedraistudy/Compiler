//
//  ex2.swift
//  Compiler
//
//  Created by Elie Drai on 04/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

func ex2_translate_all_files(directory: URL){
    //  function to translate all files in the debug directory
    
    var files_list =
        get_all_files(
            from: directory)
    
    var k = 1
    
    print("All directories: ")
    for fileName in files_list{
        print("\(k)) " + fileName)
        k += 1
    }
    print("Please, select a directory to translate:")

    let choice: Int = Int(readLine()!)!
    k = 1
    var selected_dir = ""
    for fileName in files_list{
        if(k == choice){
            selected_dir = fileName
        }
        k = k+1
    }
    
    let new_directory = directory.appendingPathComponent(selected_dir, isDirectory: true)
    
    files_list = get_all_files(from: new_directory)
    
    //  handle bootstrapping
    //  count the number of vm files
    var counterVM = 0
    
    //  ITERATE OVER EACH FILE
    for fileName in files_list{
        //  get the file
        let filePath = new_directory.path + "/" + fileName
        let fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
        if fileURL.pathExtension == "vm"{
            counterVM = counterVM + 1
        }
    }
    
    //  need to bootstrapping
    if counterVM > 1{
        VMDirectory.init(inputDirPath: new_directory).translate()
    }
    else{
        for fileName in files_list{
            //  get the file
            let filePath = new_directory.path + "/" + fileName
            let fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
            if fileURL.pathExtension == "vm"{
                VMFile.init(inputFilePath: fileURL).translate()
            }
        }
        
    }
}

func ex2_introduction(){
    print("\n\n")
    print("---------------------")
    print("Welcome to Exercise 1:")
    print("Building a VM translator 2/2")
    print("---------------------\n\n")
}

func compute_exercise2(){
    
    ex2_introduction()
    
    ex2_translate_all_files(
        directory: URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/VMFiles02"))
    
    //  debug info
    print("Translation done...")
}

