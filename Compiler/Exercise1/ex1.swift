//
//  ex1.swift
//  Compiler
//
//  Created by Elie Drai on 04/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation


func ex1_introduction(){
    print("\n\n")
    print("---------------------")
    print("Welcome to Exercise 1: Building a VM translator")
    print("---------------------")
}




func translate_file(path: URL){
    
    let inFile = File(filePath: path.absoluteString)
    let outFile = File.create(filePath: "output.asm")
    
    let content = inFile.read()
    var lines: [String] = []
    content.enumerateLines{ line, _ in lines.append(line)}
    
    for line in lines{
        var VMTranslate = translate(command: line)
        outFile.write(sentence: VMTranslate)
    }
}






func compute_exercise1(){
    
    ex1_introduction()
    let file = "Desktop/" + readLine()!
    
    
    let fileURL = URL.init(fileURLWithPath: file,
                           relativeTo: FileManager.default.homeDirectoryForCurrentUser)
/*URL.init(fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.absoluteString + "Desktop/" + file)/*URL.init(
        fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.absoluteString + "Desktop/" + file,
        isDirectory: false)*/*/

    print(fileURL.absoluteString)
    //translate_file(
        //path: fileURL)
}
