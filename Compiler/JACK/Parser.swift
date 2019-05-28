//
//  Parser.swift
//  Compiler
//
//  Created by Gabriel Elbaz on 05/05/2019.
//  Copyright © 2019 Gabriel Elbaz. All rights reserved.
//

import Foundation


class Parser
{
    var tokensToParse: [Token]
    var resultParsing: XMLDocument? = nil
    
    init(tokensToParse tP: [Token]) {
        tokensToParse = tP
    }
    
    public func Parse () -> XMLDocument
    {
        parseClass()
        return resultParsing!
    }
    
    // *********************** //
    // ***** Check Token ***** //
    // *********************** //
    
    private func checkNextToken(typesToCheck: [TokenType], valuesToCheck: [String]) -> Token
    {
        let tokenToCheck = tokensToParse[0]
        
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
        
        tokensToParse.remove(at: 0)
        
        return tokenToCheck
    }
    
    private func checkNextToken(typesToCheck: [TokenType]) -> Token
    {
        let tokenToCheck = tokensToParse[0]
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
        
        tokensToParse.remove(at: 0);
        
        return tokenToCheck
    }
    
    // there are some cases that we have to include void in the type case, we place so the typesToCheck  argument
    private func checkNextTokenType(typesToCheck: [String]) -> Token
    {
        let tokenToCheck = tokensToParse[0]
        
        if !( (tokenToCheck.type == TokenType.KEYWORD && typesToCheck.contains(tokenToCheck.value)) || tokenToCheck.type == .IDENTIFIER) {
            
            syntaxError(error: "\(tokenToCheck.ToString()): expected type \(typesToCheck)")
        }
        
        tokensToParse.remove(at: 0)
        
        return tokenToCheck
    }
    
    private func isNext(typesToCheck: [TokenType]) -> Bool
    {
        let tokenToCheck = tokensToParse[0]
        
        for i in 0...typesToCheck.count - 1 {
            if tokenToCheck.type == typesToCheck[i] {
                return true
            }
        }
        
        return false
    }
    
    private func isNext(typesToCheck: [TokenType], valuesToCheck: [String]) -> Bool
    {
        let tokenToCheck = tokensToParse[0]
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
        let tokenToCheck = tokensToParse[0]
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
        print(resultParsing!)
        print("Syntax Error: \(error)")
        exit(0)
    }
    
    private func addToFather(tokensToAdd: [Token], fatherXML: XMLElement)
    {
        for i in 0...tokensToAdd.count - 1 {
            
            if tokensToAdd[i].value == "&lt;" {
                tokensToAdd[i].value = "<"
            } else if tokensToAdd[i].value == "&gt;" {
                tokensToAdd[i].value = ">"
            } else if tokensToAdd[i].value == "&amp;" {
                tokensToAdd[i].value = "&"
            }
            
            fatherXML.addChild(XMLElement(name: tokensToAdd[i].type.rawValue, stringValue: tokensToAdd[i].value))
        }
    }
    
    // *************************************** //
    // ***** Program Structure Functions ***** //
    // *************************************** //
    
    private func parseClass()
    {
        // -> 'class'
        let tokenClass = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["class"])
        
        let XMLClass = XMLElement(name: TokenType.CLASS.rawValue)
        resultParsing = XMLDocument(rootElement: XMLClass)
        
        addToFather(tokensToAdd: [tokenClass], fatherXML: XMLClass)
        
        // -> className '{'
        let nextTokens = [checkNextToken(typesToCheck: [.IDENTIFIER]), checkNextToken(typesToCheck: [.SYMBOL])]
        addToFather(tokensToAdd: nextTokens, fatherXML: XMLClass)
        
        // -> classVarDec* subroutineDec* //
        parseClassVarDec(root: XMLClass)
        parseSubroutineDec(root: XMLClass)
        
        // -> '}' //
        let tokParentRight = checkNextToken(typesToCheck: [.SYMBOL])
        addToFather(tokensToAdd: [tokParentRight], fatherXML: XMLClass)
        
        // -> EOF
    }
    
    private func parseClassVarDec(root: XMLElement)
    {
        while (isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["static", "field"])) {
            
            // <classVarDec>
            let XMLClassVarDec = XMLElement(name: TokenType.CLASSVARDEC.rawValue)
            root.addChild(XMLClassVarDec)
            
            // -> ('static', 'field')
            let tokenClassVar = [checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["static", "field"]),
                                 checkNextTokenType(typesToCheck: ["int", "char", "boolean"]),
                                 checkNextToken(typesToCheck: [.IDENTIFIER])]
            addToFather(tokensToAdd: tokenClassVar, fatherXML: XMLClassVarDec)
            
            // -> (',' varName)*
            while (isNext(typesToCheck: [.SYMBOL], valuesToCheck: [","])) {
                let nextTokens = [checkNextToken(typesToCheck: [.SYMBOL]),
                                  checkNextToken(typesToCheck: [.IDENTIFIER])]
                addToFather(tokensToAdd: nextTokens, fatherXML: XMLClassVarDec)
            }
            
            // -> ';'
            let semicolonToken = checkNextToken(typesToCheck: [.SYMBOL])
            addToFather(tokensToAdd: [semicolonToken], fatherXML: XMLClassVarDec)
        }
    }
    
    private func parseSubroutineDec(root: XMLElement)
    {
        while (isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["constructor", "function", "method"])) {
            
            // <subroutineDec>
            let XMLSubroutineDec = XMLElement(name: TokenType.SUBROUTINEDEC.rawValue)
            root.addChild(XMLSubroutineDec)
            
            // -> ('constructor', 'function', 'method')
            let tokenTypeFunc = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["constructor", "function", "method"]);
            addToFather(tokensToAdd: [tokenTypeFunc], fatherXML: XMLSubroutineDec)
            
            // -> ('void', type) subroutineName '('
            let nextTokens = [checkNextTokenType(typesToCheck: ["void"]),
                              checkNextToken(typesToCheck: [TokenType.IDENTIFIER]),
                              checkNextToken(typesToCheck: [TokenType.SYMBOL], valuesToCheck: ["("])]
            addToFather(tokensToAdd: nextTokens, fatherXML: XMLSubroutineDec)
            
            // -> parameterList
            parseParameterList(root: XMLSubroutineDec)
            
            // -> ')'
            let tokenParRight = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"])
            addToFather(tokensToAdd: [tokenParRight], fatherXML: XMLSubroutineDec)
            
            // -> subroutineBody
            parseSubroutineBody(root: XMLSubroutineDec)
        }
    }
    
    private func parseParameterList(root: XMLElement)
    {
        // <parameterList>
        let XMLParameterList = XMLElement(name: TokenType.PARAMETERLIST.rawValue)
        root.addChild(XMLParameterList)
        
        // used because all the expression appears 0 or 1 time
        if isNextType() {
            
            // -> (type varName)
            let nextTokens = [checkNextTokenType(typesToCheck: ["int", "char", "boolean"]),
                              checkNextToken(typesToCheck: [.IDENTIFIER])]
            addToFather(tokensToAdd: nextTokens, fatherXML: XMLParameterList)
            
            // -> (',' type varName)
            while (isNext(typesToCheck: [.SYMBOL], valuesToCheck: [","])) {
                
                let nextTokens = [checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [","]),
                                  checkNextTokenType(typesToCheck: ["int", "char", "boolean"]),
                                  checkNextToken(typesToCheck: [.IDENTIFIER])]
                addToFather(tokensToAdd: nextTokens, fatherXML: XMLParameterList)
            }
        }
    }
    
    private func parseSubroutineBody(root: XMLElement)
    {
        // <subroutineBody>
        let XMLSubroutineBody = XMLElement(name: TokenType.SUBROUTINEBODY.rawValue)
        root.addChild(XMLSubroutineBody)
        
        // -> '{'
        let tokenAccOp = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["{"])
        addToFather(tokensToAdd: [tokenAccOp], fatherXML: XMLSubroutineBody)
        
        // (varDec)* statements
        parseVarDec(root: XMLSubroutineBody)
        parseStatements(root: XMLSubroutineBody)
        
        // -> '}'
        let tokenAccCl = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["}"])
        addToFather(tokensToAdd: [tokenAccCl], fatherXML: XMLSubroutineBody)
    }
    
    private func parseVarDec(root: XMLElement)
    {
        while isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["var"]) {
            
            // <varDec>
            let XMLVarDec = XMLElement(name: TokenType.VARDEC.rawValue)
            root.addChild(XMLVarDec)
            
            // -> 'var' type varName
            let nextTokens = [checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["var"]),
                              checkNextTokenType(typesToCheck: ["int", "char", "boolean"]),
                              checkNextToken(typesToCheck: [.IDENTIFIER])]
            addToFather(tokensToAdd: nextTokens, fatherXML: XMLVarDec)
            
            // -> (',' varName)*
            while (isNext(typesToCheck: [.SYMBOL], valuesToCheck: [","])) {
                let nextTokens = [checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [","]),
                                  checkNextToken(typesToCheck: [TokenType.IDENTIFIER])]
                addToFather(tokensToAdd: nextTokens, fatherXML: XMLVarDec)
            }
            
            // -> ';'
            let tokenSemiColon = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [";"])
            addToFather(tokensToAdd: [tokenSemiColon], fatherXML: XMLVarDec)
        }
    }
    
    // ******************************** //
    // ***** Statements Functions ***** //
    // ******************************** //
    
    private func parseStatements(root: XMLElement)
    {
        // <statements>
        let XMLStatements = XMLElement(name: TokenType.STATEMENTS.rawValue)
        root.addChild(XMLStatements)
        
        // -> statements*
        while (isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["let", "if", "while", "do", "return"])) {
            parseStatement(root: XMLStatements)
        }
    }
    
    private func parseStatement(root: XMLElement)
    {
        if isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["let"]) {
            parseLetStatement(root: root)
        } else if isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["if"]) {
            parseIfStatement(root: root)
        } else if isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["while"]) {
            parseWhileStatement(root: root)
        } else if isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["do"]) {
            parseDoStatement(root: root)
        } else if isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["return"]) {
            parseReturnStatement(root: root)
        }
    }
    
    private func parseLetStatement(root: XMLElement)
    {
        // <letStatement>
        let XMLLetStatement = XMLElement(name: TokenType.LETSTATEMENT.rawValue)
        root.addChild(XMLLetStatement)
        
        // -> 'let' varName
        let nextTokens = [checkNextToken(typesToCheck: [TokenType.KEYWORD], valuesToCheck: ["let"]),
                          checkNextToken(typesToCheck: [TokenType.IDENTIFIER])]
        addToFather(tokensToAdd: nextTokens, fatherXML: XMLLetStatement)
        
        // -> ( '(', expression, ')' )?
        if isNext(typesToCheck: [.SYMBOL], valuesToCheck: ["["]) {
            let tokenHoOp = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["["])
            addToFather(tokensToAdd: [tokenHoOp], fatherXML: XMLLetStatement)
            
            parseExpression(root: XMLLetStatement)
            
            let tokenHoCl = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["]"])
            addToFather(tokensToAdd: [tokenHoCl], fatherXML: XMLLetStatement)
        }
        
        // -> "="
        let tokenEq = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["="])
        addToFather(tokensToAdd: [tokenEq], fatherXML: XMLLetStatement)
        
        parseExpression(root: XMLLetStatement)
        
        // -> ';'
        let tokenSemiColon = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [";"])
        addToFather(tokensToAdd: [tokenSemiColon], fatherXML: XMLLetStatement)
    }
    
    private func parseIfStatement(root: XMLElement)
    {
        // <ifStatement>
        let XMLIfStatement = XMLElement(name: TokenType.IFSTATEMENT.rawValue)
        root.addChild(XMLIfStatement)
        
        // -> 'if' '('
        var nextTokens = [checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["if"]),
                          checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["("])]
        addToFather(tokensToAdd: nextTokens, fatherXML: XMLIfStatement)
        
        // -> expression
        parseExpression(root: XMLIfStatement)
        
        // -> ')' '{'
        nextTokens = [checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"]),
                      checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["{"])]
        addToFather(tokensToAdd: nextTokens, fatherXML: XMLIfStatement)
        
        // -> statements
        parseStatements(root: XMLIfStatement)
        
        // '}'
        var tokenAccCl = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["}"])
        addToFather(tokensToAdd: [tokenAccCl], fatherXML: XMLIfStatement)
        
        // ('else' '{' statements '}' )?
        if isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["else"]) {
            
            nextTokens = [checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["else"]),
                          checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["{"])]
            addToFather(tokensToAdd: nextTokens, fatherXML: XMLIfStatement)
            
            parseStatements(root: XMLIfStatement)
            
            tokenAccCl = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["}"])
            addToFather(tokensToAdd: [tokenAccCl], fatherXML: XMLIfStatement)
        }
    }
    
    private func parseWhileStatement(root: XMLElement)
    {
        // <whileStatement>
        let XMLWhileStatement = XMLElement(name: TokenType.WHILESTATEMENT.rawValue)
        root.addChild(XMLWhileStatement)
        
        // -> 'while' '('
        var nextTokens = [checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["while"]),
                          checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["("])]
        addToFather(tokensToAdd: nextTokens, fatherXML: XMLWhileStatement)
        
        // -> expression
        parseExpression(root: XMLWhileStatement)
        
        // ')' '{'
        nextTokens = [checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"]),
                      checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["{"])]
        addToFather(tokensToAdd: nextTokens, fatherXML: XMLWhileStatement)
        
        // statements
        parseStatements(root: XMLWhileStatement)
        
        // -> '}'
        let tokenAccCl = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["}"])
        addToFather(tokensToAdd: [tokenAccCl], fatherXML: XMLWhileStatement)
    }
    
    private func parseDoStatement(root: XMLElement)
    {
        // <doStatement>
        let XMLDoStatement = XMLElement(name: TokenType.DOSTATEMENT.rawValue)
        root.addChild(XMLDoStatement)
        
        // -> 'do'
        let tokenDo = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["do"])
        addToFather(tokensToAdd: [tokenDo], fatherXML: XMLDoStatement)
        
        // -> subroutineCall
        parseSubroutineCall(root: XMLDoStatement)
        
        // ';'
        let tokenSemiColon = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [";"])
        addToFather(tokensToAdd: [tokenSemiColon], fatherXML: XMLDoStatement)
    }
    
    private func parseReturnStatement(root: XMLElement)
    {
        // <returnStatement>
        let XMLReturnStatement = XMLElement(name: TokenType.RETURNSTATEMENT.rawValue)
        root.addChild(XMLReturnStatement)
        
        // -> 'return'
        let tokenReturn = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["return"])
        addToFather(tokensToAdd: [tokenReturn], fatherXML: XMLReturnStatement)
        
        // expression?
        if isNextExpression() {
            parseExpression(root: XMLReturnStatement)
        }
        
        // ';'
        let tokenSemiColon = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [";"])
        addToFather(tokensToAdd: [tokenSemiColon], fatherXML: XMLReturnStatement)
    }
    
    // ********************************* //
    // ***** Expressions Functions ***** //
    // ********************************* //
    
    private func parseExpression(root: XMLElement)
    {
        // <expression>
        let XMLExpression = XMLElement(name: TokenType.EXPRESSION.rawValue)
        root.addChild(XMLExpression)
        
        // -> term
        parseTerm(root: XMLExpression)
        
        // -> (op term)*
        while (isNext(typesToCheck: [.SYMBOL], valuesToCheck: OP)) {
            
            let tokenOp = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: OP)
            addToFather(tokensToAdd: [tokenOp], fatherXML: XMLExpression)
            
            parseTerm(root: XMLExpression)
        }
    }
    
    private func parseTerm(root: XMLElement)
    {
        // <term>
        let XMLTerm = XMLElement(name: TokenType.TERM.rawValue)
        root.addChild(XMLTerm)
        
        if isNext(typesToCheck: [.INTEGERCONSTANT, .STRINGCONSTANT]) {
            
            let tokenConst = checkNextToken(typesToCheck: [.INTEGERCONSTANT, .STRINGCONSTANT])
            addToFather(tokensToAdd: [tokenConst], fatherXML: XMLTerm)
            
        } else if isNext(typesToCheck: [.SYMBOL]) {
            
            if isNext(typesToCheck: [.SYMBOL], valuesToCheck: ["("]) {
                
                let tokenParOp = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["("])
                addToFather(tokensToAdd: [tokenParOp], fatherXML: XMLTerm)
                
                parseExpression(root: XMLTerm)
                
                let tokenParCl = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"])
                addToFather(tokensToAdd: [tokenParCl], fatherXML: XMLTerm)
                
            } else if isNext(typesToCheck: [.SYMBOL], valuesToCheck: UNARYOP) {
                
                let tokenOp = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: UNARYOP)
                addToFather(tokensToAdd: [tokenOp], fatherXML: XMLTerm)
                
                parseTerm(root: XMLTerm)
                
            }
            
        } else if isNext(typesToCheck: [.KEYWORD, .IDENTIFIER]) {
            
            if isNext(typesToCheck: [.KEYWORD], valuesToCheck: ["true", "false", "null", "this"]) {
                
                let tokenKeyConst = checkNextToken(typesToCheck: [.KEYWORD], valuesToCheck: ["true", "false", "null", "this"])
                addToFather(tokensToAdd: [tokenKeyConst], fatherXML: XMLTerm)
                
                // cases of varName, varName '[' expression ']', [subroutineName '(', name '.']
            } else {
                
                let tokenAfterNext = tokensToParse[1]
                
                if tokenAfterNext.type == .SYMBOL &&
                    (tokenAfterNext.value.elementsEqual("[") ||
                        tokenAfterNext.value.elementsEqual("(") ||
                        tokenAfterNext.value.elementsEqual(".")) {
                    
                    if tokenAfterNext.value.elementsEqual("[") {
                        
                        let nextTokens = [checkNextToken(typesToCheck: [.IDENTIFIER]), checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["["])]
                        addToFather(tokensToAdd: nextTokens, fatherXML: XMLTerm)
                        
                        parseExpression(root: XMLTerm)
                        
                        let tokenHoCl = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["]"])
                        addToFather(tokensToAdd: [tokenHoCl], fatherXML: XMLTerm)
                        
                    } else if tokenAfterNext.value.elementsEqual("(") || tokenAfterNext.value.elementsEqual(".")  {
                        
                        parseSubroutineCall(root: XMLTerm)
                        
                    }
                    
                    // varName
                } else {
                    
                    let tokenVarname = checkNextToken(typesToCheck: [.IDENTIFIER])
                    addToFather(tokensToAdd: [tokenVarname], fatherXML: XMLTerm)
                    
                }
                
            }
            
        }
    }
    
    private func parseSubroutineCall(root: XMLElement)
    {
        // {subroutine, class, var}Name
        let tokenName = checkNextToken(typesToCheck: [.IDENTIFIER])
        addToFather(tokensToAdd: [tokenName], fatherXML: root)
        
        // '(' expressionList ')'
        if isNext(typesToCheck: [.SYMBOL], valuesToCheck: ["("]) {
            let tokenParOp = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["("])
            addToFather(tokensToAdd: [tokenParOp], fatherXML: root)
            
            parseExpressionList(root: root)
            
            let tokenParCl = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"])
            addToFather(tokensToAdd: [tokenParCl], fatherXML: root)
            
            // '.' subroutineName '(' expressionList ')'
        } else if isNext(typesToCheck: [.SYMBOL], valuesToCheck: ["."]) {
            
            let nextTokens = [checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["."]),
                              checkNextToken(typesToCheck: [.IDENTIFIER]),
                              checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: ["("])]
            addToFather(tokensToAdd: nextTokens, fatherXML: root)
            
            parseExpressionList(root: root)
            
            let tokenParCl = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [")"])
            addToFather(tokensToAdd: [tokenParCl], fatherXML: root)
        }
    }
    
    private func parseExpressionList(root: XMLElement)
    {
        let XMLExpressionList = XMLElement(name: TokenType.EXPRESSIONLIST.rawValue)
        root.addChild(XMLExpressionList)
        
        if isNextExpression() {
            
            // expression
            parseExpression(root: XMLExpressionList)
            
            // (',' expression)*
            while isNext(typesToCheck: [.SYMBOL], valuesToCheck: [","]) {
                
                let tokenColon = checkNextToken(typesToCheck: [.SYMBOL], valuesToCheck: [","])
                addToFather(tokensToAdd: [tokenColon], fatherXML: XMLExpressionList)
                
                parseExpression(root: XMLExpressionList)
            }
        }
    }
    
}
