//
//  Tokens.swift
//  Compiler
//
//  Created by Elie Drai on 05/05/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

enum TokenType:
String{
    // Lexical Elements
    case KEYWORD = "keyword"
    case SYMBOL = "symbol"
    case INTEGERCONSTANT = "integerConstant"
    case STRINGCONSTANT = "stringConstant"
    case IDENTIFIER = "identifier"
    
    // Program Stucture
    case CLASS = "class"
    case CLASSVARDEC = "classVarDec"
    case TYPE = "type"
    case SUBROUTINEDEC = "subroutineDec"
    case PARAMETERDEC = "parameterDec"
    case PARAMETERLIST = "parameterList"
    case SUBROUTINEBODY = "subroutineBody"
    case VARDEC = "varDec"
    
    // Statements
    case STATEMENTS = "statements"
    case STATEMENT = "statement"
    case LETSTATEMENT = "letStatement"
    case IFSTATEMENT = "ifStatement"
    case WHILESTATEMENT = "whileStatement"
    case DOSTATEMENT = "doStatement"
    case RETURNSTATEMENT = "returnStatement"
    
    // Expressions
    case EXPRESSION = "expression"
    case TERM = "term"
    case SUBROUTINECALL = "subroutineCall"
    case EXPRESSIONLIST = "expressionList"
}

let KEYWORD:[String] = [
    "class",
    "constructor",
    "function",
    "method",
    "field",
    "static",
    "var",
    "int",
    "char",
    "boolean",
    "void",
    "true",
    "false",
    "null",
    "this",
    "let",
    "do",
    "if",
    "else",
    "while",
    "return",
    "true",
    "false",
    "null",
    "this"]

let KEYWORDCONSTANT:[String] = [
    "true",
    "false",
    "null",
    "this"]

let SYMBOL:[String] = ["{","}","(",")","[","]",".",",",";","+","-","*","/","&","|","<",">","=","~"]

let DIGIT:[String] = ["0","1","2","3","4","5","6","7","8","9"]

let LETTER:[String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

let OP:[String] = ["+", "-", "*", "/", "&", "|", "<", ">", "=", "&lt;", "&gt;", "&amp;"]

let UNARYOP:[String] = ["-" ,"~"]

