//
//  ENZHView.swift
//  WE_Study_App_03
//
//  Created by Xingzhe Xin on 2024/1/8.
//

import SwiftUI



struct ENZHView: View {
    let ENText: String
    let ZHText: String
    let displayMode: ENZHDisplayMode
    let defaultEnglishFontSize = 120.0
    
    var body: some View {
        switch displayMode {
        case .EnglishOnly:
            Text(ENText)
                .font(.custom("Times New Roman", size: defaultEnglishFontSize))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.leading)
        case .ChinesesOnly:
            Text(ZHText)
                .font(.custom("FangSong", size: defaultEnglishFontSize))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.leading)
        case .EnglishAndChinese:
            VStack {
                Text(ENText)
                    .font(.custom("Times New Roman", size: defaultEnglishFontSize))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.01)
                    .multilineTextAlignment(.leading)
                    .padding(100)
                Text(ZHText)
                    .font(.custom("Times New Roman", size: 30))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.01)
                    .multilineTextAlignment(.leading)
            }
        default:
            Text("")
        }
    }
}
