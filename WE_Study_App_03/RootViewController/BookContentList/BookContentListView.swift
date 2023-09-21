//
//  BookContentListView.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2023/9/12.
//

import UIKit

class BookContentListView: UIViewController {
    let bookName: String
    
    private lazy var lessonParser: XMLLessonParser = {
        let lessonParser = XMLLessonParser()
        let xmlPath = Utils.findFirstXMLFile(in: "\(Bundle.main.resourcePath!)/Assets_Root/\(bookName)/")
        let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath ?? ""))
        lessonParser.parseData(data: data ?? Data())
        return lessonParser
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.dataSource = self
        v.delegate = self
        v.allowsMultipleSelection = true
        v.allowsMultipleSelectionDuringEditing = true
        
        v.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        return v
    }()
    
    init(bookName: String) {
        self.bookName = bookName
        print("passed in book name is", bookName)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .systemBackground
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
}

extension BookContentListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newVC = ReadingViewController(bookName: bookName, content: [lessonParser.lessons[indexPath.row]])
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}

extension BookContentListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonParser.lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")! as UITableViewCell
        var content = cell.defaultContentConfiguration()
        content.text = lessonParser.lessons[indexPath.row].EN_name + " " + lessonParser.lessons[indexPath.row].ZH_name
        cell.contentConfiguration = content
        return cell
    }
}
