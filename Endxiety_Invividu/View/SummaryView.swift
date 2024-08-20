//
//  SummaryView.swift
//  Endxiety_Invividu
//
//  Created by Ali Haidar on 19/07/24.
//

import SwiftUI

struct SummaryView: View {
    
    struct EmojiItem {
        let id: Double
        let imageName: String
        let color: Color
    }
    
    let arrEmoji: [EmojiItem] = [
        EmojiItem(id: 15.0, imageName: "SuperAnxious", color: .red),
        EmojiItem(id: 10.0, imageName: "Anxious", color: .orange),
        EmojiItem(id: 8.0, imageName: "Annoyed", color: .green),
        EmojiItem(id: 3.0, imageName: "Tense", color: .teal),
        EmojiItem(id: 4.0, imageName: "Calm", color: .blue)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringResource("My Summaries"))
                .font(.largeTitle)
                .bold()
                .padding()
            ZStack(alignment: .bottom){
                Image("bg_chart")
                    .resizable()
                
                HStack(alignment: .bottom){
                    ForEach(arrEmoji, id: \.id) { emoji in
                        VStack {
                            Image(emoji.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(.bottom, -20)
                                .zIndex(1)
                            Rectangle()
                                .fill(emoji.color)
                                .frame(width: 30, height:  emoji.id * 10)
                        }
                    }
                }
                
            }.padding()
                .frame(width: UIScreen.main.bounds.width - 55, height: UIScreen.main.bounds.width / 1.5)
                .background(RoundedRectangle(cornerRadius: 25).foregroundStyle(Color("NotesBackground")).shadow(color: .black.opacity(0.1), radius: 5, x: 1, y: 1))
                .padding()
            
            VStack(alignment: .leading){
                ForEach(arrEmoji, id: \.id) { emoji in
                    HStack {
                        Image(emoji.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(LocalizedStringResource(stringLiteral: emoji.imageName))
                            .frame(width: 120, alignment: .leading)
                        
                        Text(String(format: "%.0f", emoji.id))
                            .bold()
                            
                    }
                }
            }.padding()
            Spacer()
        }
        
    }
}

#Preview {
    SummaryView()
}
