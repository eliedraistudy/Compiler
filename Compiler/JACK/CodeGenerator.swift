//
//  CodeGenerator.swift
//  Compiler
//
//  Created by Elie Drai on 28/05/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

class CodeGenerator{
    
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
        print(classSymbolTable.symbols);
        print("end")
    }
    
    private func handleVariables(_ classVarDec: [XMLElement]){
        for line in classVarDec {
            var kindString: String = line.elements(forName: "keyword")[0].objectValue as! String
            kindString = kindString.trimmingCharacters(in: .whitespaces)
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
            //print("The subroutine is:\n \(subroutine)")
            subroutineSymbolTable.reset()
            handleSubroutine(subroutine)
        }
    }
    
    private func handleSubroutine(_ subRoutine: XMLElement){
        
        //  handle the start of the function
        let subRoutineName = subRoutine.elements(forName: "identifier")[0].objectValue as! String
        //print("The subroutine name is:\n\(subRoutineName)")
        let numParameters = handleSubroutineParameters(subRoutine)
        //print(numParameters)
        output += "//   function definition: \(className).\(subRoutineName) \n"
        output += "function \(className).\(subRoutineName) \(numParameters)\n"
        
        let subroutineBody = subRoutine.elements(forName: "subroutineBody")[0]
        let statements = subroutineBody.elements(forName: "statements")[0]
        
        //print(statements)
        handleStatements(statements)
        
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
                subroutineSymbolTable.insert(name: id, type: type, kind: Kind.Argument)
            }
            i+=1
        }
        
        return count
    }
    
    private func handleLetStatement(_ statement: XMLElement){
        
    }
    
    private func handleDoStatement(_ statement: XMLElement){
        
    }
    
    private func handleWhileStatement(_ statement: XMLElement){
        
    }
    
    private func handleIfStatement(_ statement: XMLElement){
        
    }
    
    private func handleReturnStatement(_ statement: XMLElement){
        
    }
    
    private func handleStatements(_ statements: XMLElement){
        let allStatements = statements.children!
        
        for statement in allStatements{
            print(statement)
            let statementName = statement.name
            switch statementName{
            case "letStatement":
                handleLetStatement(statement as! XMLElement)
                
            case "doStatement":
                handleDoStatement(statement as! XMLElement)
                
            case "ifStatement":
                handleIfStatement(statement as! XMLElement)
                
            case "whileStatement":
                handleWhileStatement(statement as! XMLElement)
                
            case "returnStatement":
                handleReturnStatement(statement as! XMLElement)
                
            default:
                output += "ERROR PARSING THE STATEMENT\n"
            }
        }
        
        
        
    }
}
