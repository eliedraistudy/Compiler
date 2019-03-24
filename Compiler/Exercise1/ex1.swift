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
    print("Welcome to Exercise 1: Building a VM translator")
    print("---------------------\n\n")
}


func translate_file(path: URL) {
    
    let inFile = File(filePath: path.path)
    
    var outFileURL = path
    outFileURL.deletePathExtension()
    outFileURL.appendPathExtension("asm")
//    print(outFileURL.absoluteString)
    
    let outFile = File.create(filePath: outFileURL.path)
    
    let content = inFile.read()
    var lines: [String] = []
    content.enumerateLines{ line, _ in lines.append(line)}
    
    for line in lines {
        let lineToVM = translate(command: line)
        outFile.write(sentence: lineToVM)
    }
}

func compute_exercise1() {
    
    ex1_introduction()
    
    print("Please, enter the file name with the .vm extension")
    let file = "Desktop/" + readLine()!
    
    let fileURL = URL.init(fileURLWithPath: file,
                           relativeTo: FileManager.default.homeDirectoryForCurrentUser)
    
/*URL.init(fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.absoluteString + "Desktop/" + file)/*URL.init(
        fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.absoluteString + "Desktop/" + file,
        isDirectory: false)*/*/
    //print(fileURL.absoluteString)

    translate_file(path: fileURL)
}
