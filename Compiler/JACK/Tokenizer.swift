//
//  Tokenizer.swift
//  Compiler
//
//  Created by Elie Drai on 05/05/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation


class Tokenizer{
    
    var inputString: String
    var index = 0
    var currentToken: Token?
    var tokens: [Token] = []
    var inputChar: Array<String.Element> = Array<String.Element>()
    
    init(input: String) {
        inputString = input
        inputString = inputString.replacingOccurrences(of: "", with: "")
        //inputString = inputString.replacingOccurrences(of: "\n", with: "")
    }
    
    func Tokenize(){
        
        inputChar = Array(inputString)
        let size = inputChar.count
        
        while(index<size){
            getToken()
            if(currentToken == nil){
                print("Error getting the token")
                break
            }
            else{
                tokens.append(currentToken!)
            }
        }
    }
    
    func Tokens() -> [Token]{
        return tokens
    }
    
    private func CurrentChar() -> String{
        if(EOF()) {
            return ""
        }
        return String(inputChar[index])
    }
    
    private func getToken(){
        
        if( SYMBOL.contains(CurrentChar())
            || OP.contains(CurrentChar())
            || UNARYOP.contains(CurrentChar()) ){
            getSymbol()
        }
        
        else if( CurrentChar() == "\"" ){
            getStringConst()
        }
        else if( DIGIT.contains(CurrentChar()) ){
            getIntConst()
        }
        else{
            getString()
        }
    }
    
    
    private func getStringConst(){
        
        var value = ""
        
        repeat{
            if(!advance()){
                SyntaxError(error: "Cannot get the end of string at position \(index)")
                break
            }
            value += CurrentChar()
        } while(CurrentChar() != "\"")
        value.removeLast(1) // remove the last quote
        currentToken = Token.init(val: value, clss: Classification.STRINGCONSTANT)
        advance()
    }
    
    private func getIntConst(){
        var value = ""
        
        repeat{
            value += CurrentChar()
            advance()
        }while(DIGIT.contains(CurrentChar()) || EOF())
        currentToken = Token.init(val: value, clss: Classification.INTEGERCONSTANT)
        
    }
    
    private func getSymbol(){
        var value = ""
        switch (CurrentChar()) {
        case ">": value  = "&lt;"
        case "<": value = "&gt;"
        case "&": value = "&amp;"
        default: value = CurrentChar()
        }
        currentToken = Token.init(val: value, clss: Classification.SYMBOL)
        advance()
    }
    
    private func getString(){
        var value = ""
        while( LETTER.contains( CurrentChar() ) || EOF() || CurrentChar() == "_" ){
            value += CurrentChar()
            advance()
        }
        
        var classification: Classification
        if(KEYWORD.contains(value)){
            classification = Classification.KEYWORD
        }
        else if(KEYWORDCONSTANT.contains(value)){
            classification = Classification.KEYWORDCONSTANT
        }
        else{
            classification = Classification.IDENTIFIER
        }
        currentToken = Token.init(val: value, clss: classification)
    }
    
    private func advance() -> Bool{
        index += 1
        return EOF()
    }
    
    private func EOF() -> Bool {
        return index >= inputChar.count
    }
}
