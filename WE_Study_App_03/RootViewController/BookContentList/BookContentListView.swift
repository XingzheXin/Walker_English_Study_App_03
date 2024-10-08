//
//  BookContentListView.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2023/9/12.
//

import UIKit

class BookContentListView: UIViewController {
    let bookName: String
    
    var flattenedSections: [FlattenedSection] = []
    
    private lazy var XMLParser: XMLSectionParser = {
        let parser = XMLSectionParser()
        if let path = Utils.findFirstXMLFile(in: "\(Bundle.main.resourcePath!)/Assets_Root/\(bookName)/") {
            let url = URL(fileURLWithPath: path)
            if let rootSection = parser.parseXML(url: url) {
                // Use 'rootSection' as needed
                print("Root Section's title is: \(rootSection.title)")
            } else {
                print("Failed to parse XML.")
            }
        } else {
            print("XML file not found.")
        }
        return parser
    }()
    
    private lazy var twoFingerPanGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTwoFingerPanGesture(_:)))
        gestureRecognizer.minimumNumberOfTouches = 2
        gestureRecognizer.maximumNumberOfTouches = 2
        gestureRecognizer.delegate = self // Set delegate to self
        gestureRecognizer.cancelsTouchesInView = true // Important for preventing scrolling
        return gestureRecognizer
    }()

    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.dataSource = self
        v.delegate = self
        v.allowsMultipleSelection = true
        v.allowsMultipleSelectionDuringEditing = true
        v.addGestureRecognizer(twoFingerPanGestureRecognizer)
        v.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        return v
    }()
    
    private lazy var playSelectedButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "播放", style: .plain, target: self, action: #selector(playSelected))
        button.isEnabled = false
        return button
    }()

    private lazy var selectButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "选择", style: .plain, target: self, action: #selector(toggleSelectionMode))
        return button
    }()
    
    private var isSelectionMode: Bool = false
    private var isSelecting: Bool = false // Track whether the user is selecting or deselecting during swipe
    
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
        
        if let rootSection = XMLParser.rootSection {
            flattenSections(section: rootSection, level: 0)
        }
        tableView.reloadData()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        navigationItem.rightBarButtonItems = [playSelectedButton, selectButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    
        // Clear table view selections
        if isSelectionMode {
            tableView.setEditing(false, animated: false)
            isSelectionMode = false
            selectButton.title = "选择"
            playSelectedButton.isEnabled = false
        }

        // Deselect any currently selected rows
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }

    // Recursively flatten the sections and subsections
    private func flattenSections(section: Section, level: Int, ancestry: [Section] = []) {
        // Create a new FlattenedSection with ancestry
        let flattenedSection = FlattenedSection(
            title: section.title,
            type: section.type,
            index: section.index,
            level: level,
            sentences: section.sentences,
            ancestry: ancestry
        )
        flattenedSections.append(flattenedSection)
        
        // Recursively flatten the subsections with updated ancestry
        var newAncestry = ancestry
        newAncestry.append(section)
        for subSection in section.subSections {
            flattenSections(section: subSection, level: level + 1, ancestry: newAncestry)
        }
    }

    
    private func updateSelection(for indexPath: IndexPath) {
        if isSelecting {
            if !(tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false) {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        } else {
            if tableView.indexPathsForSelectedRows?.contains(indexPath) == true {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }

        // Enable/Disable play button based on the current selection state
        playSelectedButton.isEnabled = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
    }

    private func setSelectionMode(_ enabled: Bool) {
        isSelectionMode = enabled
        tableView.setEditing(enabled, animated: true)
        selectButton.title = enabled ? "取消" : "选择"
        updatePlayButtonState()
    }
    
    private func updatePlayButtonState() {
        let selectedCount = tableView.indexPathsForSelectedRows?.count ?? 0
        playSelectedButton.isEnabled = isSelectionMode && selectedCount > 0
    }


//    @objc private func playSelected() {
//        // Implement the functionality to play the selected lessons/sections
//        let selectedRows = tableView.indexPathsForSelectedRows ?? []
//        var selectedSections: [FlattenedSection] = []
//        
////        guard let rootSection = XMLParser.rootSection else {
////            print("Error: Unable to find root element when retrieving from XML")
////            return
////        }
//        
//        for indexPath in selectedRows {
//            // Play each selected lesson/section
////            selectedSections += [rootSection.subSections[indexPath.row]]
//            selectedSections += [flattenedSections[indexPath.row]]
//        }
//        let newVC = ReadingViewController(bookName: bookName, selectedSections: selectedSections)
//        self.navigationController?.pushViewController(newVC, animated: true)
//    }
    
    @objc private func playSelected() {
        // Get all selected rows in the table view
        let selectedRows = tableView.indexPathsForSelectedRows ?? []
        var selectedSections: [FlattenedSection] = []

        for indexPath in selectedRows {
            // Get all relevant sections starting from the selected row
            selectedSections.append(flattenedSections[indexPath.row])
        }
        
        // Remove any duplicate sections that may have been added due to overlapping selections
//        let uniqueSelectedSections = Array(Set(selectedSections))
        
        // Proceed to the reading view controller with the selected sections
        let newVC = ReadingViewController(bookName: bookName, selectedSections: selectedSections)
        self.navigationController?.pushViewController(newVC, animated: true)
    }


    @objc func toggleSelectionMode() {
        setSelectionMode(!isSelectionMode)
    }

    
    private var lastIndexPath: IndexPath?

    @objc func handleTwoFingerPanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
//        guard isSelectionMode else { return }
        if !isSelectionMode {
            toggleSelectionMode()
        }

        let location = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: location), indexPath != lastIndexPath {
            lastIndexPath = indexPath
            switch gestureRecognizer.state {
            case .began:
                if let cell = tableView.cellForRow(at: indexPath) {
                    isSelecting = !cell.isSelected
                }
                selectRow(at: indexPath, selecting: isSelecting)
            case .changed:
                selectRow(at: indexPath, selecting: isSelecting)
            case .ended, .cancelled, .failed:
                isSelecting = false
                lastIndexPath = nil
            default:
                break
            }
        }
    }

    private func selectRow(at indexPath: IndexPath, selecting: Bool) {
        if selecting {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        updatePlayButtonState()

    }
    
    private func preprocessTitle(_ title: String) -> String {
        // Regular expression to match leading # symbols
        let cleanedTitle = title.replacingOccurrences(of: "^#+\\s*", with: "", options: .regularExpression)
        return cleanedTitle
    }
    
    private func getAllRelevantSections(from index: Int) -> [FlattenedSection] {
        guard index < flattenedSections.count else { return [] }
        var relevantSections: [FlattenedSection] = []
        let startingSection = flattenedSections[index]
        let startingLevel = startingSection.level
        
        // Include the starting section itself
        relevantSections.append(startingSection)
        
        // Iterate over the flattenedSections starting from the next index
        for i in (index + 1)..<flattenedSections.count {
            let currentSection = flattenedSections[i]
            
            // Stop if we encounter a section at the same level or higher
            if currentSection.level <= startingLevel {
                break
            }
            
            // Include sections that are part of the selected section's hierarchy
            relevantSections.append(currentSection)
        }
        for x in relevantSections {
            print("Title: \(x.title), Type: \(x.type), Index: \(x.index), Level: \(x.level)")
        }
        return relevantSections
    }


}

extension BookContentListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelectionMode {
            playSelectedButton.isEnabled = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
            // Get all relevant sections for the selected row
//            let relevantSections = getAllRelevantSections(from: indexPath.row)

            // Get all the index paths for the relevant sections
//            var indexPathsToSelect: [IndexPath] = []
//            for section in relevantSections {
//                if let row = flattenedSections.firstIndex(where: { $0 == section }) {
//                    indexPathsToSelect.append(IndexPath(row: row, section: 0))
//                }
//            }

            // Selecte the rows
            for i in (indexPath.row + 1)..<flattenedSections.count {
                let currentSection = flattenedSections[i]
                
                // Stop if we encounter a section at the same level or higher
                if currentSection.level <= flattenedSections[indexPath.row].level {
                    break
                }
                tableView.selectRow(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .none)
            }
            return
        }
        
//        tableView.deselectRow(at: indexPath, animated: true)

        let selectedSections = getAllRelevantSections(from: indexPath.row)
        let newVC = ReadingViewController(bookName: bookName, selectedSections: selectedSections)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isSelectionMode {
            // Update the state of "Play Selected" button based on whether there are still selected rows
            playSelectedButton.isEnabled = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
            // Get all relevant sections for the deselected row
            for i in (indexPath.row + 1)..<flattenedSections.count {
                let currentSection = flattenedSections[i]
                
                // Stop if we encounter a section at the same level or higher
                if currentSection.level <= flattenedSections[indexPath.row].level {
                    break
                }
                tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
            }
            return

        }
    }
}

extension BookContentListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flattenedSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        // Get the corresponding flattened section
        let flattenedSection = flattenedSections[indexPath.row]
        
        // Set the content of the cell
        var content = cell.defaultContentConfiguration()
        content.text = self.preprocessTitle(flattenedSection.title)
        
        // Set the insets to simulate indentation
        let indentationWidth: CGFloat = 20.0  // Width per indentation level
        let totalIndentation = CGFloat(flattenedSection.level) * indentationWidth
        content.directionalLayoutMargins.leading = totalIndentation
        
        let baseFontSize: CGFloat = 20.0  // Base font size for top-level sections
        let fontSizeAdjustment: CGFloat = 2.0  // Adjustment per level
        let adjustedFontSize = baseFontSize - (CGFloat(flattenedSection.level) * fontSizeAdjustment)
        content.textProperties.font = UIFont.systemFont(ofSize: max(10, adjustedFontSize))  // Set a minimum font size of 10
        // Assign the configured content back to the cell
        cell.contentConfiguration = content
        
        return cell
    }


}

extension BookContentListView: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Do not allow simultaneous recognition with the two-finger pan gesture recognizer
        if gestureRecognizer == twoFingerPanGestureRecognizer || otherGestureRecognizer == twoFingerPanGestureRecognizer {
            return false
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == tableView.panGestureRecognizer && otherGestureRecognizer == twoFingerPanGestureRecognizer {
            return true
        }
        return false
    }
}

