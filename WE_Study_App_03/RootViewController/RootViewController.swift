//
//  ViewController.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2023/9/7.
//

import UIKit

class RootViewController: UIViewController {
    
    let imageNames = ["240479", "240842", "243760", "247744", "249678", "251826", "252192", "253312", "280845", "294643", "304368"]
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        if let randomImageName = imageNames.randomElement(),
           let image = UIImage(named: randomImageName) {
            imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
        }
        imageView.contentMode = .center
        imageView.frame = self.view.bounds
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.addSubview(buttonsVerticalStackView)
        return scrollView
    }()
    
    private lazy var buttonsVerticalStackView: UIStackView = {
        let buttonsVerticalStackView = UIStackView()
        buttonsVerticalStackView.axis = .vertical
        buttonsVerticalStackView.distribution = .fillEqually  // Filling equally vertically
        buttonsVerticalStackView.spacing = 32
        buttonsVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonTextFromAssetsFolderNames = Utils.getSortedDirectories(in: "Assets_Root/")
        let btnSizeMultiplier = 1.0 / 3
        
        var idx = 0
        for row in 0..<(buttonTextFromAssetsFolderNames.count + 1)/2 {
            let rowStack = UIStackView()
            rowStack.distribution = .equalSpacing // Filling equally horizontally
            buttonsVerticalStackView.addArrangedSubview(rowStack)
            rowStack.heightAnchor.constraint(equalTo: buttonsVerticalStackView.widthAnchor, multiplier: 0.2).isActive = true

            let leadingSpacer = UIView()
            let trailingSpacer = UIView()

            rowStack.addArrangedSubview(leadingSpacer)

            for col in 0..<2 {
                if idx == buttonTextFromAssetsFolderNames.count {
                    break
                }
                let btn = UIButton()

                // Set button properties
                btn.setTitle(nil, for: .normal) // Clear the plain title

                // Customize the stroke attributes
                let strokeTextAttributes: [NSAttributedString.Key: Any] = [
                    .strokeColor: UIColor.black, // Outline color (e.g., black)
                    .foregroundColor: UIColor.white, // Text color
                    .strokeWidth: -3.0, // Stroke width (negative means inside the text)
                    .font: UIFont(name: "Marker Felt Wide", size: 100) ?? UIFont.systemFont(ofSize: 100) // Use the custom font or fallback to system
                ]

                // Create an attributed string with the stroke effect and your text
                let attributedTitle = NSAttributedString(
                    string: "📚" + buttonTextFromAssetsFolderNames[idx],
                    attributes: strokeTextAttributes
                )

                // Set the attributed string as the button's title
                btn.setAttributedTitle(attributedTitle, for: .normal)

                // Ensure that the button clips content within its bounds
                btn.clipsToBounds = true

                // Set dynamic corner radius based on the button’s width/height to maintain a circular/rounded appearance
                btn.layer.cornerRadius = 25  // Change this to btn.layer.cornerRadius = btn.frame.height / 2 if you want a perfect round

                // Continue setting other properties
                btn.backgroundColor = UIColor.random()
                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                btn.titleLabel?.minimumScaleFactor = 0.01
                btn.titleLabel?.lineBreakMode = .byClipping
                btn.titleLabel?.numberOfLines = 1
                btn.titleLabel?.baselineAdjustment = .alignCenters

                btn.addTarget(self, action: #selector(onClickBookNameButton), for: .touchUpInside)
                btn.translatesAutoresizingMaskIntoConstraints = false
                rowStack.addArrangedSubview(btn)
                
                // Set dynamic size of the button
                NSLayoutConstraint.activate([
                    btn.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: btnSizeMultiplier),
                    btn.heightAnchor.constraint(equalTo: rowStack.heightAnchor),
                ])
                
                // Handle spacing
                if idx % 2 == 0 {
                    if idx == buttonTextFromAssetsFolderNames.count - 1 {
                        break
                    } else {
                        let middleSpacer = UIView()
                        rowStack.addArrangedSubview(middleSpacer)
                        middleSpacer.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: (1 - 2 * btnSizeMultiplier) / 3 - 0.1).isActive = true
                    }
                }
                idx += 1
            }

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
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        let originalColor = sender.backgroundColor
        
        UIView.animate(withDuration: 0.05) {
            sender.backgroundColor = UIColor.blue
        } completion: { _ in
            UIView.animate(withDuration: 0.05) {
                sender.backgroundColor = originalColor
            }
        }
        
        self.navigationController?.pushViewController(BookContentListView(bookName: sender.titleLabel?.text?.removingEmojis() ?? "nil"), animated: true)
    }
    
}

