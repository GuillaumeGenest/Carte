//
//  ContentView.swift
//  Carte
//
//  Created by Guillaume Genest on 12/05/2023.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @StateObject var search = SearchPointOfInterests()
    @State var ShowDetailPlaceAnnotation : PointOfInterest?
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.861, longitude: 2.335833), latitudinalMeters: 20000, longitudinalMeters: 20000)
    
//    @State var category : PointOfInterestType = .Historique
    
    
    @State private var ShowInformationMapItem : Bool = false
    @State private var ShowListPointOfInterest : Bool = false
    @State private var ShowPointOfInterestMarker : Bool = false
    @State private var pointsOfInterest: [MKMapFeatureAnnotation] = []
    
    @State private var polylineCoordinates: [CLLocationCoordinate2D] = []
    @State private var userTrackingMode = UserTrackingMode.follow
    
    func createPolylineCoordinates() {
        polylineCoordinates = MockedDataMapAnnotation.map { location in
            CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    var body: some View {
            ZStack{
                if search.ShowPointOfInterestOnMap {
                    Map(coordinateRegion: $region,interactionModes: .all,
                        userTrackingMode: .none,
                        annotationItems: search.pointsOfInterest,
                        annotationContent: { location in
                        MapAnnotation(coordinate: location.mapItem.placemark.coordinate){
                            VStack(spacing: 0) {
                                Image(systemName: "mappin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .padding(6)
                                    .background(search.selectedType.color)
                                    .clipShape(Circle())
                                Image(systemName: "triangle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(search.selectedType.color)
                                    .frame(width: 8, height: 8)
                                    .rotationEffect(Angle(degrees: 180))
                                    .offset(y: -2.5)
                                    .padding(.bottom, 40)
                            }
                            .onTapGesture {
                                self.ShowDetailPlaceAnnotation = location
                                search.ShowInformationMapItem.toggle()
                                
                            }
                        }
                    }).edgesIgnoringSafeArea(.all)
                }else{
                    Map(coordinateRegion: $region)
                        .edgesIgnoringSafeArea(.all)
                    }
                VStack{
                    Spacer()

                    Spacer()
                    HStack{
                        if search.ShowInformationMapItem{
                            LocationPreviewView(pointofinterest: self.ShowDetailPlaceAnnotation!)
                                .environmentObject(search)
                                .padding()
                        }else {
                            
                            VStack(){
                                Button {
                                    search.ShowPointOfInterestOnMap = false
                                } label: {
                                    Image(systemName: "map")
                                        .font(.title2)
                                        .padding(10)
                                        .background(Color.primary)
                                        .clipShape(Circle())
                                }
                                Button {
                                    search.searchPointsOfInterests()
                                    ShowListPointOfInterest.toggle()
                                } label: {
                                    Image(systemName: "info")
                                        .font(.title2)
                                        .padding(10)
                                        .background(Color.primary)
                                        .clipShape(Circle())
                                }
                                
                            }
                        }
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()
                }
            }.sheet(isPresented: $ShowListPointOfInterest){
                PointOfInterestListView(show: $ShowPointOfInterestMarker, dismiss: $ShowListPointOfInterest, category: $search.selectedType, pointofinterest: search.pointsOfInterest)
                    .environmentObject(search)
                    .onChange(of: search.selectedType) { _ in
                    search.searchPointsOfInterests()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





