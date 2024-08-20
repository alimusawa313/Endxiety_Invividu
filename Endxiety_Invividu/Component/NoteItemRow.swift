//
//  NoteItemRow.swift
//  Endxiety_Invividu
//
//  Created by Ali Haidar on 19/07/24.
//

import SwiftUI

struct NoteItemRow: View {
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        return formatter.string(from: note.editedAt)
    }
    
    private var formattedDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: note.editedAt)
    }
    
    private var formattedMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: note.editedAt)
    }
    
    @StateObject var vm = VoiceViewModel()
    let note : Note
    var body: some View {
        HStack{
            VStack(alignment:.leading, spacing: 10){
                HStack(alignment: .bottom) {
                    Text(formattedDay)
                        .bold()
                        .font(.title2)
                        .underline(true, color: Color("PrimaryBlue"))
                    Text(LocalizedStringResource(stringLiteral: formattedMonth))
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                if note.content != ""{
                    Text(note.content)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }else{
                    audio_player_component(vm: vm, recording: note)
                }
                
                Text("Last edited \(formattedDate)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
            }
            Spacer()
            
            Image(note.emotion)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading)
            
        }.padding()
            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color("NotesBackground"))
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1))
            .padding(.horizontal)
    }
}
