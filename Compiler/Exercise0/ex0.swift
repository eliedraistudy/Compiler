//
//  ex0.swift
//  Compiler
//
//  Created by Elie Drai on 04/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation




func get_all_files(from dirURL: URL) -> [String]{
    /*
     Function to get all the files from a directory in a list of string
     */
    
    let file_manager = FileManager.default
    do{
        var files_list = try file_manager.contentsOfDirectory(atPath: dirURL.path)
        files_list.sort()
        return files_list
    }
    catch{
        print("Error finding the directory.")
        return []
    }
}


func compute_exercise0(){
    /*
     Main function to compute exercise0
     */
    
    //  INTRODUCTION
    let exercise = Exercise(number: 0)
    exercise.introduction()
    
    //  GET ALL FILES IN A [String]
    let directory =
        URL(fileURLWithPath: "/Users/cyberoot/desktop/compiler/swift_file_management_lab", isDirectory: true)
    let files_list = get_all_files(from: directory)
    
    var count = 0
    
    //  ITERATE OVER EACH FILE
    for fileName in  files_list{
        //  get the file
        let filePath = directory.path + "/" + fileName
        let fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
        
        //  if the file is of type "vm"
        if fileURL.pathExtension == "vm"{
            count = count+1
            let file = File(filePath: fileURL.path)
            //  Write counter at the end of the file
            file.write(sentence: "Count: \(count)")
            
            //  if the file is "hello.vm"
            if fileURL.lastPathComponent == "hello.vm"{
                let content = file.read()
                var lines: [String] = []
                content.enumerateLines{ line, _ in lines.append(line)}
                
                //  create a file "hello.asm"
                let asm = File.create(filePath: directory.path + "/hello.asm")
                print("\nLine containing 'you':")
                for line in lines{
                    asm.write(sentence: line)
                    
                    if line.contains("you"){
                        print(line)
                    }
                }
                
            }
        }
        
    }
}

