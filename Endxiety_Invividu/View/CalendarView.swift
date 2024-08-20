//
//  CalendarView.swift
//  Endxiety_Invividu
//
//  Created by Ali Haidar on 19/07/24.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var selectedDate: Date = Date.now
    @Query(sort: \Note.editedAt) var swiftDateNotes: [Note]
    
    
    @Binding var selectedNote: Note
    @Environment(\.modelContext) var context
    @State private var navigateToNewNote = false
    
    @ObservedObject var vm = VoiceViewModel()
    @State var showingSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading){
                CalendarItemView(selected: $selectedDate)
                
                
                let filteredNotes = swiftDateNotes.filter { $0.editedAt.startOfDay == selectedDate.startOfDay }
                
                LazyVStack {
                    ForEach(filteredNotes.sorted(by: { $0.editedAt > $1.editedAt })) { note in
                        NoteItemRow(note: note)
                            .onTapGesture {
                                selectedNote = note
                                showingSheet = true
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
                
                
                Spacer()
            }
        }.background(Color("BackgroundPrimary"))
        
        .sheet(isPresented: $showingSheet) {
            NoteView(note: $selectedNote)
        }
    }
}

//#Preview {
//    CalendarView()
//}
