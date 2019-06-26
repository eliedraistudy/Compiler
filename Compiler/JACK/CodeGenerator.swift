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
    var counter = 0
    
    init(xml: XMLElement){
        classXML = xml
        className = (classXML.elements(forName: "identifier")[0].objectValue as! String).trimmingCharacters(in: .whitespaces)
        classVarDec = classXML.elements(forName: "classVarDec")
        subRoutineDec = classXML.elements(forName: "subroutineDec")
        
        
        
    }
    
    public func generateVM(){
        print("Start compiling class \(className)\n")
        handleVariables(classVarDec)
        print(classSymbolTable.toString())
        output += "//**********************\n"
        output += "//   CLASS \(className)\n"
        output += "//**********************\n\n"
        handleSubroutines(subRoutineDec)
        
        print("End compiling class \(className)")
    }
    
    private func handleVariables(_ classVarDec: [XMLElement]){

        classSymbolTable.insert(name: "this", type: "\(className)", kind: Kind.Pointer)
        for varDec in classVarDec {
            var kindString: String = varDec.elements(forName: "keyword")[0].objectValue as! String
            kindString = kindString.trimmingCharacters(in: .whitespaces)
            let kind = getKind(kindString)
            
            let keywords = varDec.elements(forName: "keyword")
            var type = ""
            if(keywords.count == 2)
            {
                type = varDec.elements(forName: "keyword")[1].objectValue as! String
                for id in varDec.elements(forName: "identifier"){
                    
                    classSymbolTable.insert(
                        name: id.objectValue as! String,
                        type: type,
                        kind: kind
                    )
                }
            }
            else
            {
                var identifiers = varDec.elements(forName: "identifier")
                type = identifiers[0].objectValue as! String
                for index_id in 1...identifiers.count - 1{
                    
                    classSymbolTable.insert(
                        name: identifiers[index_id].objectValue as! String,
                        type: type,
                        kind: kind
                    )
                }
            }
            
            
        }
    }
    
    private func handleSubroutines(_ subRoutineDec: [XMLElement]){
        for subroutine in subRoutineDec{
            //print("The subroutine is:\n \(subroutine)")
            output += "//-------------------------------------------\n"
            subroutineSymbolTable.reset()
            handleSubroutine(subroutine)
            output += "\n//-------------------------------------------\n\n"
        }
    }
    
    private func handleSubroutineVariables(_ varDec: [XMLElement])
    {
        for variable_row in varDec
        {
            let elements = variable_row.children!
            let type = (elements[1].objectValue as! String).trimmingCharacters(in: .whitespaces)
            let ids = variable_row.elements(forName: "identifier")
            for id in ids
            {
                let idName = (id.objectValue as! String).trimmingCharacters(in: .whitespaces)
                if( idName != type)
                {
                    subroutineSymbolTable.insert(name: idName, type: type, kind: Kind.Local)
                }
            }
            
        }
        print(subroutineSymbolTable.toString())
    }
    
    private func handleSubroutine(_ subRoutine: XMLElement){
        
        //  handle the start of the function
        let subRoutineName = (subRoutine.elements(forName: "identifier").last!.objectValue as! String).trimmingCharacters(in: .whitespaces)
        print("Compile function: \(subRoutineName)")
        let numParameters = handleSubroutineParameters(subRoutine)
        //print(numParameters)
        output += "//function definition: \(className).\(subRoutineName) \n\n"
        output += "function \(className).\(subRoutineName) \(numParameters)\n"
        
        //  if method, add this in the arguments
        let subroutineType = (subRoutine.elements(forName: "keyword")[0].objectValue as! String).trimmingCharacters(in: .whitespaces)
        if( subroutineType == "method" ){
            subroutineSymbolTable.insert(name: "this", type: className, kind: Kind.Argument)
            output += "//THIS = arg[0]\n"
            output += "push argument 0\n"
            output += "pop pointer 0\n"
        }
        
        let subroutineBody = subRoutine.elements(forName: "subroutineBody")[0]
        let varDec = subroutineBody.elements(forName: "varDec")
        handleSubroutineVariables(varDec)
        let statements = subroutineBody.elements(forName: "statements")[0]
        
        if( subRoutineName == "new")//ctor case
        {
            handleConstructor()
        }
        //print(statements)
        handleStatements(statements)
        
        
        
    }
    
    private func handleConstructor()
    {
        var counterField = 0
        for item in classSymbolTable.symbols.values
        {
            if(item.kind == Kind.Field)
            {
                counterField+=1
            }
        }
        output += "push \(counterField)\n"
        output += "call Memory.alloc 1\n"
        output += "pop pointer 0\n"
    }
    
    private func handleSubroutineParameters(_ subroutine: XMLElement) -> Int{
        
        
        
        //  handle parameter list
        let parameterList = subroutine.elements(forName: "parameterList")
        var count = 0
        var i = 0
        while( i < parameterList.count ){
            if( parameterList[i].name == "keyword"){
                count += 1
                let type = (parameterList[i].objectValue as! String).trimmingCharacters(in: .whitespaces)
                i+=1
                let id = (parameterList[i].objectValue as! String).trimmingCharacters(in: .whitespaces)
                subroutineSymbolTable.insert(name: id, type: type, kind: Kind.Argument)
            }
            i+=1
        }
        
        return count
    }
    
    private func searchSymbolTable(_ symbol: String) -> Entry{
        
        let mysymbol = symbol.trimmingCharacters(in: .whitespaces)
        var ret = subroutineSymbolTable.symbols[mysymbol]
        if( ret == nil){
            ret = classSymbolTable.symbols[mysymbol]
            if(ret == nil){
                print("Error unknown symbol: \(mysymbol)");
            }
        }
        return ret!;
    }
    
    private func handleExpression(_ expression: XMLElement){
        // term (op term)*
        var elements = expression.children! as! [XMLElement]
        
        while(!elements.isEmpty)
        {
            if(elements[0].name! == "term")
            {
                handleTerm(elements[0])
                elements.remove(at: 0)
            }
            else
            {
                handleTerm(elements[1])
                handleSymbol(elements[0])
                elements.remove(at: 0)
                elements.remove(at: 0)
            }
        }
        
    }
    
    
    private func handleSymbol(_ symbol: XMLElement)
    {
        let symbolValue = symbol.objectValue as! String
        switch symbolValue {
        case "+":
            output += "add\n"
        case "-":
            output += "sub\n"
        case "==":
            output += "eq\n"
        case "&lt;":
            output += "gt\n"
        case "&gt;":
            output += "lt\n"
        case ">":
            output += "gt\n"
        case "<":
            output += "lt\n"
        case "*":
            output += "call Math.multiply 2\n"
        case "/":
            output += "call Math.divide 2\n"
        case "|":
            output += "or\n"
        case "&amp;":
            output += "and\n"
        case "&":
            output += "and\n"
        default:
            output += "ERROR IN SYMBOL \(symbolValue)\n"
        }
    }
    
    private func handleTerm(_ term: XMLElement)
    {
        let elements = term.children as! [XMLElement]
        
        //  number case
        if(elements[0].name! == "integerConstant")
        {
            let number = elements[0].objectValue as! String
            output += "push \(number)\n"
            return
        }
        //  TODO string push
        else if(elements[0].name! == "stringConstant")
        {
            let str = (elements[0].objectValue as! String)
            for c in str
            {
                output += "push '\(c)'\n"
                output += "call String.appendChar 1\n"
            }
            return
        }
        
        //  keyword case
        else if(elements[0].name! == "keyword")
        {
            let key = elements[0].objectValue as! String
            if( key == "null" || key == "false")
            {
                output += "push 0\n";
            }
            else if(key == "true")
            {
                output += "push 1\n";
                output += "neg\n";
            }
        }
            
        //  varName case
        else if(elements[0].name! == "identifier")
        {
            //  handle 2 cases:
            //  1)call to a function or array
            //  2)handle variable
            if(elements.count > 1)
            {
                //  1) function call: term ->
                //              subroutineCall -> subroutineName ( expressionList ) count == 3
                //              subroutineCall -> varName . subroutineName ( expressionList ) count == 6
                //
                //  2) array handling: term -> varName [ expression ] => count = 4
                if(elements.count == 3 || elements.count == 6)
                {
                    handleSubRoutineCall(term)
                }
                else if( elements.count == 4)
                {
                    handleArrayExpression(term)
                }
                
            }
            else
            {
                let varName = (elements[0].objectValue as! String).trimmingCharacters(in: .whitespaces)
                let entryVariable = searchSymbolTable(varName)
                output += "push \(entryVariable.kind.rawValue) \(entryVariable.index)\n"
            }
            
            return
        }
        
        //  symbol first case
        else if( elements[0].name! == "symbol")
        {
            let symbol = elements[0].objectValue as! String
            if( symbol == "(")//    (expression)
            {
                let expression = elements[0].elements(forName: "expression")[0]
                handleExpression(expression)
            }
            else if(symbol == "-") // unaryop term
            {
                
                let term = elements[0].elements(forName: "term")[0]
                handleTerm(term)
                output += "neg\n"
                
            }
            else if(symbol == "~")
            {
                let term = elements[0].elements(forName: "term")[0]
                handleTerm(term)
                output += "not\n"
            }
        }
        
        return
    }
    
    
    private func handleArrayExpression(_ term: XMLElement)
    {
        //  array handling: term -> varName [ expression ]
        let varName = (term.elements(forName: "identifier")[0].objectValue as! String).trimmingCharacters(in: .whitespaces)
        let arr = searchSymbolTable(varName)
        let expression = term.elements(forName: "expression")[0]
        
        output += "push \(arr.kind.rawValue) \(arr.index)\n"
        handleExpression(expression)
        output += "add\n"
        output += "pop pointer 1\n"
        output += "push that 0\n"
        
    }
    
    private func handleLetStatement(_ statement: XMLElement){
        //  let varName ([index])? = expression
        
        
        let varName = (statement.elements(forName: "identifier")[0].objectValue as! String).trimmingCharacters(in: .whitespaces);
        let varNameEntry = searchSymbolTable(varName)
        
    
        let expressions = statement.elements(forName: "expression")
        if(expressions.count == 2)
        {
            //  handle let arr[expression1] = expression2
            let expression1 = expressions[0]
            let expression2 = expressions[1]
            
            output += "push \(varNameEntry.kind.rawValue) \(varNameEntry.index)\n"
            handleExpression(expression1);
            output += "add\n"
            handleExpression(expression2);
            output += "pop temp 0\n"
            output += "pop pointer 1\n"
            output += "push temp 0\n"
            output += "pop that 0\n"
        }
        
        else
        {
            //  handle let var = expression1
            let expression2 = expressions[0]
            handleExpression(expression2);
            output += "pop \(varNameEntry.kind.rawValue) \(varNameEntry.index)\n";
        }
        
       
    }
    
    
    
    
    private func handleSubRoutineCall(_ subroutineCall: XMLElement)
    {
        //  check if exist a point
        let symbols = subroutineCall.elements(forName: "symbol")[0]
        let existPoint = (symbols.objectValue as! String).trimmingCharacters(in: .whitespaces) == "."
        var funcName = ""
        var args = 0
        if(existPoint)
        {
            
            
            
            let obj = subroutineCall.elements(forName: "identifier")[0]
            let objStr = (obj.objectValue as! String).trimmingCharacters(in: .whitespaces)
            
            //  if the nae doesn't exist as a variable
            if( classSymbolTable.symbols[objStr] == nil && subroutineSymbolTable.symbols[objStr] == nil)
            {
                //  template ClassName.f(...)
                //  just call the function
                funcName = (subroutineCall.elements(forName: "identifier")[0].objectValue as! String).trimmingCharacters(in: .whitespaces)
                funcName += "."
                funcName += (subroutineCall.elements(forName: "identifier")[1].objectValue as! String).trimmingCharacters(in: .whitespaces)
            }
            else
            {
                //  template obj.f(...)
                
                
                let objSymbol = searchSymbolTable(objStr)
                funcName = "\(objSymbol.type)."
                funcName += (subroutineCall.elements(forName: "identifier")[1].objectValue as! String).trimmingCharacters(in: .whitespaces)
                output += "push \(objSymbol.kind.rawValue) \(objSymbol.index)\n";
            }
            
        }
        else
        {
            funcName = subroutineCall.elements(forName: "identifier")[0].objectValue as! String
        }
        
        let expressionList = subroutineCall.elements(forName: "expressionList")[0]
        let expressions = expressionList.elements(forName: "expression")
        for expression in expressions
        {
            args += 1
            handleExpression(expression)
        }
        output += "call \(funcName) \(args)\n"
    }
    
    
    private func handleDoStatement(_ statement: XMLElement){
        handleSubRoutineCall(statement)
    }
    
    private func handleWhileStatement(_ statement: XMLElement){
        let condition = statement.elements(forName: "expression")[0]
        let label1 = "L\(counter)"
        counter += 1
        let label2 = "L\(counter)"
        counter += 1
        
        output += "\(label1)\n"
        handleExpression(condition)
        output += "not\n"
        output += "if-goto \(label2)\n"
        _ = statement.elements(forName: "statements")[0]
        output += "goto \(label1)\n"
        output += "label \(label2)\n"
    }
    
    private func handleIfStatement(_ statement: XMLElement){
        
        //  if struct: if expression statements (else statements)
        let condition = statement.elements(forName: "expression")[0]
        let label1 = "L\(counter)"
        counter += 1
        let label2 = "L\(counter)"
        counter += 1
        
        
        handleExpression(condition)
        output += "not\n"
        output += "if-goto \(label1)\n"
        
        
        let statements = statement.elements(forName: "statements")
        handleStatements(statements[0])
        output += "goto \(label2)\n"
        output += "label \(label1)\n"
        if( statements.count == 2 )
        {
            handleStatements(statements[1])
        }
        output += "label \(label2)\n"
        
        
    }
    
    private func handleReturnStatement(_ statement: XMLElement){
        let expression = statement.elements(forName: "expression")
        
        if( expression.count > 0)
        {
            handleExpression(expression[0])
        }
        else
        {
            output += "push constant 0\n"
        }
        output += "return\n"
        
    }
    
    private func handleStatements(_ statements: XMLElement){
        let allStatements = statements.children!
        
        for statement in allStatements{
            //print(statement)
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
