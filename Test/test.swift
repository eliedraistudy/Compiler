//
//  test.swift
//  Compiler
//
//  Created by Elie Drai on 04/03/2019.
//  Copyright © 2019 Elie Drai. All rights reserved.
//

import Foundation

/*
func write_to_file(arg fileName: String, arg sentence: String){
    let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
    print("File path: \(fileURL.path)")
    
    do{
        try sentence.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError{
        print("Failed to write to the url")
        print(error)
    }
}*/

func get_files_list(dirURLName: String) -> [String]{
    /*
     Function to get a string list of the different files in the system
     @Parameters:
     - dirURLName: a string which describe the directory URL
     @Return:
     A string array of the files in the directory
     */
    let file_manager = FileManager.default
    do{
        
        let items = try file_manager.contentsOfDirectory(atPath: dirURLName)
        return items
    }
    catch {
        print("Error")
        return []
    }
}

func write_to_file(fileName: String, sentence: String) -> [String]{
    
    let file_manager = FileManager.default
    let dirURLName = "/Users/cyberoot/Desktop/Compiler/swift_file_management_lab"
    do{
        
        let items = try file_manager.contentsOfDirectory(atPath: dirURLName)
        return items
    }
    catch {
        print("Error")
        return []
    }
}
