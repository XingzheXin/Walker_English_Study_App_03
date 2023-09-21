//
//  String+Extensions.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2023/9/20.
//

extension String {
    func removingEmojis() -> String {
        return self.filter { (char) -> Bool in
            let isEmoji = char.unicodeScalars.contains { (scalar) -> Bool in
                return scalar.properties.isEmojiPresentation || scalar.properties.generalCategory == .otherSymbol
            }
            return !isEmoji
        }
    }
}
