//
//  ContentView.swift
//  Endxiety_Invividu
//
//  Created by Ali Haidar on 19/07/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query(sort: \Note.editedAt) var swiftDateNotes: [Note]
    @State var selectedNote: Note = Note(content: "", fileURL: URL(filePath: ""), emotion: "", isPlaying: false)
    @Environment(\.modelContext) var context
    
    @State var navToCalendar: Bool = false
    @State var navToNote: Bool = false
    @State var navToVoice: Bool = false
    @State var showCatgMenu: Bool = false
    @State var navToSummary: Bool = false
    
    @State private var isExpanded = false
    @State private var isXPressed = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                ScrollView {
                    VStack(alignment: .leading){
                        ZStack {
                            GeometryReader { geometry in
                                Image("main_landscape")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.width / 1.5)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.clear, Color("BackgroundPrimary")]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            }
                            .frame(height: UIScreen.main.bounds.width / 1.5)
                            .cornerRadius(10)
                            
                            VStack(alignment: .center) {
                                Text(LocalizedStringResource("\"\nRemember, Licking a doorknob is illegal on other planet\n\""))
                                    .italic()
                                Text("- Spongebob")
                                    .bold()
                            }
                            .shadow(color: .black, radius: 1, x: 0, y: 1)
                            .padding()
                            .foregroundStyle(.white)
                        }
                        .ignoresSafeArea()
                        
                        
                        Image("calm_emotion")
                            .resizable()
                            .padding()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 2)
                            .padding(.top, -30)
                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                        
                        
                        Text(LocalizedStringResource("My Note"))
                            .bold()
                            .font(.title2)
                            .padding(.leading)
                        
                        Text("2024")
                            .padding(.leading)
                            .foregroundStyle(.secondary)
                        
                        
                        
                        LazyVStack {
                            ForEach(swiftDateNotes.sorted(by: { $0.editedAt > $1.editedAt })) { note in
                                NoteItemRow(note: note)
                                    .onTapGesture {
                                        selectedNote = note
                                        navToNote = true
                                    }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            context.delete(note)
                                        } label: {
                                            Image(systemName: "trash")
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                        
                        Rectangle()
                            .foregroundStyle(.clear)
                            .frame(height: UIScreen.main.bounds.width / 2)
                        
                        
                        Spacer()
                    }
                }.background(Color("BackgroundPrimary"))
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    VStack{
                        Spacer()
                        
                        HStack(spacing: 50) {
                            Button(action: {
                                navToCalendar = true
                            }) {
                                Image(systemName: "calendar")
                                    .font(.headline)
                                    .padding()
                                    .foregroundColor(Color("PrimaryBlue"))
                                    .background(Circle().foregroundColor(Color("NotesBackground")))
                                    .clipShape(Circle())
                                    .buttonStyle(PlainButtonStyle())
                            }
                            
                            Button(action: {
                                selectedNote = Note(content: "", fileURL: URL(filePath: ""), emotion: "", isPlaying: false)
//                                    navToNote = true
                                showCatgMenu = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .padding()
                                    .foregroundColor(Color("BackgroundPrimary"))
                                    .background(Circle().foregroundColor(Color("PrimaryBlue")))
                                    .clipShape(Circle())
                                    .buttonStyle(PlainButtonStyle())
                            }
                            
                            Button(action: {
                                navToSummary = true
                            }) {
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.headline)
                                    .padding()
                                    .foregroundColor(Color("PrimaryBlue"))
                                    .background(Circle().foregroundColor(Color("NotesBackground")))
                                    .clipShape(Circle())
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }.shadow(color: .black.opacity(0.1), radius: 5, x: 1, y: 1)
                            .frame(width: geometry.size.width, height: 50)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(.clear), Color("BackgroundPrimary")]), startPoint: .top, endPoint: .bottom)
                            )
                    }
                }
            }
            .sheet(isPresented: $navToCalendar) {
                CalendarView(selectedNote: $selectedNote)
            }
            .sheet(isPresented: $navToNote) {
                NoteView(note: $selectedNote)
            }
            .sheet(isPresented: $navToVoice) {
                RecordVoiceView(note: $selectedNote)
//                VoiceRecordingView()
            }
            .sheet(isPresented: $navToSummary) {
                SummaryView()
//                VoiceRecordingView()
            }
            .sheet(isPresented: $showCatgMenu) {
                VStack{
                    Image("write_il")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 25, height: UIScreen.main.bounds.height / 4.5)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture {
                            showCatgMenu = false
                            navToNote = true
                        }
                    Image("record_il")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 25, height: UIScreen.main.bounds.height / 4.5)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture {
                            showCatgMenu = false
                            navToVoice = true
                        }
                }.presentationDetents([.medium])
            }
        }
    }
    
}


#Preview {
    ContentView()
}

