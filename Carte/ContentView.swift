//
//  ContentView.swift
//  Carte
//
//  Created by Guillaume Genest on 12/05/2023.
//

import SwiftUI
import MapKit
import CoreLocation


struct ContentView: View {
    @StateObject var userlocation = locationManager()
    @StateObject var search = SearchPointOfInterests()
    @State var ShowDetailPlaceAnnotation : PointOfInterest?
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.188529, longitude: 5.724524), latitudinalMeters: 20000, longitudinalMeters: 20000)
    @State private var userAnnotationColor: UIColor = .red
//    @State var category : PointOfInterestType = .Historique
    

    
    
    @State private var ShowInformationMapItem : Bool = false
    @State private var ShowListPointOfInterest : Bool = false
    @State private var ShowPointOfInterestMarker : Bool = false
    @State private var pointsOfInterest: [MKMapFeatureAnnotation] = []
    
    @State private var polylineCoordinates: [CLLocationCoordinate2D] = []
    @State private var user = MapUserTrackingMode.follow
    
    func createPolylineCoordinates() {
        polylineCoordinates = MockedDataMapAnnotation.map { location in
            CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    var body: some View {
            ZStack{
                if search.ShowPointOfInterestOnMap {
                    Map(coordinateRegion: $region,interactionModes: .all,
                        showsUserLocation: true,
                        userTrackingMode: $user,
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
                    Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $user, annotationItems: MockedDataMapAnnotation,
                        annotationContent: { location in
                      MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                          VStack(spacing: 0) {
                              Image(systemName: "map")
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 15, height: 15)
                                  .font(.headline)
                                  .foregroundColor(Color.black)
                                  .padding(6)
                                  .background(Color.white)
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
                  })
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
                                    search.searchPointsOfInterest()
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
                    search.searchPointsOfInterest()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapPointOfInterest()
    }
}




struct MapPointOfInterest: View {
    @StateObject var userlocation = locationManager()
    @State private var user = MapUserTrackingMode.follow
    @StateObject var search = SearchPointOfInterests()
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.188529, longitude: 5.724524), latitudinalMeters: 2000, longitudinalMeters: 2000)
    @State var category : PointOfInterestType = .Histoire
    @State private var ShowListPointOfInterest : Bool = false
    
    
    @State private var ShowInformationMapItem : Bool = false
    @State private var ShowPointOfInterestMarker : Bool = false
    @State private var pointsOfInterest: [MKMapFeatureAnnotation] = []
    
    @State var ShowDetailPlaceAnnotation : PointOfInterest?
    
    var body: some View{
        NavigationStack{
            VStack{
                HeaderModelView(title: "Carte", PresenseBackButton: true, PresenceIcon: true, BackButtonClick: {  }, value: [ConfigurationHeaderButton(NameLabel: "List", NameIcon: "list.dash", action: {self.ShowListPointOfInterest.toggle()})])
                    .frame(maxWidth: .infinity)
                PickerPointOfInterestCategory(selectedCategories: $search.selectedType)
                    .padding(10)
                ZStack{
                    Map(coordinateRegion: $search.searchRegion ,interactionModes: .all,
                        showsUserLocation: true,
                        userTrackingMode: $user,
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
                            } .onTapGesture {
                                search.ShowDetailPlaceAnnotation = location
                                search.ShowInformationMapItem = true
                                
                            }}}).edgesIgnoringSafeArea(.all)
                    VStack{
                        
                        Spacer()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(10)
                    VStack{
                        Spacer()
                        
                        Spacer()
                        HStack{
                            if search.ShowInformationMapItem{
                                LocationPreviewView(pointofinterest: search.ShowDetailPlaceAnnotation!)
                                    .environmentObject(search)
                                    .padding()
                            }
                        }
                    }
                }
            }.edgesIgnoringSafeArea(.all)
                .onAppear {
                    search.searchPointsOfInterest()
                        }
                .onChange(of: search.selectedType) { _ in
                    search.ShowInformationMapItem = false
                    search.searchPointsOfInterest()
                }
                .navigationBarHidden(true)
                .navigationDestination(isPresented: $ShowListPointOfInterest) {
                    ListPointOfInterestView(pointofinterest: search.pointsOfInterest)
                        .navigationBarHidden(true)
                        .environmentObject(search)
                }
        }
    }
}
