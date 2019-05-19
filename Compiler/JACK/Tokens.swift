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
    case KEYWORD = "keyword"
    case SYMBOL = "symbol"
    case INTEGERCONSTANT = "intConst"
    case STRINGCONSTANT = "stringConst"
    case IDENTIFIER = "identifier"
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

let OP:[String] = ["+", "-", "*", "/", "&", "|", "<", ">", "="]

let UNARYOP:[String] = ["-" ,"~"]

