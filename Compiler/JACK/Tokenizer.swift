//
//  Tokenizer.swift
//  Compiler
//
//  Created by Elie Drai on 05/05/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

class Tokenizer{
    var input: Array<String.Element>
    var index = 0
    var currentToken: Token?
    var tokens: [Token] = []
    
    init(read: String){
        input = Array(read);
    }
    
    func Tokenize() -> [Token]{
        
        while( !EOF() ){ // iterate over all the characters
            
            //  first check line commentary case
            if( currentCharacter() == "/"
                && index + 1 < input.count
                && nextCharacter() == "/"  ){
                passLineCommentary();
            }
            
            //  check multiple line commentary
            else if( currentCharacter() == "/"
                && index + 1 < input.count
                && nextCharacter() == "*" ){
                passMultipleLineCommentary();
            }
            
            //  pass new line characters
            else if( currentCharacter() == "\n"
                || currentCharacter() == "\r"
                || currentCharacter() == "\r\n"){
                advance();
            }
                
            else if( currentCharacter() == " " || currentCharacter() == "\t"){
                advance(); // pass space character
            }
            
            else{ // here create the tokens
                
                //  check if the current character is a number
                if( currentCharacter().isNumber ){
                    getIntegerConstant();
                }
                
                //  get string constant
                else if( currentCharacter() == "\"" ){
                    getStringConstant();
                }
                
                else if( SYMBOL.contains( String( currentCharacter() ) )
                    || OP.contains( String(currentCharacter()) )
                    || UNARYOP.contains( String( currentCharacter() ) ) ){
                    getSymbol();
                }
                
                else if( currentCharacter().isLetter || currentCharacter() == "_"){
                    getWord();
                }
                
            }
        }
        return tokens
    }
    
    private func getWord(){
        var word = "";
        while( !EOF()
            && currentCharacter() != " "
            && (currentCharacter().isLetter || currentCharacter() == "_") ){
                word += String( currentCharacter() );
                advance();
        }
        
        //advance();
        if( KEYWORD.contains(word) ){
            tokens.append( Token(val: word, typ: TokenType.KEYWORD) );
        }
        else {
            tokens.append( Token(val: word, typ: TokenType.IDENTIFIER) );
        }
    }
    
    private func getSymbol(){
        
        
        var symbol = String( currentCharacter() );
        if(symbol == "<"){ symbol = "&lt;"; }
        if(symbol == ">"){ symbol = "&gt;"; }
        if(symbol == "&"){ symbol = "&amp;"; }
        advance();
        tokens.append( Token(val: symbol, typ: TokenType.SYMBOL) );
    }
    
    
    private func getIntegerConstant(){
        var number = "";
        
        while( !EOF() && currentCharacter().isNumber ){
            number += String( currentCharacter() );
            advance();
        }
        
        //advance();
        tokens.append( Token(val: number, typ: TokenType.INTEGERCONSTANT) );
    }
    
    private func getStringConstant(){
        var str = "";
        advance()
        while( !EOF() && currentCharacter() != "\""  && currentCharacter() != "\n" ){
            str += String( currentCharacter() );
            advance();
        }
        
        if( EOF() || currentCharacter() == "\n"){
            print("Syntax Error: end of string not found");
        }
        else{
            advance(); // pass the end '\"' character
            tokens.append( Token(val: str, typ: TokenType.STRINGCONSTANT) );
        }
    }
    
    private func EOF() -> Bool{
        return index >= input.count;
    }
    
    private func currentCharacter() -> String.Element {
        return input[index];
    }
    
    private func nextCharacter() -> String.Element {
        return input[index+1];
    }
    
    private func advance(){
        index += 1;
    }
    
    
    private func passLineCommentary(){
        while( !EOF()
            && currentCharacter() != "\n"
            && currentCharacter() != "\r"
            && currentCharacter() != "\r\n"){
            advance();
        }
        advance();
    }
    
    private func passMultipleLineCommentary(){
        while( !EOF() ){
            if( currentCharacter() == "*"
                && index+1 < input.count
                && nextCharacter() == "/" ){
                advance(); // input[index] == "/"
                advance(); // input[index] == next token
                break;
            }
            advance();
        }
    }
    
    
    
}


