//
//  RecordVoiceView.swift
//  Endxiety_Invividu
//
//  Created by Ali Haidar on 19/07/24.
//

import SwiftUI

struct RecordVoiceView: View {
    
    @StateObject var viewModel = VoiceViewModel()
    @State private var isRecording = false
    @State private var recordedURL: URL?
    
    
    // Ripple animation vars
    @State var counter: Int = 0
    @State var origin: CGPoint = .init(x: 0.5, y: 0.5)
    
    // Gradient and masking vars
    @State var gradientSpeed: Float = 0.03
    @State var timer: Timer?
    @State private var maskTimer: Float = 0.0
    
    
    @Binding var note: Note
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Colorful animated gradient
                MeshGradientView(maskTimer: $maskTimer, gradientSpeed: $gradientSpeed)
                    .scaleEffect(1.3) // avoids clipping
                    .opacity(containerOpacity)
                
                // Brightness rim on edges
                if isRecording {
                    RoundedRectangle(cornerRadius: 52, style: .continuous)
                        .stroke(Color.white, style: .init(lineWidth: 4))
                        .blur(radius: 4)
                }
                
                // Phone background mock, includes button
                SiriBackground(viewModel: viewModel, note: $note, isRecording: $isRecording, origin: $origin, counter: $counter, recordedURL: $recordedURL)
                    .mask {
                        AnimatedRectangle(size: geometry.size, cornerRadius: 48, t: CGFloat(maskTimer))
                            .scaleEffect(computedScale)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .blur(radius: animatedMaskBlur)
                    }.onTapGesture {
                        
                    }
            }
        }
        .ignoresSafeArea()
        .modifier(RippleEffect(at: origin, trigger: counter))
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                DispatchQueue.main.async {
                    maskTimer += rectangleSpeed
                }
            }
            
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    
    private var computedScale: CGFloat {
        return isRecording ? 1.0 : 1.2
        
    }
    
    private var rectangleSpeed: Float {
        return isRecording ? 0.03 : 0
    }
    
    private var animatedMaskBlur: CGFloat {
        return isRecording ? 28 : 8
    }
    
    private var containerOpacity: CGFloat {
        return isRecording ? 1.0 : 0
    }
}

//#Preview {
//    RecordVoiceView()
//}

struct SiriBackground: View {
    @ObservedObject var viewModel: VoiceViewModel
    @Binding var note: Note
    @Binding var isRecording: Bool
    @Binding var origin: CGPoint
    @Binding var counter: Int
    @Binding var recordedURL: URL?
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var selectedEmojiIndex: Int? = nil
    
    var arrEmoji = ["SuperAnxious", "Anxious", "Annoyed", "Tense", "Calm"]
    
    private var scrimOpacity: Double {
        return isRecording ? 0.3 : 0
        
    }
    
    private var iconName: String {
        return isRecording ? "stop.fill" : "mic"
        
    }
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(Color.black)
                .opacity(scrimOpacity)
                .scaleEffect(1.2) // avoids clipping
            
            VStack {
                
                welcomeText
                
                Spacer()
                if selectedEmojiIndex != nil{
                    siriButtonView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .onPressingChanged { point in
                if let point {
                    origin = point
                    counter += 1
                }
            }
            .padding(.bottom, 64)
        }.background(Color("NotesBackground"))
    }
    
    @ViewBuilder
    private var welcomeText: some View {
        if isRecording {
            VStack {
                Spacer()
                Text(LocalizedStringResource("Let it all out"))
                    .bold()
                    .font(.largeTitle)
                Text(LocalizedStringResource("Share your heart's whispers."))
                    .bold()
                    .font(.title3)
                Spacer()
            }
            .foregroundStyle(.white)
            
        }else{
            VStack {
                
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Text(LocalizedStringResource("Cancel"))
                            .foregroundStyle(Color("PrimaryBlue"))
                            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                }.padding().background(.thickMaterial)
                
                Spacer()
                
                Text(LocalizedStringResource("Share your feelings"))
                    .bold()
                    .font(.largeTitle)
                Text(LocalizedStringResource("Tell us what's on your mind."))
                    .bold()
                    .font(.title3)
                if isRecording {
                    Text(LocalizedStringResource("Recording..."))
                        .font(.headline)
                        .foregroundColor(.red)
                } else if let url = recordedURL {
                    Text(LocalizedStringResource("Recording stopped at:"))
                        .font(.headline)
                    Text(url.absoluteString)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                } else {
                    Text(LocalizedStringResource("Tap 'Mic' to Record"))
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                HStack(spacing: 15) {
                    ForEach (0..<arrEmoji.count, id: \.self) { index in
                        Image(arrEmoji[index])
                            .resizable()
                            .frame(width: selectedEmojiIndex == index ? 40 : 50, height: selectedEmojiIndex == index ? 40 : 50)
                            .overlay(
                                Circle()
                                    .stroke(Color("PrimaryBlue"), lineWidth: selectedEmojiIndex == index ? 5 : 0)
                            )
                            .onTapGesture {
                                withAnimation{
                                    if selectedEmojiIndex == index {
                                        selectedEmojiIndex = nil
                                    } else {
                                        selectedEmojiIndex = index
                                    }
                                }
                            }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .foregroundStyle(Color("LabelPrimary"))
        }
    }
    
    private var siriButtonView: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.9)) {
                if isRecording {
                    recordedURL = viewModel.stopRecording()
                    note.fileURL = (recordedURL)!
                    switch selectedEmojiIndex{
                    case 0:
                        note.emotion = "SuperAnxious"
                    case 1:
                        note.emotion = "Anxious"
                    case 2:
                        note.emotion = "Annoyed"
                    case 3:
                        note.emotion = "Tense"
                    case 4:
                        note.emotion = "Calm"
                    default:
                        break
                    }
                    note.editedAt = Date.now
                    context.insert(note)
                    
                    dismiss()
                } else {
                    viewModel.startRecording()
                }
                isRecording.toggle()
            }
        } label: {
            Image(systemName: iconName)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: 96, height: 96)
                .foregroundStyle(Color.white)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .background(
                    Circle()
                        .fill(Color.red)
                )
        }
    }
}

