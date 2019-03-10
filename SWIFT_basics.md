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
See next paragraph on the use of String and string interpolation.

## String and characters
We can create a string in this way:
```
var s = "Hello World!"
```

We can also define a string which spans multiple lines:
```
var s = """
  The White Rabbit put on his spectacles.  "Where shall I begin,
  please your Majesty?" he asked.
  "Begin at the beginning," the King said gravely, "and go on
  till you come to the end; then stop."
  """
```

### Iterate over String
We can interate over strings by using the `for-in` statement. 
```
var x = "1234567890";
for character in x{
  print(character, terminator=" ");
}
```
And the output will be: ```1 2 3 4 5 6 7 8 9 0 ```



















