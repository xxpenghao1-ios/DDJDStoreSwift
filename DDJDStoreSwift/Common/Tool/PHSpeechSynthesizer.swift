//
//  PHSpeechSynthesizer.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/26.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import AVFoundation

///文字转语音
class PHSpeechSynthesizer:NSObject{

    private let avSpeech = AVSpeechSynthesizer()

    ///创建需要合成的声音类型 中文
    private let voice=AVSpeechSynthesisVoice(language: "zh-CN")


    override init() {
        super.init()
        avSpeech.delegate=self
    }
    ///开始播放声音
    func startPlayVoice(str:String){
        //2. 创建合成的语音类
        let utterance = AVSpeechUtterance(string:str)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.voice = voice
        utterance.volume = 1
        utterance.postUtteranceDelay = 0.1
        utterance.pitchMultiplier = 1
        if !avSpeech.isSpeaking{///如果没有播放语音
            ///开始播放
            avSpeech.speak(utterance)
        }
    }
}
extension PHSpeechSynthesizer:AVSpeechSynthesizerDelegate{

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("开始播放")
    }
    ///播放完成
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("暂停播放")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        print("继续播放")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("取消播放")
    }
    //将要播放某一段话
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {

    }
}
