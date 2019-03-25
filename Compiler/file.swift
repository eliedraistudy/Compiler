//
//  file.swift
//  Compiler
//
//  Created by Elie Drai on 04/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

class File{
    /*
     A class to manage file in the system
     */
    var fileURL: URL
    
    init(filePath: String){
        /*
         Constructor for file management
         */
        //self.fileURL = URL(
        fileURL = URL(fileURLWithPath: filePath)
    }
    
    /*func URL() -> URL{
        return fileURL;
    }*/
    
    func write(sentence: String){
        /*
         Write the sentence at the end of the file
         */
        let f = FileHandle(forUpdatingAtPath: fileURL.path)
        if f == nil{
            print("File open failed")
            return
        }
        let d = sentence + "\n"
        let data = (d as NSString).data(using: String.Encoding.utf8.rawValue)
        f?.seekToEndOfFile()
        f?.write(data!)
        f?.closeFile()
    }
    
    func read() -> String {
        /*
         Read the entire file into a single string
         */
        let f = FileHandle(forReadingAtPath: fileURL.path)
        if f == nil{
            print("File open failed")
            return ""
        }
        
        let data = f?.readDataToEndOfFile()
        
        return String(decoding: data!, as: UTF8.self)
    }
    
    static func create(filePath: String) -> File {
        FileManager.default.createFile(
            atPath: filePath,
            contents: nil,
            attributes: nil)
        return File(filePath: filePath)
    }
}
