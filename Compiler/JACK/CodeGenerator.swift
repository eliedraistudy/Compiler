//
//  CodeGenerator.swift
//  Compiler
//
//  Created by Elie Drai on 28/05/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

class ClassCodeGenerator{
    
    var classXML: XMLElement
    var output: String = ""
    var className: String = ""
    var classVarDec: [XMLElement]
    var subRoutineDec: [XMLElement]
    var classSymbolTable = SymbolTable()
    var subroutineSymbolTable = SymbolTable()
    
    init(xml: XMLElement){
        classXML = xml
        className = classXML.elements(forName: "identifier")[0].objectValue as! String
        classVarDec = classXML.elements(forName: "classVarDec")
        subRoutineDec = classXML.elements(forName: "subroutineDec")
    }
    
    public func generateVM(){
        handleVariables(classVarDec)
        handleSubroutines(subRoutineDec)
    }
    
    private func handleVariables(_ classVarDec: [XMLElement]){
        for line in classVarDec {
            let kindString: String = line.elements(forName: "keyword")[0].objectValue as! String
            let kind = getKind(kindString)
            let type: String = line.elements(forName: "keyword")[1].objectValue as! String
            for id in line.elements(forName: "identifier"){
                classSymbolTable.insert(
                    name: id.objectValue as! String,
                    type: type,
                    kind: kind
                )
            }
        }
    }
    
    private func handleSubroutines(_ subRoutineDec: [XMLElement]){
        for subroutine in subRoutineDec{
            subroutineSymbolTable.reset()
            handleSubroutine(subroutine)
        }
    }
    
    private func handleSubroutine(_ subRoutine: XMLElement){
        
        //  handle the start of the function
        let subRoutineName = subRoutine.elements(forName: "identifier")[0].objectValue as! String
        let numParameters = handleSubroutineParameters(subRoutine)
        output += "//   function definition: \(className).\(subRoutineName) \n"
        output += "function \(className).\(subRoutineName) \(numParameters)\n"
        
    }
    
    private func handleSubroutineParameters(_ subroutine: XMLElement) -> Int{
        
        //  if method, add this in the arguments
        let subroutineType = subroutine.elements(forName: "keyword")[0].objectValue as! String
        if( subroutineType == "method"){
            subroutineSymbolTable.insert(name: "this", type: className, kind: Kind.Argument)
        }
        
        //  handle parameter list
        let parameterList = subroutine.elements(forName: "parameterList")
        var count = 0
        var i = 0
        while( i < parameterList.count ){
            if( parameterList[i].name == "keyword"){
                count += 1
                let type = parameterList[i].objectValue as! String
                i+=1
                let id = parameterList[i].objectValue as! String
                let kind = Kind.Argument
                subroutineSymbolTable.insert(name: id, type: type, kind: kind)
            }
            i+=1
        }
        
        return count
    }
}
