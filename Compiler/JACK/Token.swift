//
//  Token.swift
//  Compiler
//
//  Created by Elie Drai on 08/05/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

class Token{
    
    var value: String
    var type: TokenType
    
    init(val : String, typ: TokenType){
        value = val
        type = typ
    }
    
    func ToXML() -> XMLElement{
        let root = XMLElement(name: type.rawValue, stringValue: value)
        return root
    }
    
    func ToString() -> String {
        
        return "<\(type.rawValue)> \(value) </\(type.rawValue)>";
        //return ToXML().xmlString
    }
}


