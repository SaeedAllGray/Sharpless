//
//  TypeView.swift
//  Sharpless
//
//  Created by saeed on 10/27/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct TypeView: View {
    @State private var text: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        VStack  {
            
            TextField ("Type something",text: $text)
                .padding()
            Spacer()
            HStack (spacing: 50) {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right.circle")
                        .font(.system(size: 40))
                }
                Button {
                    
                } label: {
                    Image(systemName: "mic.circle.fill")
                        .font(.system(size: 60))
                }
                Button {
                    
                } label: {
                    Image(systemName: "play.circle")
                        .font(.system(size: 40))
                }
            }
            .padding()
        }
        .accentColor(.mint)
        
    }
}

@available(iOS 15.0, *)
struct TypeView_Previews: PreviewProvider {
    static var previews: some View {
        TypeView()
    }
}
