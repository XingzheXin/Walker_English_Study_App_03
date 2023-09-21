//
//  PageViewController.swift
//  PDF_Reader_UIKit
//
//  Created by Xingzhe Xin on 2022/11/29.
//

import UIKit
import PDFKit


class PageViewController: UIViewController {
    let id: String
    let sentence: Sentence
    let index: Int
    let displayMode: ReaderViewDisplayMode
    
    private lazy var sentenceView = {
        let v = UILabel()
        v.numberOfLines = 0
        v.text = sentence.english + "\n" + sentence.chinese
        v.textAlignment = .center
//        v.lineBreakMode = .byWordWrapping
        v.font = UIFont(name: "Times New Roman", size: 200)
        v.minimumScaleFactor = 0.01
        v.adjustsFontSizeToFitWidth = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
        
    }()
    
    required init?(coder: NSCoder) {
        fatalError("PageView init(coder: ) not implemented")
    }
  
    init(id: String, sentence: Sentence, index: Int, displayMode: ReaderViewDisplayMode) {
        self.id = id
        self.index = index
        self.sentence = sentence
        self.displayMode = displayMode
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(sentenceView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sentenceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sentenceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sentenceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            sentenceView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
}
