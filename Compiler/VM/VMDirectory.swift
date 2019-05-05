//
//  VMDirectory.swift
//  Compiler
//
//  Created by Elie Drai on 04/05/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

class VMDirectory{
    
    var inputDirectoryURL: URL
    var outputFileURL: URL
    var count = 0
    
    init(inputDirPath: URL){
        //  get the input dir path
        inputDirectoryURL = inputDirPath
        
        //  create the output file path
        outputFileURL =
            inputDirPath.appendingPathComponent(
                inputDirPath.lastPathComponent + ".asm"
        )
    }
    
    func translate(){
        
        //  create output file
        let outFile = File.create(filePath: outputFileURL.path)
        
        //  use bootstrap
        outFile.write(sentence: bootstrap())
        
        //  translate all vm files in the directory
        var inFile: File
        let files_list = get_all_files(from: inputDirectoryURL)
        
        for fileName in files_list{
            //  get the file
            let filePath = inputDirectoryURL.path + "/" + fileName
            let fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
            
            //  if the file is of type "vm"
            if fileURL.pathExtension == "vm"{
                //  debug info
                print("Translate the file: \(fileName)")
                
                //  open the inputFile
                inFile = File(filePath: inputDirectoryURL.path + "/\(fileName)")
                outFile.write(sentence: "// ------------------------------------")
                outFile.write(sentence: "// Translate the file: \(fileName)\n")
                //  iterate over each line of the input file to write it to the out file
                let content = inFile.read()
                
                var lines: [String] = []
                content.enumerateLines{ line, _ in lines.append(line)}
                
                for line in lines {
                    
                    //  get the command
                    let command = VMCommand(
                        line: line,
                        file: fileName + ".asm",
                        counter: count)
                    count += 1
                    let translation = command.translate()
                    //  write the translated command into the file
                    outFile.write(sentence: translation)
                }
                outFile.write(sentence: "// ------------------------------------\n")
            }
        }
        
    }
    
    
    
    private func bootstrap() -> String {
        var str = "//   BOOTSTRAP TRANSLATION\n\n"
        
        //  SP = 256
        str += "//  SP = 256\n"
        str += "@256\n"
        str += "D=A\n"
        str += "@SP\n"
        str += "M=D\n"
        
        //  call Sys.init 0
        let command = VMCommand(
            line: "call Sys.init 0",
            file: outputFileURL.lastPathComponent,
            counter: count)
        count+=1
        let translation = command.translate()
        
        str += translation
        return str
    }
    
}
