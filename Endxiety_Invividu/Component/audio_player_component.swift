//
//  audio_player_component.swift
//  Endxiety_Invividu
//
//  Created by Ali Haidar on 19/07/24.
//

import SwiftUI

struct audio_player_component: View {
    @ObservedObject var vm: VoiceViewModel
    var recording: Note
    var body: some View {
        HStack (alignment: .center){
            
            
            Button{
                if recording.isPlaying == true {
                    vm.stopPlaying(url: recording.fileURL)
                }else{
                    vm.startPlaying(url: recording.fileURL)
                }
                
            }label: {
                //                Image(systemName: "play.fill")
                Image(systemName: recording.isPlaying ? "stop.fill" : "play.fill")
            }
            .foregroundStyle(Color("LabelPrimary"))
            .buttonStyle(PlainButtonStyle())
            .font(.title)
            
            Slider(value: Binding<Double>(
                get: { vm.currentTime },
                set: { newValue in
                    vm.seek(to: TimeInterval(newValue))
                }
            ), in: 0.0...(vm.audioPlayer?.duration ?? 1.0)) //
            .padding(.horizontal)
            
            
        }
    }
}

//#Preview {
//    audio_player_component()
//}
