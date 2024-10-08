//
//  FileManager+Extensions.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 10/3/24.
//

import Foundation

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
