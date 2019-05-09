//
//  Token.swift
//  Compiler
//
//  Created by Elie Drai on 08/05/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

class Token{
    
    var content: String
    var classification: Classification
    
    init(val : String, clss: Classification){
        content = val
        classification = clss
    }
    
    func ToXML() -> XMLElement{
        let root = XMLElement(name: classification.rawValue, stringValue: content)
        return root
    }
    
    func ToString() -> String {
        return ToXML().xmlString
    }
}


