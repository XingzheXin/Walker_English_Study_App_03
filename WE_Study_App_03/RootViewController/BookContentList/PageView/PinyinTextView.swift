//
//  PinyinTextView.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2023/12/22.
//

import UIKit

class PinyinTextView: UIView {

//    var words: [ChineseWord] = [] // Your parsed words
    var wordRects: [CGRect] = []
    var tapped = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)

        if wordRects[0].contains(touchLocation) {
            // The word was tapped, trigger your action
            handleWordTap()
            setNeedsDisplay()
        }
    }

    private func handleWordTap() {
        // Implement the action you want to perform on word tap
        print("Word tapped!")
        tapped = tapped == 1 ? 0 : 1
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("I am drawwwwwwwwwwwwwing the PINYIN VIEW NOWWWWWW")
        let characterFontSize: CGFloat = 300
        let pinyinFontSize: CGFloat = 100
        let verticalSpacing: CGFloat = 5
        let currentX = rect.midX // Start from the middle of the view
        let startY = rect.midY // Adjust this as needed//        }
        
        
        let charAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: characterFontSize),
            .foregroundColor: tapped == 1 ? UIColor.purple : UIColor.black
        ]
        
        let charAttributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: characterFontSize),
        ]
        
        let pinyinAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: pinyinFontSize)
        ]

        // Set up any general styles
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let charSize = ("我" as NSString).size(withAttributes: charAttributes)
        let pinyinSize = ("wǒ" as NSString).size(withAttributes: pinyinAttributes)
        
        let totalHeight = charSize.height + verticalSpacing + pinyinSize.height
        let charRect = CGRect(x: currentX - charSize.width / 2, y: startY - totalHeight / 2, width: charSize.width, height: charSize.height)
//        let pinyinRect = CGRect(x: currentX - pinyinSize.width / 2, y: charRect.minY - pinyinSize.height, width: pinyinSize.width, height: pinyinSize.height)
        let pinyinRect = CGRect(x: currentX - pinyinSize.width / 2, y: charRect.minY - pinyinSize.height, width: pinyinSize.width, height: pinyinSize.height)

        wordRects.append(charRect)
        let charString = NSAttributedString(string: "我", attributes: charAttributes)
        charString.draw(in: charRect)

        let pinyinString = NSAttributedString(string: "wǒ", attributes: pinyinAttributes)
        pinyinString.draw(in: pinyinRect)
        
        let char2Size = ("是" as NSString).size(withAttributes: charAttributes2)
        let pinyin2Size = ("shì" as NSString).size(withAttributes: pinyinAttributes)
        
        
        let totalHeight2 = char2Size.height + verticalSpacing + pinyin2Size.height
        
        let char2Rect = CGRect(x: currentX - charSize.width / 2 + charSize.width, y: startY - totalHeight / 2, width: char2Size.width, height: char2Size.height)
        let pinyin2Rect = CGRect(x: currentX - pinyinSize.width / 2 + charSize.width, y: char2Rect.minY - pinyinSize.height, width: pinyin2Size.width, height: pinyin2Size.height)
        let char2String = NSAttributedString(string: "是", attributes: charAttributes2)
        char2String.draw(in: char2Rect)

        let pinyin2String = NSAttributedString(string: "shì", attributes: pinyinAttributes)
        pinyin2String.draw(in: pinyin2Rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.red.cgColor) // Set border color
            context.setLineWidth(2.0) // Set border width

            // Draw the border
            context.addRect(pinyinRect)
            context.strokePath()
            
            context.setStrokeColor(UIColor.green.cgColor) // Set border color
            context.setLineWidth(2.0) // Set border width

            // Draw the border
            context.addRect(charRect)
            context.strokePath()
        }
    }
}
