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
        let url = URL(fileURLWithPath: filePath.split(separator: ".").dropLast().joined(separator: ".") + ".mp3")
        do {
            myAudioPlayer = try AVAudioPlayer(contentsOf: url)
            myAudioPlayer.delegate = self
            myAudioPlayer.numberOfLoops = loopNumberSetting
            myAudioPlayer.play()
        } catch {
//            print("Error, failed to load mp3 at url: \(url). Trying to find wav file...")
            let url = URL(fileURLWithPath: filePath.split(separator: ".").dropLast().joined(separator: ".") + ".wav")
                do {
                    myAudioPlayer = try AVAudioPlayer(contentsOf: url)
                    myAudioPlayer.delegate = self
                    myAudioPlayer.numberOfLoops = 0
                    myAudioPlayer.play()
                    myAudioPlayer.numberOfLoops = loopNumberSetting
                } catch {
//                    print("Error, failed to load wav at url: \(url), playing blank.mp3")
                    let url = URL(fileURLWithPath: Bundle.main.resourcePath! + "/" + "blank.mp3")
                    do {
                        myAudioPlayer = try AVAudioPlayer(contentsOf: url)
                        myAudioPlayer.delegate = self
                        myAudioPlayer.numberOfLoops = 0
                        myAudioPlayer.play()
                        myAudioPlayer.numberOfLoops = loopNumberSetting
                    } catch {
//                        print("failed to play blank.mp3, stopping...")
                        myAudioPlayer.stop()
                    }
                    
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
