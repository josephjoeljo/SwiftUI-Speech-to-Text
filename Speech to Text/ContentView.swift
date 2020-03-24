//
//  ContentView.swift
//  Speech to Text
//
//  Created by Joel Joseph on 3/22/20.
//  Copyright © 2020 Joel Joseph. All rights reserved.
//

import SwiftUI
import Speech


struct ContentView: View {
    @EnvironmentObject var swiftUISpeech:SwiftUISpeech
    
    var body: some View {
        VStack {
            VStack{
                Text("\(swiftUISpeech.outputText)")
                    .font(.title)
                    .bold()
                
            }.frame(width: 300,height: 400)
            
            VStack {// Speech button
                
                swiftUISpeech.getButton()
                
            }
            VStack{// status of Authority
                
                swiftUISpeech.showStatus()
                Spacer()
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SwiftUISpeech())
    }
}
