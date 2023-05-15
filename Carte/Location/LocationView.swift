//
//  LocationView.swift
//  Carte
//
//  Created by Guillaume Genest on 15/05/2023.
//

import Foundation

import SwiftUI

struct CustomPinView: View {
    let SymbolAnnotation: String
    let color: Color
    var body: some View {
           VStack(spacing: 0) {
               Image(systemName: SymbolAnnotation)
                   .resizable()
                   .scaledToFit()
                   .frame(width: 20, height: 20)
                   .font(.headline)
                   .foregroundColor(.white)
                   .padding(6)
                   .background(color)
                   .clipShape(Circle())
               Image(systemName: "triangle.fill")
                   .resizable()
                   .scaledToFit()
                   .foregroundColor(.black)
                   .frame(width: 10, height: 10)
                   .rotationEffect(Angle(degrees: 180))
                   .offset(y: -1.5)
                   .padding(.bottom, 40)
           }
    }
}

struct CustomPinView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CustomPinView(SymbolAnnotation: "fork.knife", color: .red)
            CustomPinView(SymbolAnnotation: "house.fill", color: .blue)
        }
    }
}

