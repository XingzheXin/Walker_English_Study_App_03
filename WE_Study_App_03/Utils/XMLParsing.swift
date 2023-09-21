//
//  XMLParsing.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2023/9/20.
//

import Foundation

struct Lesson {
    var id: String
    var EN_name: String
    var ZH_name: String
    var lessonCount: Int
    var sentences: [Sentence]
}

struct Sentence {
    var id: String
    var sentenceRelativeCount: Int
    var english: String
    var chinese: String
    var speaker: String
}

class XMLLessonParser: NSObject, XMLParserDelegate {
    
    var lessons: [Lesson] = []
    var currentLesson: Lesson?
    var currentSentence: Sentence?
    var currentElement: String?
    
    func parseData(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    // XMLParserDelegate methods
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        switch elementName {
        case "lesson":
            let id = attributeDict["id"] ?? "nil"
            let EN_name = attributeDict["EN_name"] ?? "nil"
            let ZH_name = attributeDict["ZH_name"] ?? "nil"
            let lessonCount = Int(attributeDict["lessonCount"] ?? "0") ?? 0
            currentLesson = Lesson(id: id,
                                   EN_name: EN_name,
                                   ZH_name: ZH_name,
                                   lessonCount: lessonCount,
                                   sentences: [])
            
        case "sentence":
            let id = attributeDict["id"] ?? "nil"
            let sentenceRelativeCount = Int(attributeDict["sentenceRelativeCount"] ?? "nil") ?? -1
            let english = attributeDict["English"] ?? "nil"
            let chinese = attributeDict["Chinese"] ?? "nil"
            let speaker = attributeDict["speaker"] ?? "nil"
            currentSentence = Sentence(id: id,
                                       sentenceRelativeCount: sentenceRelativeCount,
                                       english: english,
                                       chinese: chinese,
                                       speaker: speaker)
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if data.isEmpty { return }
        
        switch currentElement {
        case "English":
            currentSentence?.english = data
        case "Chinese":
            currentSentence?.chinese = data
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "lesson" {
            if let lesson = currentLesson {
                lessons.append(lesson)
            }
            currentLesson = nil
        }
        
        if elementName == "sentence" {
            if let sentence = currentSentence {
                currentLesson?.sentences.append(sentence)
            }
            currentSentence = nil
        }
        
        currentElement = nil
    }
}

