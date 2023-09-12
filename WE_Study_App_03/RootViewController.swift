//
//  ViewController.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2023/9/7.
//

import UIKit

class RootViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = .orange
        scrollView.addSubview(buttonsVerticalStackView)
        return scrollView
        
    }()

    private lazy var buttonsVerticalStackView: UIStackView = {
        let buttonsVerticalStackView = UIStackView()
        buttonsVerticalStackView.axis = .vertical
        buttonsVerticalStackView.distribution = .fillEqually  // Filling equally vertically
        buttonsVerticalStackView.spacing = 32
        buttonsVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonTextFromAssetsFolderNames = Utils.getDirectoriesUnder(s: "Assets_Root/")
        let btnSizeMultiplier = 1.0/3
        
        var idx = 0
        for row in 0..<(buttonTextFromAssetsFolderNames.count + 1)/2{
            let rowStack = UIStackView()
//            rowStack.backgroundColor = .purple
            rowStack.distribution = .equalSpacing // Filling equally horizontally
            buttonsVerticalStackView.addArrangedSubview(rowStack)
            rowStack.heightAnchor.constraint(equalTo: buttonsVerticalStackView.widthAnchor, multiplier: 0.2).isActive = true

            let leadingSpacer = UIView()
//            leadingSpacer.backgroundColor = .red
            let trailingSpacer = UIView()
//            trailingSpacer.backgroundColor = .cyan

            rowStack.addArrangedSubview(leadingSpacer)

            for col in 0..<2 {
                if idx >= buttonTextFromAssetsFolderNames.count {
                    break
                }
                let btn = UIButton()

//                var config = UIButton.Configuration.filled()
//                config.title = buttonTextFromAssetsFolderNames[idx]
//                idx += 1
//                config.titleTextAttributesTransformer =
//                UIConfigurationTextAttributesTransformer { incoming in
//                    var outgoing = incoming
//                    outgoing.font = UIFont.systemFont(ofSize: 100)
//                    return outgoing
//                }
//                config.baseForegroundColor = .systemPink
//                config.baseBackgroundColor = .gray
//                config.cornerStyle = .capsule
//
//                btn.configuration = config
                
                btn.setTitle("📚" + buttonTextFromAssetsFolderNames[idx], for: .normal)
                btn.backgroundColor = .black
                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                btn.titleLabel?.font = UIFont(name: "Marker Felt Wide", size: 100)
                btn.titleLabel?.minimumScaleFactor = 0.1
                btn.titleLabel?.lineBreakMode = .byClipping
                btn.titleLabel?.numberOfLines = 1
                btn.titleLabel?.baselineAdjustment = .alignCenters

                btn.layer.cornerRadius = 100
                btn.addTarget(self, action: #selector(onClickBookNameButton), for: .touchUpInside)
                btn.translatesAutoresizingMaskIntoConstraints = false
                rowStack.addArrangedSubview(btn)
                NSLayoutConstraint.activate([
                    btn.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: btnSizeMultiplier),
                    btn.heightAnchor.constraint(equalTo: rowStack.heightAnchor),
                ])
                
                // If it's the left button
                if idx % 2 == 0 {
                    // If it's the last button, we stop adding spacers
                    if idx == buttonTextFromAssetsFolderNames.count - 1 {
                        break
                    }
                    else {
                        let middleSpacer = UIView()
//                        middleSpacer.backgroundColor = .green
                        rowStack.addArrangedSubview(middleSpacer)
                        middleSpacer.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: (1 - 2 * btnSizeMultiplier) / 3 - 0.1).isActive = true
                    }
                }
                idx += 1
            }

            // The -0.1 is here so that the total width of all the elements does not exceed the width of the row
            // because of rounding errors the width does not add up to exactly the same amount as the width of the row
            rowStack.addArrangedSubview(trailingSpacer)
            leadingSpacer.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: (1 - 2 * btnSizeMultiplier) / 3 - 0.1).isActive = true
            trailingSpacer.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: (1 - 2 * btnSizeMultiplier) / 3 - 0.1).isActive = true

        }
        return buttonsVerticalStackView
    }()
    
    override func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .yellow
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            buttonsVerticalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 8.0),
            buttonsVerticalStackView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 8.0),
            buttonsVerticalStackView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor, constant: -8.0),
            buttonsVerticalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -8.0),
            buttonsVerticalStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16)
        ])
    }
    
    
    // MARK: Button touch selector functions
    @objc private func onClickBookNameButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            sender.backgroundColor = UIColor.red
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                sender.backgroundColor = UIColor.systemBlue
            }
        }
    }
    
}

