//
//  BannerModifier.swift
//  Sharpless
//
//  Created by Media Davarkhah on 9/24/1400 AP.
//

import SwiftUI

struct BannerModifier: ViewModifier {
    struct BannerData {
        var title:String
        var subtitle:String
        var type: BannerType
    }
    @Binding var data:BannerData
    @Binding var show:Bool
    func body(content: Content) -> some View {
        ZStack {
               if show {
                   VStack {
                       HStack {
                           VStack(alignment: .leading, spacing: 2) {
                               Text(data.title)
                                   .bold()
                                   .multilineTextAlignment(.center)
                               Text(data.subtitle)
                                   .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                                   .multilineTextAlignment(.center)
                           }
                           Spacer()
                       }
                       .foregroundColor(Color.white)
                       .padding(12)
                       .background(data.type.tintColor)
                       .cornerRadius(8)
                       Spacer()
                   }
               }
               content
           }
    }
}
extension View {
    func banner(data: Binding<BannerModifier.BannerData>, show: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(data: data, show: show))
    }
}


enum BannerType {
    case Info
    case Warning
    case Success
    case Error

    var tintColor: Color {
        switch self {
        case .Info:
            return Color(red: 67/255, green: 154/255, blue: 215/255)
        case .Success:
            return Color.green
        case .Warning:
            return Color.yellow
        case .Error:
            return Color.red
        }
    }
}
