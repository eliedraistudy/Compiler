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
        let input = inpF.read()
        
        //  tokenizer
        let tknzr = Tokenizer(read: input)
        let tokens = tknzr.Tokenize();
        
        //  output for tokenizer
        let outTknzr = File.create(filePath: outputFileTokenizer.path)
        outTknzr.write(sentence: "<tokens>")
        for token in tokens {
            outTknzr.write(sentence: token.ToString())
        }
        outTknzr.write(sentence: "</tokens>")
        
        //  output for parser
        let outParse = File.create(filePath: outputFileXML.path);
        let parser = Parser(tokensToParse: tokens);
        let docXML = parser.Parse()
        outParse.write(sentence: "\(docXML)");
        
    }
}
