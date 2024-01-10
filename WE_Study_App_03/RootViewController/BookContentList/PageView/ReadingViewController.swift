//
//  ReadingViewController.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2023/9/20.
//

import Foundation
import UIKit
import AVFoundation

class ReadingViewController: UIViewController {
    
    private var content: [Lesson]
    private var bookName: String
    
    private var indexToLessonAndSentenceMap: [Int: (Int, Int)] = [:]
    private var totalSentenceCount: Int = 0
    
    private var animatePageTransition = true
    private var displayMode: ENZHDisplayMode = .EnglishAndChinese
    
    private lazy var audioHandler: AudioHandler? = {
        let audioHandler = AudioHandler()
        audioHandler.sender = self
        return audioHandler
    }()
    
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        // *******************************************************************
        // Set initial viewcontroller
//        let page = PageViewController(id: "abcdefg", index: 0, displayMode: .en_zh)
        let page = PageViewController(id: content[0].id, sentence: content[0].sentences[0], index: 0, displayMode: self.displayMode)
        pageViewController.setViewControllers([page], direction: .forward, animated: false, completion: nil)
        // *******************************************************************
        
        return pageViewController
    }()
    
    private lazy var customBackButton = {
        let customBackButton = UIButton()
        customBackButton.setImage(UIImage(named: "custom_back_btn"), for: .normal)
        customBackButton.imageView?.contentMode = .scaleAspectFit
        customBackButton.addTarget(self, action: #selector(onClickBackButton), for: .touchUpInside)
        customBackButton.translatesAutoresizingMaskIntoConstraints = false
        
        return customBackButton
    }()
    
    private lazy var customLoopButton = {
        let customLoopButton = UIButton()
        customLoopButton.setImage(UIImage(named: "custom_loop_btn"), for: .normal)
        customLoopButton.imageView?.contentMode = .scaleAspectFit
        customLoopButton.translatesAutoresizingMaskIntoConstraints = false
        
        var menuItems = [UIAction]()
        for i in -1...9 {
            let titleText = i == -1 ? "∞" : String(i+1)
            let loopMenuItem = UIAction(title: titleText, image: UIImage(systemName: "square.circle")) { _ in
                self.audioHandler?.loopNumberSetting = i
                self.audioHandler?.restartPlaying()
            }
            menuItems.append(loopMenuItem)
        }
        
        customLoopButton.showsMenuAsPrimaryAction = true
        customLoopButton.menu = UIMenu(children: menuItems)
        
        return customLoopButton
    }()
    
    private lazy var autoPlayAndStopButton = {
        let autoPlayAndStopButton = UIButton()
        autoPlayAndStopButton.setImage(UIImage(named: "custom_stop_btn"), for: .normal)
        autoPlayAndStopButton.imageView?.contentMode = .scaleAspectFit
        autoPlayAndStopButton.addTarget(self, action: #selector(onClickAutoplayAndStopButton), for: .touchUpInside)
        autoPlayAndStopButton.translatesAutoresizingMaskIntoConstraints = false
        
        return autoPlayAndStopButton

    }()
    
    private lazy var pauseAndResumeButton = {
        let pauseAndResumeButton = UIButton()
        pauseAndResumeButton.setImage(UIImage(named: "custom_pause_btn"), for: .normal)
        pauseAndResumeButton.addTarget(self, action: #selector(onClickPauseAndResumeButton), for: .touchUpInside)
        pauseAndResumeButton.translatesAutoresizingMaskIntoConstraints = false
        return pauseAndResumeButton
    }()
    
    
    private lazy var infoButton = {
        let infoButton = UIButton()
        infoButton.setImage(UIImage(named: "custom_info_btn"), for: .normal)
        infoButton.imageView?.contentMode = .scaleAspectFit
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        let menuItem = UIAction(title: "Toggle Transition", image: UIImage(systemName: "circle.square")) { _ in
            self.animatePageTransition = !self.animatePageTransition
            
        }
        
        infoButton.showsMenuAsPrimaryAction = true
        infoButton.menu = UIMenu(children: [menuItem])

        return infoButton
    }()
    
    private lazy var topBarItems = [customBackButton, pauseAndResumeButton, autoPlayAndStopButton, customLoopButton, infoButton]
    
    private lazy var topBar = {
        let topBar = UIView()
        topBarItems.forEach { topBar.addSubview($0) }
        topBar.translatesAutoresizingMaskIntoConstraints = false
        return topBar
    }()
    
    init(bookName: String, content: [Lesson]) {
        self.bookName = bookName
        self.content = content
        super.init(nibName: nil, bundle: nil)
        generateMappingAndPageCount()
    }
    
    required init?(coder: NSCoder) {
        fatalError("BookViewController init(coder: ) not implemented")
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        addChildViewcontrollers()
        setupView()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        self.audioHandler = nil
    }
    
    private func addChildViewcontrollers() {
        addChild(pageViewController)
    }
    
    private func setupView() {
        view.addSubview(pageViewController.view)
        view.addSubview(topBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            topBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            topBar.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.04),
        ])
        
        // Set constraints for each item within top bar
        for i in 0..<topBarItems.count {
            if i == 0 {
                topBarItems[i].leftAnchor.constraint(equalTo: topBar.leftAnchor, constant: 20).isActive = true
            }
            else if i == topBarItems.count - 1 {
                topBarItems[i].rightAnchor.constraint(equalTo: topBar.rightAnchor, constant: -20).isActive = true
            }
            else {
                topBarItems[i].rightAnchor.constraint(equalTo: topBarItems[i + 1].leftAnchor, constant: -50).isActive = true
            }
        }
        
        topBar.subviews.forEach {
            $0.heightAnchor.constraint(equalTo: topBar.heightAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: topBar.heightAnchor).isActive = true
        }
    }
    
    private func generateMappingAndPageCount() {
        
        var indexToSentenceMap: [Int: (Int, Int)] = [:]
        var counter = 0
        for i in 0..<content.count {
            for j in 0..<content[i].sentences.count {
                indexToSentenceMap[counter] = (i, j)
                counter += 1
            }
        }
        
        self.indexToLessonAndSentenceMap = indexToSentenceMap
        self.totalSentenceCount = counter
        
//        print(indexToSentenceMap)
//        print(totalSentenceCount)
    }
    
    private func getPageViewController(at currentIndex: Int) -> PageViewController {
//        print(indexToLessonAndSentenceMap)
        let (currentlessonIndex, currentsentenceRelativeIndex) = indexToLessonAndSentenceMap[currentIndex] ?? (0,0)
//        print(currentlessonIndex, currentsentenceRelativeIndex)
        let lesson = content[currentlessonIndex]
        let sentence = lesson.sentences[currentsentenceRelativeIndex]
        let id = sentence.id
        return PageViewController(id: id, sentence: sentence, index: currentIndex, displayMode: displayMode)
    }
    
    private func playAudio() {
        let currentPage = self.pageViewController.viewControllers![0] as! PageViewController
        let audioFilePath = Bundle.main.resourcePath! + "/" + "Assets_Root/" + bookName + "/" + "AudioFiles/" + currentPage.id.components(separatedBy: "-")[0] + "/" + String(format: "%03d", currentPage.index + 1) + ".wav"
//        print("Audio file path: \(audioFilePath)")
        self.audioHandler?.filePath = audioFilePath
        self.audioHandler?.playAudio()
    }
    
    private func manuallyPauseAudio() {
        self.audioHandler?.isManuallyPaused = true
        self.audioHandler?.myAudioPlayer.stop()
    }
    
    // MARK: - Button action functions
    
    @objc private func onClickBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func onClickAutoplayAndStopButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "custom_stop_btn") {
            // Handle Pause Event
            sender.setImage(UIImage(named: "custom_autoplay_btn"), for: .normal)
            self.pauseAndResumeButton.isHidden = true
            self.manuallyPauseAudio()
        }
        else {
            // Handle Play Event
            sender.setImage(UIImage(named: "custom_stop_btn"), for: .normal)
            self.audioHandler?.isManuallyPaused = false
            self.pauseAndResumeButton.isHidden = false
            self.pauseAndResumeButton.setImage(UIImage(named: "custom_pause_btn"), for: .normal)
            self.playAudio()
        }
    }
    
    @objc private func onClickPauseAndResumeButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "custom_pause_btn") {
            // Handle Pause Event
            sender.setImage(UIImage(named: "custom_play_btn"), for: .normal)
            self.audioHandler?.myAudioPlayer.pause()
        }
        else {
            // Handle Play Event
            sender.setImage(UIImage(named: "custom_pause_btn"), for: .normal)
            self.audioHandler?.myAudioPlayer.play()
        }
    }
    // MARK: - Handle Keyboard Inputs
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else { return }
        
        switch key.keyCode {
        case .keyboardSpacebar:
            self.autoPlayAndStopButton.sendActions(for: .touchUpInside)
        case .keyboardLeftArrow:
            self.turnPageBackward()
        case .keyboardRightArrow:
            self.turnPageForward()
        case .keyboardEscape:
            self.navigationController?.popViewController(animated: true)

        default:
            super.pressesEnded(presses, with: event)
        }
    }
}

// MARK: - UIPageViewControllerDelegate Extension

extension ReadingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if completed {
                playAudio()
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource Extension

extension ReadingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pagevc = viewController as? PageViewController
        
        guard var currentIndex = pagevc?.index else {
            return nil
        }
        
        if currentIndex == 0 {
            currentIndex = totalSentenceCount - 1
        } else {
            currentIndex -= 1
        }
        
        if let x = self.audioHandler?.myAudioPlayer, !x.isPlaying {
            self.pauseAndResumeButton.setImage(UIImage(named: "custom_pause_btn"), for: .normal)
        }

        return getPageViewController(at: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pagevc = viewController as? PageViewController
        
        guard var currentIndex = pagevc?.index else {
            return nil
        }
        
        if currentIndex == totalSentenceCount - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        
        if let x = self.audioHandler?.myAudioPlayer, !x.isPlaying {
            self.pauseAndResumeButton.setImage(UIImage(named: "custom_pause_btn"), for: .normal)
        }
        
        return getPageViewController(at: currentIndex)
    }
    
}

// MARK: - Page turn trigger functions

extension ReadingViewController {
    func turnPageForward() {
        let pagevc = pageViewController.viewControllers?[0] as! PageViewController
        
        var currentIndex = pagevc.index
        
        if currentIndex == totalSentenceCount - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        
        let page = getPageViewController(at: currentIndex)
        self.pageViewController.setViewControllers([page], direction: .forward, animated: self.animatePageTransition)
        self.playAudio()
    }
    
    func turnPageBackward() {
        let pagevc = pageViewController.viewControllers?[0] as! PageViewController
        var currentIndex = pagevc.index
        
        if currentIndex == 0 {
            currentIndex = self.totalSentenceCount - 1
        } else {
            currentIndex -= 1
        }
        
        let page = getPageViewController(at: currentIndex)
        self.pageViewController.setViewControllers([page], direction: .reverse, animated: self.animatePageTransition)
        
        self.playAudio()
    }
    
}
