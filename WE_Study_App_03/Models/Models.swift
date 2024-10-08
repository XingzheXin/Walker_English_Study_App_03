//
//  Models.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 10/3/24.
//

import Foundation

class Section {
    var title: String
    var type: String // "root", "Lesson", etc.
    var index: String
    var parent: Section?
    var subSections: [Section] = []
    var sentences: [Sentence] = []

    init(title: String, type: String, index: String, parent: Section? = nil) {
        self.title = title
        self.type = type
        self.index = index
        self.parent = parent
    }

    func addSubSection(_ section: Section) {
        subSections.append(section)
    }

    func addSentence(_ sentence: Sentence) {
        sentences.append(sentence)
    }

    func buildAssetPath(forSection section: Section, fileName: String, assetType: String) -> String {
        var pathComponents = [section.type.replacingOccurrences(of: " ", with: "_") + "_" + section.index]
        var currentParent = section.parent

        while let parentSection = currentParent {
            pathComponents.insert(parentSection.type.replacingOccurrences(of: " ", with: "_") + "_" + parentSection.index, at: 0)
            currentParent = parentSection.parent
        }

        let fullPath = pathComponents.joined(separator: "/") + "/\(assetType)/\(fileName)"
        return fullPath
    }
}

class Sentence: Identifiable{
    var id: String
    var index: String
    var english: String?
    var chinese: String?
    var speaker: String?
    var parent: Section?

    init(id: String, index: String, english: String? = nil, chinese: String? = nil, speaker: String? = nil, parent: Section? = nil) {
        self.id = id
        self.index = index
        self.english = english
        self.chinese = chinese
        self.speaker = speaker
        self.parent = parent
    }
}

struct FlattenedSection: Hashable {
    var title: String
    var type: String
    var index: String
    var level: Int  // To represent indentation level
    var sentences: [Sentence]
    var ancestry: [Section]

    // Conform to Hashable by defining a hash function
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(type)
        hasher.combine(index)
        hasher.combine(level)
    }

    // Conform to Equatable so that `Set` can determine equality
    static func == (lhs: FlattenedSection, rhs: FlattenedSection) -> Bool {
        return lhs.title == rhs.title &&
               lhs.type == rhs.type &&
               lhs.index == rhs.index &&
               lhs.level == rhs.level
    }
}
