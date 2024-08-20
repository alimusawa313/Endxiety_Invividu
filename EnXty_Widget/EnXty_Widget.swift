//
//  EnXty_Widget.swift
//  EnXty_Widget
//
//  Created by Ali Haidar on 19/07/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct EnXty_WidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                HStack {
                    Image(systemName: "square.and.pencil")
                    Text("Take a journal")
                }
                .font(.footnote)
                
                Image("Calm")
            }
//        case .systemLarge:
//            SummaryView()
        
            
        default:
            VStack {
                Text("Unsupported widget size")
                    .foregroundColor(.red)
            }
        }
    }
}

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
            
        
        
    }
}

struct EnXty_Widget: Widget {
    let kind: String = "EnXty_Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                EnXty_WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                EnXty_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Quick Journal")
        .description("Jump stright to journal")
        .supportedFamilies([.systemSmall])
        
    }
}

#Preview(as: .systemSmall) {
    EnXty_Widget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
