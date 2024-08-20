//
//  text.swift
//  Endxiety_Invividu
//
//  Created by Ali Haidar on 19/07/24.
//

import SwiftUI

//struct text: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

import SwiftUI

struct Test: View {
    @State private var isShowingButtons = false

    var body: some View {
        ZStack{
            MainButton()
        }
    }
}


#Preview {
    Test()
}

import SwiftUI

struct MainButton: View {
    @State private var showAdditionalButtons = false

    var body: some View {
        Button(action: {
            
        }) {
            Image(systemName: "plus")
                .font(.title)
                .padding()
                .foregroundColor(Color("BackgroundPrimary"))
                .background(Circle().foregroundColor(Color("PrimaryBlue")))
                .clipShape(Circle())
                .buttonStyle(PlainButtonStyle())
        }
    }
}

