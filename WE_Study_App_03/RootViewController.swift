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
        scrollView.backgroundColor = .orange
        scrollView.addSubview(buttonsVerticalStackView)
        return scrollView
        
    }()

    private lazy var buttonsVerticalStackView: UIStackView = {
        let buttonsVerticalStackView = UIStackView()
        buttonsVerticalStackView.axis = .vertical
        buttonsVerticalStackView.distribution = .fillEqually  // Filling equally vertically
        buttonsVerticalStackView.spacing = 32
        buttonsVerticalStackView.translatesAutoresizingMaskIntoConstraints = false


        for row in 0..<6 {
            let rowStack = UIStackView()
            rowStack.backgroundColor = .purple
            rowStack.distribution = .equalSpacing // Filling equally horizontally
            buttonsVerticalStackView.addArrangedSubview(rowStack)
            rowStack.heightAnchor.constraint(equalTo: buttonsVerticalStackView.widthAnchor, multiplier: 0.2).isActive = true

            let leadingSpacer = UIView()
            let trailingSpacer = UIView()

            rowStack.addArrangedSubview(leadingSpacer)

            for col in 0..<2 {
                let btn = UIButton()

                var config = UIButton.Configuration.filled()
                config.title = "Button"
                config.titleTextAttributesTransformer =
                UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = UIFont.systemFont(ofSize: 100)
                    return outgoing
                }
                config.baseForegroundColor = .systemPink
                config.baseBackgroundColor = .gray
                config.cornerStyle = .capsule

                btn.configuration = config

                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 100)
                btn.titleLabel?.minimumScaleFactor = 0.1
                btn.titleLabel?.lineBreakMode = .byClipping
                btn.titleLabel?.numberOfLines = 1
                btn.titleLabel?.baselineAdjustment = .alignCenters

                btn.translatesAutoresizingMaskIntoConstraints = false
                rowStack.addArrangedSubview(btn)
                NSLayoutConstraint.activate([
                    btn.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: 1/3),
                    btn.heightAnchor.constraint(equalTo: rowStack.heightAnchor),
                ])

                let middleSpacer = UIView()
                rowStack.addArrangedSubview(middleSpacer)
                middleSpacer.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: 1/9).isActive = true
            }

            rowStack.addArrangedSubview(trailingSpacer)
            leadingSpacer.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: 1/9).isActive = true
            trailingSpacer.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: 1/9).isActive = true

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
            buttonsVerticalStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -16)
        ])
    }
    
    
}

