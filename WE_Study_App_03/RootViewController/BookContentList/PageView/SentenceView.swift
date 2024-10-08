//
//  ENZHView.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2024/1/8.
//

import SwiftUI

struct SentenceView: View {
    let englishText: String
    let chineseText: String
    let speakerText: String
    let displayMode: SentenceDisplayModes
    let defaultEnglishFontSize = 100.0
    let defaultChineseFontSize = 30.0
    let defaultSpeakerFontSize = 40.0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if !speakerText.isEmpty {
                    HStack {
                        displayText(
                            speakerText, fontName: "Times New Roman",
                            baseFontSize: defaultSpeakerFontSize, color: .gray,
                            in: geometry.size)
                        Spacer()
                    }
                }

                switch displayMode {
                case .englishOnly:
                    displayText(
                        englishText, fontName: "Times New Roman",
                        baseFontSize: defaultEnglishFontSize, color: .white,
                        in: geometry.size)

                case .chineseOnly:
                    displayText(
                        chineseText, fontName: "FangSong",
                        baseFontSize: defaultChineseFontSize, color: .white,
                        in: geometry.size)

                case .englishAndChinese:
                    displayText(
                        englishText, fontName: "Times New Roman",
                        baseFontSize: defaultEnglishFontSize, color: .white,
                        in: geometry.size)
                    displayText(
                        chineseText, fontName: "FangSong",
                        baseFontSize: defaultChineseFontSize, color: .white,
                        in: geometry.size)

                case .blank:
                    EmptyView()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    // Reusable function to render text
    private func displayText(
        _ text: String, fontName: String, baseFontSize: Double, color: Color,
        in size: CGSize
    ) -> some View {
        Text(text).font(.custom(fontName, size: baseFontSize))
            .foregroundColor(color)
            .minimumScaleFactor(0.01)
            .multilineTextAlignment(.leading)
            .padding()
    }
}
