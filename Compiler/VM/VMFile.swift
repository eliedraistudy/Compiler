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
        let inFile = File(filePath: inputFileURL.absoluteString)
        
        //  create the outFile
        let outFile = File.create(filePath: outputFileURL.absoluteString)
        
        //  iterate over each line of the input file to write it to the out file
        let content = inFile.read()
        var lines: [String] = []
        content.enumerateLines{ line, _ in lines.append(line)}
        
        for line in lines {
            //  get the command
            let command = VMCommand(line: line)
            //  write the translated command into the file
            outFile.write(sentence: command.translate())
        }
    }
}
