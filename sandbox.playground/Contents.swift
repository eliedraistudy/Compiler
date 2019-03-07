import Cocoa

var str = "Hello, playground"

let fileName = "test"
let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
print("File path: \(fileURL.path)")

let writeString = "Write this text to the file"
do{
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} catch let error as NSError{
    print("Failed to write to the url")
    print(error)
}
