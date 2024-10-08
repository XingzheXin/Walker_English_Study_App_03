//
//  Utils.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2023/9/7.
//

import Foundation
import UIKit

class Utils {
    public static func getSortedDirectories(in dir: String) -> [String] {
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath! + "/" + dir
        let items = try! fileManager.contentsOfDirectory(atPath: path)
        return items.sorted()
    }
    
    public static func findFirstXMLFile(in directoryPath: String) -> String? {
        let fileManager = FileManager.default
        
        do {
            // Get the list of all files in the directory
            let files = try fileManager.contentsOfDirectory(atPath: directoryPath)
            
            // Filter the list to only include .xml files
            let xmlFiles = files.filter { $0.hasSuffix(".xml") }
            
            // Return the first .xml file
            if let firstXMLFile = xmlFiles.first {
                return directoryPath + "/" + firstXMLFile // Concatenating to create the full path
            }
            
        } catch {
            print("Error listing files in directory: \(error)")
        }
        
        return nil
    }
    
    public static func readXMLFile(at path: String) -> String? {
        do {
            let xmlData = try String(contentsOfFile: path)
            return xmlData
        } catch {
            print("Error reading the file: \(error)")
        }
        return nil
    }
    
    public static func getPathContent(of path: String) -> [String] {
        let fm = FileManager.default
        var res: [String] = []
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            for item in items {
                print("Found \(item)")
                if fm.directoryExists(atPath: path + "/\(item)") {
                    print("this is a directory!")
                    res.append("📂\(item)")
                }
                else {
                    res.append(item)
                }
            }
            return res.sorted().reversed()
        } catch {
            print("failed to read directory – bad permissions, perhaps?")
        }
        
        return []
    }
}
