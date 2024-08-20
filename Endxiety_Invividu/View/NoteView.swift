//
//  NoteView.swift
//  Endxiety_Invividu
//
//  Created by Ali Haidar on 19/07/24.
//

import SwiftUI

struct NoteView: View {
    
    @State private var maskTimer: Float = 0.0
    @State var timer: Timer?
    @State var gradientSpeed: Float = 0.03
    
    @State var sheetOpen: Bool = false
    
//    @State private var notes: String = ""
    @FocusState var keyboardFocused
    
    @State private var selectedEmojiIndex: Int? = nil
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @Binding var note: Note
    
    var arrEmoji = ["SuperAnxious", "Anxious", "Annoyed", "Tense", "Calm"]
    var arrQuestions = ["🤔 How am i feel right now?", "🕹️ Is there something specific that might have caused this emotion?", "😔 If I'm feeling a bit down, is there something I could do to feel a bit better?", "🧑 Is there someone I can ask for support right now? Why and how? ", "😌 What insights can I learned from experiencing this emotion?"]
    
    var body: some View {
        
        let (_, dayOfMonth, monthYear, dayOfWeek) = getDateInfo()
        
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
                
                if selectedEmojiIndex != nil && note.content != "" {
                    Button {
                        
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
                    } label: {
                        Text(LocalizedStringResource("Save"))
                            .foregroundStyle(Color("BackgroundPrimary"))
                            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                            .background(Capsule().foregroundStyle(Color("PrimaryBlue")))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }.padding().background(.thickMaterial)
            
            HStack(alignment: .bottom) {
                Text(dayOfMonth)
                    .bold()
                    .font(.title2)
                    .underline(true, color: Color("PrimaryBlue"))
                Text(monthYear)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                
                Text(dayOfWeek)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding()
            
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
            
            TextEditor(text: $note.content)
                .scrollContentBackground(.hidden)
                .focused($keyboardFocused)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        keyboardFocused = true
                    }
                }
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            
            Spacer()
            
            ScrollView(.horizontal) {
                HStack {
                    Button {
                        sheetOpen = true
                    } label: {
                        Text(LocalizedStringResource("Help me start"))
                            .foregroundStyle(.white)
                            .bold()
                            .frame(height: 12)
                            .padding()
                            .background(MeshGradientView(maskTimer: $maskTimer, gradientSpeed: $gradientSpeed)
                                .scaleEffect(1.3)
                                .opacity(1.0)
                                .clipShape(Capsule()))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack(spacing: 15) {
                        Text("Title")
                            .font(.headline)
                            .bold()
                        
                        Divider()
                        
                        Text("Heading")
                            .font(.subheadline)
                        
                        Divider()
                        
                        Text("Body")
                        Divider()
                        Button(action: {
                        }) {
                            Image(systemName: "bold")
                        }
                        Divider()
                        Button(action: {
                        }) {
                            Image(systemName: "underline")
                        }
                        Divider()
                        Button(action: {
                        }) {
                            Image(systemName: "italic")
                        }
                    }
                    .foregroundStyle(.background)
                    .buttonStyle(.plain)
                    .frame(height: 12)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 25).foregroundStyle(Color("PrimaryBlue")))
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .padding(.bottom)
            
        }
        .background(Color("NotesBackground"))
        .sheet(isPresented: $sheetOpen, content: {
            VStack(alignment: .leading){
                Text(LocalizedStringResource("Questions"))
                    .font(.largeTitle)
                    .bold()
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 15){
                        ForEach (0..<arrQuestions.count, id: \.self) { index in
                            Text(LocalizedStringResource(stringLiteral: arrQuestions[index]))
                                .multilineTextAlignment(.leading)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 2))
                                .onTapGesture {
                                    withAnimation{
                                        note.content = note.content + "\n" + arrQuestions[index] + "\n"
                                        sheetOpen = false
                                    }
                                }
                        }
                    }
                }
                
                Spacer()
            }.padding()
        })
        //        .toolbar {
        //            Button {
        //
        //            } label: {
        //                Text("Save")
        //                    .foregroundStyle(Color("BackgroundPrimary"))
        //                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
        //                    .background(Capsule().foregroundStyle(Color("PrimaryBlue")))
        //            }
        //            .buttonStyle(PlainButtonStyle())
        //        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                DispatchQueue.main.async {
                    maskTimer += 0.03
                }
            }
        }
    }
    
    func getDateInfo() -> (Date, String, String, String) {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "d"
        let formattedDate = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MMM yyyy"
        let monthYear = dateFormatter.string(from: date)
        
        let dayOfWeek = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        
        return (date, formattedDate, monthYear, dayOfWeek)
    }
    
    
}


//#Preview {
//    NoteView()
//}
