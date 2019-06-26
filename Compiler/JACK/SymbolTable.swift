//
//  SymbolTable.swift
//  Compiler
//
//  Created by Elie Drai on 10/06/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

enum Kind:
String {
    case Field = "this"
    case Static = "static"
    case Local = "local"
    case Argument = "argument"
    case Pointer = "pointer"
}

struct Entry{
    var name: String
    var type: String
    var kind: Kind
    var index: Int
}

func getKind(_ str: String) -> Kind{
    let theStr = str.trimmingCharacters(in: .whitespaces)
    switch theStr {
    case Kind.Field.rawValue:
        return Kind.Field
    
    case Kind.Static.rawValue:
        return Kind.Static
        
    case Kind.Local.rawValue:
        return Kind.Local
        
    case "this":
        return Kind.Field
        
    case "field":
        return Kind.Field
    default:
        return Kind.Argument
    }
}

class SymbolTable{
    var symbols: Dictionary<String, Entry> = [:]
    
    func toString() -> String
    {
        var str = ""
        for item in symbols.values
        {
            str += "name: \(item.name) \ttype: \(item.type) \tkind: \(item.kind) \tindex: \(item.index)\n"
        }
        return str
    }
    
    private func insertEntry(_ entry: Entry){
        symbols[entry.name] = entry
    }
    
    private func count(kind: Kind) -> Int{
        var counter = 0
        for val in symbols.values{
            if (val.kind == kind){
                counter += 1
            }
        }
        return counter
    }
    
    func insert(name: String, type: String, kind: Kind){
        let counter = count(kind: kind)
        let theName = name.trimmingCharacters(in: .whitespaces)
        let theType = type.trimmingCharacters(in: .whitespaces)
        let entry = Entry(name: theName, type: theType, kind: kind, index: counter)
        insertEntry(entry)
    }
    
    
    func reset(){
        symbols.removeAll()
    }
}
