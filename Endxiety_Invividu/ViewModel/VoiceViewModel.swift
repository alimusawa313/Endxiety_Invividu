//
//  VoiceViewModel.swift
//  NoteApp
//
//  Created by Ali Haidar on 15/07/24.
//

import Foundation
import AVFoundation

class VoiceViewModel : NSObject, ObservableObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    var timeR: Timer?
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    var indexOfPlayer = 0
    
    @Published var isRecording: Bool = false
    
    @Published var recordingsList = [Note]()
    
    @Published var countSec = 0
    @Published var timerCount: Timer?
    @Published var blinkingCount: Timer?
    @Published var timer: String = "0:00"
    @Published var toggleColor: Bool = false
    
    @Published var currentTime: TimeInterval = 0.0
    @Published var audioInputLevel: Float = 0.0
    
    var playingURL: URL?
    
    override init(){
        super.init()
        
        fetchAllRecording()
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == playingURL {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
    func startRecording() {
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Cannot setup the Recording")
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = path.appendingPathComponent("CO-Voice_\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.delegate = self  // Set the delegate to self
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
            isRecording = true
            
            timerCount = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.updateAudioInputLevel()
            }
            
            timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.countSec += 1
                self?.timer = self?.convertSecToMinAndHour(seconds: self?.countSec ?? 0) ?? "0:00"
            }
            
            blinkColor()
            
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    func pauseRecording() {
        audioRecorder.pause()
        isRecording = false
        timerCount?.invalidate()
        blinkingCount?.invalidate()
    }
    
    func unpauseRecording() {
        audioRecorder.record()
        isRecording = true
        timerCount = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateAudioInputLevel()
        }
        timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.countSec += 1
            self?.timer = self?.convertSecToMinAndHour(seconds: self?.countSec ?? 0) ?? "0:00"
        }
        blinkColor()
    }
    
    func stopRecording() -> URL? {
        
        audioRecorder.stop()
        isRecording = false
        
        timerCount?.invalidate()
        blinkingCount?.invalidate()
        
        return audioRecorder.url // Return the URL of the recorded audio file
    }
    
    func fetchAllRecording() {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        
        for i in directoryContents {
            recordingsList.append(Note(content: "", fileURL : i, emotion: "", editedAt: getFileDate(for: i), isPlaying: false))
        }
        
        recordingsList.sort(by: { $0.editedAt.compare($1.editedAt) == .orderedDescending})
    }
    
    func startPlaying(url: URL) {
        
        playingURL = url
        
        let playSession = AVAudioSession.sharedInstance()
        
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            timeR = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if let player = self.audioPlayer {
                    self.currentTime = player.currentTime
                }
            }
            
            for i in 0..<recordingsList.count {
                if recordingsList[i].fileURL == url {
                    recordingsList[i].isPlaying = true
                }
            }
            
        } catch {
            print("Playing Failed")
        }
    }
    
    func stopPlaying(url: URL) {
        
        audioPlayer?.stop()
        timeR?.invalidate()
        timeR = nil
        audioPlayer = nil
        
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == url {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    func deleteRecording(url: URL) {
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Can't delete")
        }
        
        for i in 0..<recordingsList.count {
            
            if recordingsList[i].fileURL == url {
                if recordingsList[i].isPlaying == true {
                    stopPlaying(url: recordingsList[i].fileURL)
                }
                recordingsList.remove(at: i)
                break
            }
        }
    }
    
    func blinkColor() {
        
        blinkingCount = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            self?.toggleColor.toggle()
        }
        
    }
    
    func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    func updateAudioInputLevel() {
        audioRecorder.updateMeters()
        let averagePower = audioRecorder.averagePower(forChannel: 0)
        audioInputLevel = pow(10, 0.05 * averagePower)
    }
    
    func convertSecToMinAndHour(seconds: Int) -> String {
        let min = (seconds / 60) % 60
        let hour = seconds / 3600
        let sec = seconds % 60
        return String(format: "%d:%02d:%02d", hour, min, sec)
    }
    
}
