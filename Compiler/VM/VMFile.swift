//
//  VMFile.swift
//  Compiler
//
//  Created by Elie Drai on 25/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation


class VMFile{
    
    var inputFileURL: URL
    var outputFileURL: URL
    
    init(inputFilePath: URL){
        //  get the input file path
        inputFileURL = inputFilePath
        
        //  create the output file path
        outputFileURL = inputFilePath
        outputFileURL.deletePathExtension()
        outputFileURL.appendPathExtension("asm")
    }
    
    func translate(){
        //  open the inputFile
        let inFile = File(filePath: inputFileURL.path)
        
        //  create the outFile
        let outFile = File.create(filePath: outputFileURL.path)
        
        //  iterate over each line of the input file to write it to the out file
        let content = inFile.read()
        var lines: [String] = []
        content.enumerateLines{ line, _ in lines.append(line)}
        
        var count = 0
        for line in lines {
            
            //  get the command
            let command = VMCommand(
                line: line,
                file: outputFileURL.lastPathComponent,
                counter: count)
            count += 1
            let translation = command.translate()
            //  write the translated command into the file
            outFile.write(sentence: translation)
        }
    }
}

func translate_all_files(directory: URL){
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
    
    //  ITERATE OVER EACH FILE
    for fileName in files_list{
        //  get the file
        let filePath = new_directory.path + "/" + fileName
        let fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
        
        //  if the file is of type "vm"
        if fileURL.pathExtension == "vm"{
            //  debug info
            print("Translate the file: \(fileName)")
            VMFile.init(inputFilePath: fileURL).translate()
        }
    }
}
