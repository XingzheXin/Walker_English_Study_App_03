//
//  PageViewController.swift
//  PDF_Reader_UIKit
//
//  Created by Xingzhe Xin on 2022/11/29.
//

import UIKit
import SwiftUI
import PDFKit


class PageViewController: UIViewController, UITextViewDelegate {
    let id: String
    let sentence: Sentence
    let index: Int
    let displayMode: ENZHDisplayMode
   
    private lazy var hostingController = {
        let swiftUIView = ENZHView(ENText: sentence.english, ZHText: sentence.chinese, displayMode: .EnglishAndChinese)
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .black
        return hostingController
    }()
    
    
//    private lazy var pinyinTextView: PinyinTextView = {
//        let v = PinyinTextView()
//        v.layer.borderColor = UIColor.blue.cgColor
//        v.layer.borderWidth = 2.0
//        v.backgroundColor = .clear
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.isUserInteractionEnabled = true
//        return v
//    }()
//
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//            let clickedText = (textView.text as NSString).substring(with: characterRange)
//            print("Tapped word: \(clickedText)")
//            return false // Return false to not perform the default action, true if you want the default action to be performed
//    }
    
    private lazy var chineseSentenceLabel = {
        let v = UILabel()
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.borderWidth = 2.0
        v.numberOfLines = 0
        v.text = sentence.chinese
        v.textAlignment = .center
        v.font = UIFont(name: "Times New Roman", size: 30)
        v.minimumScaleFactor = 0.01
        v.adjustsFontSizeToFitWidth = true
        v.isUserInteractionEnabled = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
        
    }()
    
    required init?(coder: NSCoder) {
        fatalError("PageView init(coder: ) not implemented")
    }
  
    init(id: String, sentence: Sentence, index: Int, displayMode: ENZHDisplayMode) {
        self.id = id
        self.index = index
        self.sentence = sentence
        self.displayMode = displayMode
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
//        view.addSubview(outerStackView)
        self.addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hostingController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            hostingController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    
}

