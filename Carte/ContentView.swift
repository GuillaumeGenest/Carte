//
//  ContentView.swift
//  Carte
//
//  Created by Guillaume Genest on 12/05/2023.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.861, longitude: 2.335833), latitudinalMeters: 20000, longitudinalMeters: 20000)
    let annotations = [
        Location(name: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)),
        Location(name: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)),
        Location(name: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)),
        Location(name: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667))
        ]
    
    
    
    
    
    
    var body: some View {
        VStack {
            
       Carte(coordinateRegion: $region, annotationItems: annotations,
             annotationContent: { location in
                 CarteAnnotation(coordinate: location.coordinate) {
               VStack(spacing: 0) {
                   Image(systemName: "house")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 20, height: 20)
                       .font(.headline)
                       .foregroundColor(.white)
                       .padding(6)
                       .background(.purple)
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
       }).ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
