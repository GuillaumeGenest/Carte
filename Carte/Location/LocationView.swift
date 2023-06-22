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

//
//  LocationPreviewView.swift
//  Sunny_road
//
//  Created by Guillaume Genest on 04/09/2022.
//

import SwiftUI

struct LocationPreviewView: View {
    @EnvironmentObject var search : SearchPointOfInterests
    var pointofinterest : PointOfInterest
    var body: some View {
    HStack(alignment: .bottom, spacing: 0) {
        VStack(alignment: .leading, spacing: 16) {
            titleSection
        }
        VStack(spacing: 8) {
            Enregistrement
            CancelButton
            }
        }
        .padding(20)
        .background(
        RoundedRectangle(cornerRadius: 10)
            .fill(.ultraThinMaterial)
            )
            .cornerRadius(10)
}
 
    
    
//    private var imageSection: some View {
//            VStack {
//                AsyncImage(url: URL(string: location.imageURL)) { phase in
//                    if let image = phase.image {
//                        image
//                            .renderingMode(.original)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 100, height: 100)
//                            .padding(.all, 8)
//                            .overlay(RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.white, lineWidth: 12)
//                            )
//                            .shadow(radius: 10)
//
//                    }
//                    else {
//                        Image(systemName: location.category.systemNameIcon)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100, height: 100)
//                            .padding(.all, 8)
//                            .foregroundColor(.white)
//                            .background(location.category.color)
//                                    .overlay(RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.white, lineWidth: 12)
//                                    )
//                                    .shadow(radius: 10)
//                    }
//                }
//
//            }
//            .cornerRadius(10)
//        }
    
    
    private var titleSection: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(pointofinterest.mapItem.name ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                Text(pointofinterest.mapItem.placemark.title ?? "")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    
    private var Enregistrement: some View {
        Button(action: {}, label: {
              Text("Enregistrement")
                .foregroundColor(Color.white)
                .font(.callout)
                .fontWeight(.semibold)
                .frame(width: 125, height: 35)
                .padding(8)
                .background(Color.orange)
                .cornerRadius(10)
          })
          //.background(Color.orange)
      }
    
    private var CancelButton: some View {
            Button {
                search.ShowInformationMapItem = false 
//                mapData.ShowDetailPlace.toggle()
            } label: {
                Text("Retour")
                    .foregroundColor(Color.orange)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(width: 125, height: 35)
                    .padding(8)
                    .background(.white)
                    .cornerRadius(10)
            }
        }
    
}









