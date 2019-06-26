import Foundation

enum Kind:
String {
    case Field = "field"
    case Static = "static"
    case Local = "local"
    case Argument = "argument"
}

struct Entry{
    var name: String
    var type: String
    var kind: Kind
    var index: Int
}

func getKind(_ str: String) -> Kind{
    switch str {
    case Kind.Field.rawValue:
        return Kind.Field
        
    case Kind.Static.rawValue:
        return Kind.Static
        
    case Kind.Local.rawValue:
        return Kind.Local
    default:
        return Kind.Argument
    }
}

class SymbolTable{
    var symbols: Dictionary<String, Entry> = [:]
    
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
        let entry = Entry(name: name, type: type, kind: kind, index: counter)
        insertEntry(entry)
    }
    
    
    
    func reset(){
        symbols.removeAll()
    }
}


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
        
        let statements = subRoutine.elements(forName: "statements")[0]
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


var xmlStr = """
<class><keyword>class</keyword><identifier>Main</identifier><symbol>{</symbol><subroutineDec><keyword>function</keyword><keyword>void</keyword><identifier>main</identifier><symbol>(</symbol><parameterList></parameterList><symbol>)</symbol><subroutineBody><symbol>{</symbol><varDec><keyword>var</keyword><identifier>Array</identifier><identifier>a</identifier><symbol>;</symbol></varDec><varDec><keyword>var</keyword><keyword>int</keyword><identifier>length</identifier><symbol>;</symbol></varDec><varDec><keyword>var</keyword><keyword>int</keyword><identifier>i</identifier><symbol>,</symbol><identifier>sum</identifier><symbol>;</symbol></varDec><statements><letStatement><keyword>let</keyword><identifier>length</identifier><symbol>=</symbol><expression><term><identifier>Keyboard</identifier><symbol>.</symbol><identifier>readInt</identifier><symbol>(</symbol><expressionList><expression><term><stringConstant>HOW MANY NUMBERS? </stringConstant></term></expression></expressionList><symbol>)</symbol></term></expression><symbol>;</symbol></letStatement><letStatement><keyword>let</keyword><identifier>a</identifier><symbol>=</symbol><expression><term><identifier>Array</identifier><symbol>.</symbol><identifier>new</identifier><symbol>(</symbol><expressionList><expression><term><identifier>length</identifier></term></expression></expressionList><symbol>)</symbol></term></expression><symbol>;</symbol></letStatement><letStatement><keyword>let</keyword><identifier>i</identifier><symbol>=</symbol><expression><term><integerConstant>0</integerConstant></term></expression><symbol>;</symbol></letStatement><whileStatement><keyword>while</keyword><symbol>(</symbol><expression><term><identifier>i</identifier></term><symbol>&lt;</symbol><term><identifier>length</identifier></term></expression><symbol>)</symbol><symbol>{</symbol><statements><letStatement><keyword>let</keyword><identifier>a</identifier><symbol>[</symbol><expression><term><identifier>i</identifier></term></expression><symbol>]</symbol><symbol>=</symbol><expression><term><identifier>Keyboard</identifier><symbol>.</symbol><identifier>readInt</identifier><symbol>(</symbol><expressionList><expression><term><stringConstant>ENTER THE NEXT NUMBER: </stringConstant></term></expression></expressionList><symbol>)</symbol></term></expression><symbol>;</symbol></letStatement><letStatement><keyword>let</keyword><identifier>i</identifier><symbol>=</symbol><expression><term><identifier>i</identifier></term><symbol>+</symbol><term><integerConstant>1</integerConstant></term></expression><symbol>;</symbol></letStatement></statements><symbol>}</symbol></whileStatement><letStatement><keyword>let</keyword><identifier>i</identifier><symbol>=</symbol><expression><term><integerConstant>0</integerConstant></term></expression><symbol>;</symbol></letStatement><letStatement><keyword>let</keyword><identifier>sum</identifier><symbol>=</symbol><expression><term><integerConstant>0</integerConstant></term></expression><symbol>;</symbol></letStatement><whileStatement><keyword>while</keyword><symbol>(</symbol><expression><term><identifier>i</identifier></term><symbol>&lt;</symbol><term><identifier>length</identifier></term></expression><symbol>)</symbol><symbol>{</symbol><statements><letStatement><keyword>let</keyword><identifier>sum</identifier><symbol>=</symbol><expression><term><identifier>sum</identifier></term><symbol>+</symbol><term><identifier>a</identifier><symbol>[</symbol><expression><term><identifier>i</identifier></term></expression><symbol>]</symbol></term></expression><symbol>;</symbol></letStatement><letStatement><keyword>let</keyword><identifier>i</identifier><symbol>=</symbol><expression><term><identifier>i</identifier></term><symbol>+</symbol><term><integerConstant>1</integerConstant></term></expression><symbol>;</symbol></letStatement></statements><symbol>}</symbol></whileStatement><doStatement><keyword>do</keyword><identifier>Output</identifier><symbol>.</symbol><identifier>printString</identifier><symbol>(</symbol><expressionList><expression><term><stringConstant>THE AVERAGE IS: </stringConstant></term></expression></expressionList><symbol>)</symbol><symbol>;</symbol></doStatement><doStatement><keyword>do</keyword><identifier>Output</identifier><symbol>.</symbol><identifier>printInt</identifier><symbol>(</symbol><expressionList><expression><term><identifier>sum</identifier></term><symbol>/</symbol><term><identifier>length</identifier></term></expression></expressionList><symbol>)</symbol><symbol>;</symbol></doStatement><doStatement><keyword>do</keyword><identifier>Output</identifier><symbol>.</symbol><identifier>println</identifier><symbol>(</symbol><expressionList></expressionList><symbol>)</symbol><symbol>;</symbol></doStatement><returnStatement><keyword>return</keyword><symbol>;</symbol></returnStatement></statements><symbol>}</symbol></subroutineBody></subroutineDec><symbol>}</symbol></class>

"""
var xmlElement = try XMLElement.init(xmlString: xmlStr)

var CodeGen = CodeGenerator.init(xml: xmlElement)

CodeGen.generateVM()

