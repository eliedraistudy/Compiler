//
//  JACKFile.swift
//  Compiler
//
//  Created by Elie Drai on 08/05/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation


class JACKFile{
    
    var inputFile:URL
    var outputFileTokenizer:URL
    var outputFileXML:URL
    
    init(input: URL){
        inputFile = input
        
    //  get file name
        let name = inputFile.deletingPathExtension().lastPathComponent
        outputFileTokenizer =
            inputFile.deletingLastPathComponent().appendingPathComponent(name + "T").appendingPathExtension("xml")
        outputFileXML = inputFile.deletingPathExtension().appendingPathExtension("xml")
    }
    
    func compile(){
        let inpF = File(filePath: inputFile.path)
        let read = inpF.read()
        
        //  tokenizer
        let tknzr = Tokenizer(input: read)
        tknzr.Tokenize()
        
        //  output for tokenizer
        let outTknzr = File(filePath: outputFileTokenizer.path)
        for token in tknzr.Tokens() {
            outTknzr.write(sentence: token.ToString())
        }
    }
}
