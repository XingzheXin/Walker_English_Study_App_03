import Foundation

class XMLSectionParser: NSObject, XMLParserDelegate {
    var rootSection: Section?
    private var currentSection: Section?
    private var currentSentence: Sentence?
    private var currentElementValue: String?
    private var currentElementName: String?

    func parseXML(url: URL) -> Section? {
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        if parser?.parse() == true {
            return rootSection
        }
        return nil
    }
    
    // MARK: - XMLParserDelegate Methods

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = elementName

        if elementName == "section" {
            let title = attributeDict["id"] ?? attributeDict["title"] ?? ""
            let type = attributeDict["type"] ?? ""
            let index = attributeDict["index"] ?? ""
            
            let newSection = Section(title: title, type: type, index: index, parent: currentSection)
            currentSection?.addSubSection(newSection)
            currentSection = newSection

            if rootSection == nil {
                rootSection = newSection
            }
        } else if elementName == "sentence" {
            let index = attributeDict["index"] ?? ""
            let currentSectionIdentifier = currentSection?.title.replacingOccurrences(of: " ", with: "_") ?? ""
            let currentSententenceIndex = currentSentence?.index ?? ""
            let uniqueSentenceID = currentSectionIdentifier + currentSententenceIndex
            currentSentence = Sentence(id: uniqueSentenceID, index: index, english: "", chinese: "", parent: currentSection)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementValue == nil {
            currentElementValue = string
        } else {
            currentElementValue! += string
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "section" {
            currentSection = currentSection?.parent
        } else if elementName == "sentence" {
            if let sentence = currentSentence {
                currentSection?.addSentence(sentence)
            }
            currentSentence = nil
        } else if let sentence = currentSentence {
            let trimmedValue = currentElementValue?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            switch elementName {
            case "English":
                sentence.english = trimmedValue
            case "Chinese":
                sentence.chinese = trimmedValue
            case "Speaker":
                sentence.speaker = trimmedValue
            default:
                break
            }
        }
        currentElementValue = nil
    }
}
