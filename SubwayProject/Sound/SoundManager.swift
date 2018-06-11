//
//  SoundManager.swift
//  SubwayProject
//
//  Created by kpugame on 2018. 6. 11..
//  Copyright © 2018년 Subin Kang. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager{
    static let Instance = SoundManager()
    
    var AddSound = AVAudioPlayer()
    var RemoveSound = AVAudioPlayer()

    private init(){
        var SoundPath = Bundle.main.path(forResource: "Bookmark", ofType: "wav")
        do {
            AddSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: SoundPath!))
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
            print(error)
        }
        
        SoundPath = Bundle.main.path(forResource: "Trashcan", ofType: "wav")
        do {
            RemoveSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: SoundPath!))
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
            print(error)
        }
        
    }
    
    func PlaySound(type : Int){
        if (type == 1){
            AddSound.play()
        }
        else if (type == 0){
            RemoveSound.volume = 3
            RemoveSound.play()        }
    }
    
}
