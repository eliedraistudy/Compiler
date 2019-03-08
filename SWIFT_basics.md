# Basics of the Swift programming language

For a plain documentation, visit https://docs.swift.org/swift-book/. 

## Types
```Int``` for integers.  
```Double```and ```Float```for floating point values.   
```Bool```for boolean values.    
```String```for textual values.  

There are also the 3 primary **collection type**: ```Array```, ```Set``` and ```Dictionnary```.  

Swift also introduces the __optional type__. Optionals say either “there is a value, and it equals x” or “there isn’t a value at all”.  
We use those values in this way: ```String?```(for optionnal String).  

## Constants and variables

Use `let` to declare constants:  
```
let x: Int = 0; //  So the value of x will never change during the execution of the current scope
```
Use `var` to declare variables:
```
var x: Int = 0: // So the value of x could change during the execution of the current scope
```

### Printing constants and variables
We can print the content of a variable/constant using the function `print(_:separator:terminator:)`. 
For example the current code:
```
let s = "Hello World!";
print(s);
```
By default, at the end, the function will add a newline character but we could change it in this way:  
```
let s = "Hello World!";
print(s, terminator:" "); // which means add a space character after the printing
```
Swift uses **string interpolation** to include the name of a constant or variable as a placeholder in a longer string, and to prompt Swift to replace it with the current value of that constant or variable. We could use it this way:  
```
let s = "Hello World!";
print("The message is: \(s)");
```
See [further](# String and characters) on the use of String and string interpolation
