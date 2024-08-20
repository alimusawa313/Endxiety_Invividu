//
//  CalendarItemView.swift
//  Endxiety
//
//  Created by Ali Haidar on 17/07/24.
//

import SwiftUI

struct CalendarItemView: View {
    @State private var color: Color = .blue
    @State private var date = Date.now
    @State private var selectedDate: Date? = nil
    @Binding var selected: Date
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
    var body: some View {
        VStack {
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.bold)
                        .foregroundStyle(index == 0 ? .red : .primary)
                        .frame(maxWidth: .infinity)
                }
            }
            Divider()
                .overlay(.labelPrimary)
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        Text(day.formatted(.dateTime.day()))
                        //                            .fontWeight(.bold)
                            .foregroundStyle(
                                Date.now.startOfDay == day.startOfDay
                                ? Color("BackgroundPrimary").opacity(1)
                                :  Color("LabelPrimary").opacity(1))
                        
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(
                                        Date.now.startOfDay == day.startOfDay
                                        ? Color("PrimaryBlue").opacity(1)
                                        :  (selectedDate == day ? .primaryBlue.opacity(1) : .primaryBlue.opacity(0))
                                    )
                            )
                            .onTapGesture {
                                selectedDate = day
                                selected = day
                                print(day)
                            }
                    }
                }
            }
            
            DatePicker("", selection: $date, in: ...Date.now, displayedComponents: .date)
                .padding()
        }
        .padding()
        .onAppear {
            days = date.calendarDisplayDays
        }
        .onChange(of: date) {
            days = date.calendarDisplayDays
        }
    }
    
}



//#Preview {
//    CalendarItemView()
//}
