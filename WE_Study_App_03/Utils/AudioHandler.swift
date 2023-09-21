//
//  AudioHandler.swift
//  PDF_Reader_UIKit
//
//  Created by Xingzhe Xin on 2022/12/7.
//

import Foundation
import AVFoundation
import UIKit

class AudioHandler: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var sender = UIViewController()
    var myAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    var filePath: String = ""
    var loopNumberSetting: Int = 0
    var isManuallyPaused = false
    
    override init() {
        super.init()
    }
    
    func playAudio() {
        if self.isManuallyPaused {
            return
        }
        let url = URL(fileURLWithPath: filePath)
        do {
            myAudioPlayer = try AVAudioPlayer(contentsOf: url)
            myAudioPlayer.delegate = self
            myAudioPlayer.numberOfLoops = loopNumberSetting
            myAudioPlayer.play()
        } catch {
            print("Error, failed to load wav at url: \(url). Playing Blank Audio")
            if let url = Bundle.main.url(forResource: "blank", withExtension: "mp3") {
                do {
                    myAudioPlayer = try AVAudioPlayer(contentsOf: url)
                    myAudioPlayer.delegate = self
                    myAudioPlayer.numberOfLoops = 0
                    myAudioPlayer.play()
                    myAudioPlayer.numberOfLoops = loopNumberSetting
                } catch {
                    print("Error, failed to load blank.mp3 at url: \(url).")
                    myAudioPlayer.stop()
                }
            }
            else {
                print("Can't find blank audio file.")
                return
            }
        }
    }
    
    func restartPlaying() {
        self.myAudioPlayer.stop()
        self.playAudio()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let vc = self.sender as! ReadingViewController
        vc.turnPageForward()
    }
}
