//
//  CodeGenerator2.swift
//  Compiler
//
//  Created by Elie Drai on 23/06/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

class CodeGenerator2
{
    var tokens: [Token]
    var ClassName: String
    var index: Int
    var output = ""
    var ClassSymbolTable: SymbolTable = SymbolTable()
    var SubroutineSymbolTable: SymbolTable = SymbolTable()
    var labelCounter = 0
    var functionType = ""
    var isMethod: Bool = false

    
    private func getLabel()
    {
        
    }
    
    
    init(_ tkns: [Token])
    {
        tokens = tkns
        ClassName = tokens[1].value
        index = 0
        
        write("//   Parsing class \(ClassName)")
        write("")
        write("")
        
    }
    
    private func write(_ text: String)
    {
        output += "\(text)\n"
    }
    
    
    func compile()
    {
        CompileClass()
    }
    //  WRITER SECTION
    
    private func writePush(_ segment: String, _ index: Int)
    {
        write("push \(segment) \(index)")
    }
    private func writePop(_ segment: String, _ index: Int)
    {
        write("pop \(segment) \(index)")
    }
    private func writeLabel(_ num: Int)
    {
        write("label Label_\(num)")
    }
    private func writeGoto(_ num: Int)
    {
        write("goto Label_\(num)")
    }
    private func writeIfGoto(_ num: Int)
    {
        write("if-goto Label_\(num)")
    }
    private func writeCall(_ funcName: String, _ nargs: Int)
    {
        write("call \(funcName) \(nargs)")
    }
    private func writeFunction(_ funcName: String, _ nlocal: Int)
    {
        write("")
        write("//-----------------------------------------------")
        write("// Function definition for: \(funcName)")
        write("function \(funcName) \(nlocal)")
    }
    private func writeReturn()
    {
        write("return")
        write("//-----------------------------------------------")
    }
    
    private func writeCommentary(_ text: String)
    {
        write("//   \(text)")
    }
    
    
    // *********************** //
    // ***** Check Token ***** //
    // *********************** //
    
    private func checkNextToken(typesToCheck: [TokenType], valuesToCheck: [String]) -> Token
    {
        let tokenToCheck = tokens[0]
        
        var typeIsOK = false
        var valueIsOK = false
        
        for i in 0...typesToCheck.count - 1 {
            if tokenToCheck.type == typesToCheck[i] {
                typeIsOK = true // One type correspond to one typesToCheck list member
                
                for i in 0...valuesToCheck.count - 1 {
                    if !valuesToCheck[i].elementsEqual("") && tokenToCheck.value.elementsEqual(valuesToCheck[i]) {
                        valueIsOK = true
                    }
                }
            }
        }
        
        if !typeIsOK {
            syntaxError(error: "\(tokenToCheck.ToString()): its type doesn't correspond to \(typesToCheck)")
        }
        
        if !valueIsOK {
            syntaxError(error: "\(tokenToCheck.ToString()): its value doesn't correspond to \(valuesToCheck)")
        }
        
        tokens.remove(at: 0)
        
        return tokenToCheck
    }
    
    private func checkNextToken(typesToCheck: [TokenType]) -> Token
    {
        let tokenToCheck = tokens[0]
        var typeIsOk = false;
        
        for i in 0...typesToCheck.count - 1 {
            if tokenToCheck.type == typesToCheck[i] {
                typeIsOk = true
                break
            }
        }
        
        if !typeIsOk {
            syntaxError(error: "\(tokenToCheck.ToString()): expected type \(typesToCheck)")
        }
        
        tokens.remove(at: 0);
        
        return tokenToCheck
    }
    
    // there are some cases that we have to include void in the type case, we place so the typesToCheck  argument
    private func checkNextTokenType(typesToCheck: [String]) -> Token
    {
        let tokenToCheck = tokens[0]
        
        if !( (tokenToCheck.type == TokenType.KEYWORD && typesToCheck.contains(tokenToCheck.value)) || tokenToCheck.type == .IDENTIFIER) {
            
            syntaxError(error: "\(tokenToCheck.ToString()): expected type \(typesToCheck)")
        }
        
        tokens.remove(at: 0)
        
        return tokenToCheck
    }
    
    private func isNext(typesToCheck: [TokenType]) -> Bool
    {
        let tokenToCheck = tokens[0]
        
        for i in 0...typesToCheck.count - 1 {
            if tokenToCheck.type == typesToCheck[i] {
                return true
            }
        }
        
        return false
    }
    
    private func isNext(typesToCheck: [TokenType], valuesToCheck: [String]) -> Bool
    {
        let tokenToCheck = tokens[0]
        for i in 0...typesToCheck.count - 1 {
            for j in 0...valuesToCheck.count - 1 {
                if tokenToCheck.type == typesToCheck[i] && tokenToCheck.value.elementsEqual(valuesToCheck[j]) {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func isNextType() -> Bool
    {
        let tokenToCheck = tokens[0]
        let allowedTypes = ["int", "char", "boolean"]
        
        if ( (tokenToCheck.type == TokenType.KEYWORD && allowedTypes.contains(tokenToCheck.value)) || tokenToCheck.type == .IDENTIFIER) {
            return true
        }
        
        return false
    }
    
    private func isNextExpression() -> Bool
    {
        if isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["true", "false", "null", "this"]) {
            return true
        } else if isNext(typesToCheck: [.INTEGERCONSTANT, .STRINGCONSTANT, .IDENTIFIER]) {
            return true
        } else if isNext(typesToCheck: [.SYMBOL], valuesToCheck: UNARYOP + ["("]) {
            return true
        } else {
            return false
        }
    }
    
    private func syntaxError(error : String)
    {
        print("Syntax Error: \(error)")
        exit(0)
    }
    
    
    
//  COMPILER SECTION
    
    private func CompileClass()
    {
        //  class -> 'class' className '{' classVarDec* subroutineDec* '}'
        _ = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["class"])
        _ = checkNextToken(typesToCheck: [.IDENTIFIER])
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["{"])
        if(!isNext(typesToCheck: [.SYMBOL], valuesToCheck: ["}"]))
        {
            //  classVarDec*
            while( isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["static", "field"]))
            {
                // classVarDec ->(static | field) type varName(,varname)*
                CompileClassVarDec()
            }
            
            print(ClassSymbolTable.toString())
            
            //  subroutinesDec*
            while( isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["constructor", "function", "method"]) )
            {
                //  subroutineDec -> (constructor | function | method)(void|type)subroutineName(parameterList)subRoutineBody
                isMethod = false;
                CompileSubroutineDec()
            }
            
            
        }
        
        
        print(output)
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["}"])
    }
    
    
    private func CompileClassVarDec()
    {
        // classVarDec ->(static | field) type varName(,varname)*
        
        
        //  get the kind of vardec
        let kindToken = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["static", "field"])
        let kind = getKind(kindToken.value)
        
        //  get the type
        let typeToken = checkNextToken(typesToCheck: [.KEYWORD, .IDENTIFIER])
        let type = typeToken.value
        
        //  get the varName
        let varNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
        let varName = varNameToken.value
        ClassSymbolTable.insert(name: varName, type: type, kind: kind)
        
        while(isNext(typesToCheck: [.SYMBOL], valuesToCheck: [","]))
        {
            //  get rid of the ','
            _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [","])
            //  get the varName
            let varNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
            let varName = varNameToken.value
            ClassSymbolTable.insert(name: varName, type: type, kind: kind)
        }
        
        ClassSymbolTable.insert(name: "this", type: ClassName, kind: .Pointer)
        
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [";"])
        
    }
    
    
    
    private func CompileSubroutineDec()
    {
        //  reset symbol table
        SubroutineSymbolTable.reset()
        
        
          //subroutineDec -> (constructor | function | method)(void|type)subroutineName(parameterList)subRoutineBody
        let functionKindToken = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["constructor", "function", "method"])
        let functionTypeToken = checkNextToken(typesToCheck: [.KEYWORD, .IDENTIFIER])
        let functionNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
        
        //  parameters
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["("])
        if(functionKindToken.value == "method")
        {
            isMethod = true
            //  if is Method, insert in the argument table first the object
            SubroutineSymbolTable.insert(name: "this", type: ClassName, kind: Kind.Argument)
        }
        _ = CompileParameterList()
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"])
        
        
        
        let funcName = ClassName + "." + functionNameToken.value
        
        CompileSubroutineVarDec(funcName)
        
        //  body
        functionType = functionTypeToken.value
        if(functionKindToken.value == "constructor")
        {
            var counterField = 0
            for item in ClassSymbolTable.symbols.values
            {
                if(item.kind.rawValue == "this")
                {
                    counterField+=1
                }
            }
            writePush("constant", counterField)
            writeCall("Memory.alloc", 1)
            writePop("pointer", 0)
        }
        
        else if(functionKindToken.value == "method")
        {
            isMethod = true;
            writePush("argument", 0)
            writePop("pointer", 0)
        }
        
        
        
        CompileSubroutineBody()
        
    }
    
    
    
    private func CompileParameterList() -> Int
    {
        //  parameterList -> ( (type varName) (, type varName)*)?
        var countParameters = 0
        
        while( !isNext(typesToCheck: [.SYMBOL], valuesToCheck: [")"]) )
        {
            let typeToken = checkNextToken(typesToCheck: [.KEYWORD, .IDENTIFIER])
            let varNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
            
            let type = typeToken.value
            let name = varNameToken.value
            let kind = Kind.Argument
            SubroutineSymbolTable.insert(name: name, type: type, kind: kind)
            if( isNext(typesToCheck: [.SYMBOL], valuesToCheck: [","]) )
            {
                _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [","])
            }
            countParameters += 1
        }
        
        return countParameters
    }
    
    private func CompileSubroutineVarDec(_ funcName: String)
    {
        // subroutineBody -> { varDec*
        //  varDec -> var type varName(, varName)*;
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["{"])
        
        var nlocal = 0
        
        while(isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["var"]))
        {
            nlocal += CompileVarDec()
        }
        
        writeFunction(funcName, nlocal)
    }
    
    private func CompileSubroutineBody()
    {
        //  ... statements }
        CompileStatements()
        
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["}"])
    }
    
    private func CompileVarDec() -> Int
    {
        //  varDec -> var type varName(, varName)*;
        _ = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["var"])
        let kind = Kind.Local
        
        
        let typeVarToken = checkNextToken(typesToCheck: [.KEYWORD, .IDENTIFIER])
        let varNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
        let name = varNameToken.value
        let type = typeVarToken.value
        SubroutineSymbolTable.insert(name: name, type: type, kind: kind)
        var nlocal = 1
        while(isNext(typesToCheck: [.SYMBOL], valuesToCheck: [","]))
        {
            _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [","])
            let varNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
            let name = varNameToken.value
            SubroutineSymbolTable.insert(name: name, type: type, kind: kind)
            nlocal += 1
        }
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [";"])
        return nlocal
    }
    
    private func CompileStatements()
    {
        //  statements -> statement* ->(let, if, while, do, return)*
        while(!isNext(typesToCheck: [.SYMBOL], valuesToCheck: ["}"]))
        {
            CompileStatement()
        }
        
    }
    
    private func CompileStatement()
    {
        let typeStatement = isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["let", "while", "do", "if", "return",])
        if(!typeStatement)
        {
            syntaxError(error: "Wrong keyword")
        }
        let typeStatementName = tokens[0].value
        switch typeStatementName {
        case "let":
            CompileLetStatement()
        case "do":
            CompileDoStatement()
        case "if":
            CompileIfStatement()
        case "while":
            CompileWhileStatement()
        case "return":
            CompileReturnStatement()
        default:
            syntaxError(error: "Error parsing \(typeStatement)")
        }
    }
    
    private func CompileExpression()
    {
        //  expression -> term (op term)*
        CompileTerm()
        while(isNext(typesToCheck: [.SYMBOL], valuesToCheck: ["+","-","*","/",">","<","==","and","or","&","|","~","&gt;","&lt;","&amp;", "="]))
        {
            let opToken = checkNextToken(typesToCheck: [.SYMBOL])
            CompileTerm()
            writeArithmetic(opToken.value)
        }
    }
    
    private func writeArithmetic(_ op: String)
    {
        switch op {
        case "+":
            write("add")
        case "-":
            write("sub")
        case "*":
            writeCall("Math.multiply", 2)
        case "/":
            writeCall("Math.divide", 2)
        case ">":
            write("lt")
        case "&gt;":
            write("gt")
        case "<":
            write("lt")
        case "&lt;":
            write("lt")
        case "~":
            write("not")
        case "&":
            write("and")
        case "&amp;":
            write("and")
        case "|":
            write("or")
        case "==":
            write("eq")
        case "=":
            write("eq")
            
        default:
            syntaxError(error: "Error compiling symbol \(op)")
        }
    }
    
    private func CompileTerm()
    {
        //  term -> integerConstant
        //  term -> stringConstant
        //       -> varName
        //       -> varName[expression]
        //       -> subroutineCall
        //       -> (expression)
        //       -> unaryOp term
        
        
        let theNext = tokens[0]
        switch theNext.type
        {
        case .INTEGERCONSTANT:
            let intToken = checkNextToken(typesToCheck: [.INTEGERCONSTANT])
            let intValue = Int(intToken.value)!
            writePush("constant", intValue)
            
            
        case .STRINGCONSTANT:
            //  TODO STRING
            let strToken = checkNextToken(typesToCheck: [.STRINGCONSTANT])
            //  create the string and then append to it the characters
            //  make temp 0 to point to this string and at the end push temp 0
            let strValue = strToken.value
            let length = strValue.count
            writePush("constant", length)
            writeCall("String.new", 1)
            for c in strValue
            {
                writePush("constant", Int(c.asciiValue!))
                writeCall("String.appendChar", 2)
            }
            
            
        case .SYMBOL:
            let symbol = tokens[0]
            if(symbol.value == "(")
            {
                _ = checkNextToken(typesToCheck: [.SYMBOL])
                CompileExpression()
                _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"])
            }
            else //unary op
            {
                let op = checkNextToken(typesToCheck: [.SYMBOL])
                
                CompileTerm()
                if(op.value == "-")
                {
                    write("neg")
                }
                else if(op.value == "~")
                {
                    write("not")
                }
            }
            
            
        case .IDENTIFIER:
            //  1)varname
            //  2)varname[expression]
            //  3)varname(expressionlist)
            //  4)varname.varname(expressionlist)
            let symb = tokens[1]
            if(symb.value == "[") // case 1
            {
                CompileArrayTerm()
            }
            else if(symb.value == "(" || symb.value == ".")
            {
                CompileSubroutineCall()
            }
            else
            {
                let varNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
                let varNameEntry = search(varNameToken.value)
                writePush(varNameEntry!.kind.rawValue, varNameEntry!.index)
            }
            
        case .KEYWORD:
            //  handle this pointer
            let keyToken = checkNextToken(typesToCheck: [.KEYWORD])
            let keyValue = keyToken.value
            if(keyValue == "this")
            {
                writePush("pointer", 0)
            }
            else if(keyValue == "true")
            {
                writePush("constant", 0)
                write("not")
            }
            else if(keyValue == "false")
            {
                writePush("constant", 0)
            }
            else if(keyValue == "null")
            {
                writePush("constant", 0)
            }
        default:
            syntaxError(error: "error during parsing \(theNext)")
        }
    }
    
    private func CompileArrayTerm()
    {
        //  arr[expression]
        let arrToken = checkNextToken(typesToCheck: [.IDENTIFIER])
        let arr = search(arrToken.value)!
        
        _  = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["["])
        
        
        CompileExpression()
        writePush(arr.kind.rawValue, arr.index)
        write("add")
        writePop("pointer", 1)
        writePush("that", 0)
        
        
        _  = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["]"])
    }
    
    private func search(_ varName: String)->Entry?
    {
        var ent = SubroutineSymbolTable.symbols[varName]
        if(ent != nil)
        {
            return ent;
        }
        ent = ClassSymbolTable.symbols[varName]
        if(ent != nil)
        {
            return ent;
        }
        syntaxError(error: "Error finding symbol \(varName)")
        return nil
    }
    
    private func CompileLetStatement()
    {
        //  let -> let varname([expression])? = expression
        _ = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["let"])
        let varNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
        let varName = varNameToken.value
        let varNameEntry = search(varName)!
        if(isNext(typesToCheck: [.SYMBOL], valuesToCheck: ["["]))
        {
            
            _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["["])
            CompileExpression()
            writePush(varNameEntry.kind.rawValue, varNameEntry.index)
            _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["]"])
            write("add")
            _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["="])
            CompileExpression()
            writePop("temp", 0)
            writePop("pointer", 1)
            writePush("temp", 0)
            writePop("that", 0)
        }
        else
        {
            _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["="])
            CompileExpression()
            writePop(varNameEntry.kind.rawValue, varNameEntry.index)
        }
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [";"])
    }
    private func CompileDoStatement()
    {
        //  do -> do subroutineCall;
        _ = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["do"])
        CompileSubroutineCall()
        writePop("temp", 0)
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [";"])
    }
    
    private func CompileSubroutineCall()
    {
        //  subroutine -> ((className | varName).)? subroutineName ( expressionList )
        
        //  if no point present, the caller is the pointer "this 0"
        var funcName = ""
        var existCaller = false
        var nargs = 0
        
        if( tokens[1].value == ".")
        {
            existCaller = true
        }
        
        //var isMethod = true // if no caller, the current method is certainly a method
        if(existCaller)
        {
            //  if a caller exist, must check if current subroutine is method or function
            let callerToken = checkNextToken(typesToCheck: [.IDENTIFIER])
            _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["."])
            let callerName = callerToken.value
            if( !existVariable(callerName) )
            {
                //isMethod = false
                funcName = callerName + "."
            }
            else
            {
                let callerEntry = search(callerName)!
                funcName = callerEntry.type + "."
                writePush(callerEntry.kind.rawValue, callerEntry.index)
                nargs = 1
            }
        }
        else
        {
            funcName = ClassName + "."
            writePush("pointer", 0)
            nargs = 1
        }
        
        let subroutineName = checkNextToken(typesToCheck: [.IDENTIFIER])
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["("])
        
        nargs += CompileExpressionList()
        
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"])
        
        //  write the function call
        funcName += subroutineName.value
        writeCall(funcName, nargs)
        
        
    }
    
    private func CompileExpressionList() -> Int
    {
        var nargs = 0
        while(!isNext(typesToCheck: [.SYMBOL], valuesToCheck: [")"]))
        {
            nargs += 1
            
            CompileExpression()
            if(isNext(typesToCheck: [.SYMBOL], valuesToCheck: [","]))
            {
                _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [","])
            }
        }
        return nargs;
    }
    
    private func existVariable(_ varName: String) -> Bool
    {
        return ClassSymbolTable.symbols[varName] != nil || SubroutineSymbolTable.symbols[varName] != nil
    }
    
    private func CompileSubroutineCall2()
    {
        //  subroutine -> ((className | varName).)? subroutineName ( expressionList )
        
        var isObject = false
        var subroutineName = ""
        //  check first ?
        if(tokens[1].value == ".")
        {
            let callerToken = checkNextToken(typesToCheck: [.IDENTIFIER])
            _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["."])
            
            //  check if the caller is an object or a class
            let caller = callerToken.value
            var callerEntry = SubroutineSymbolTable.symbols[caller]
            if(callerEntry != nil)
            {
                isObject = true;
            }
            else
            {
                callerEntry = ClassSymbolTable.symbols[caller]
                if(callerEntry != nil)
                {
                    isObject = true
                }
            }
            
            if(isObject)
            {
                writePush(callerEntry!.kind.rawValue, callerEntry!.index)
                let subroutineNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
                subroutineName = subroutineNameToken.value
                subroutineName = callerEntry!.type + "." + subroutineName
            }
            else
            {
                let subroutineNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
                subroutineName = subroutineNameToken.value
                subroutineName = caller + "." + subroutineName
            }
        }
        else
        {
            let subroutineNameToken = checkNextToken(typesToCheck: [.IDENTIFIER])
            subroutineName = subroutineNameToken.value
            subroutineName = ClassName + "." + subroutineName
        }
        
        
        
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["("])
        
        var nargs = 0
        while(!isNext(typesToCheck: [.SYMBOL], valuesToCheck: [")"]))
        {
            nargs += 1
            
            CompileExpression()
            
            
            if(isNext(typesToCheck: [.SYMBOL], valuesToCheck: [","]))
            {
                _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [","])
            }
        }
        
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"])
        
        if(isObject)
        {
            //nargs += 1
        }
        writeCall(subroutineName, nargs)
    }
    
    
    private func CompileWhileStatement()
    {
        //  while -> while (expression) { statements }
        _ = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["while"])
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["("])
        
        //  generate labels
        let label1 = labelCounter
        labelCounter+=1
        let label2 = labelCounter
        labelCounter+=1
        
        
        writeLabel(label1)
        //  handle condition
        CompileExpression()
        write("not")
        writeIfGoto(label2)
        
        //  handle statements
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"])
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["{"])
        CompileStatements()
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["}"])
        writeGoto(label1)
        writeLabel(label2)
    }
    private func CompileIfStatement()
    {
        //  if -> if (expression) { statements } (else { statements } )?
        _ = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["if"])
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["("])
        
        //  generate labels
        let label1 = labelCounter
        labelCounter+=1
        let label2 = labelCounter
        labelCounter+=1
        
        CompileExpression()
        write("not")
        writeIfGoto(label1)
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"])
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["{"])
        CompileStatements()
        writeGoto(label2)
        writeLabel(label1)
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["}"])
        if(isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["else"]))
        {
            _ = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["else"])
            _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["{"])
            CompileStatements()
            _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["}"])
        }
        writeLabel(label2)
    }
    
    
    private func CompileReturnStatement()
    {
        _ = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["return"])
        
        if(isNext(typesToCheck: [.SYMBOL], valuesToCheck: [";"]))
        {
            writePush("constant", 0)
        }
        else
        {
            CompileExpression()
        }
        writeReturn()
        _ = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [";"])
    }
    
}




