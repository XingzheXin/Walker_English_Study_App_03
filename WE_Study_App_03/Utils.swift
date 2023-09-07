//
//  Utils.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2023/9/7.
//

import Foundation
import UIKit

class Utils {
    static func getDirectoriesUnder(s: String) -> [String] {
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath! + "/" + s
        let items = try! fileManager.contentsOfDirectory(atPath: path)
        return items.sorted()
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

extension FileManager {

    func directoryExists(atUrl url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = self.fileExists(atPath: url.path, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
    
    func directoryExists(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: path, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}
