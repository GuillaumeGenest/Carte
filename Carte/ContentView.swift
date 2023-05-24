//
//  ContentView.swift
//  Carte
//
//  Created by Guillaume Genest on 12/05/2023.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @StateObject var search = SearchPointOfInterest()
    @State var ShowDetailPlaceAnnotation : MKMapItem?
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.861, longitude: 2.335833), latitudinalMeters: 8000, longitudinalMeters: 8000)
    
    
    
    
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
        
        if ShowPointOfInterestMarker == true {
            ZStack{
                Map(coordinateRegion: $region,interactionModes: .all,
                    userTrackingMode: .none,
                    annotationItems: search.places,
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
                                .background(Color.purple)
                                .clipShape(Circle())
                            Image(systemName: "triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.purple)
                                .frame(width: 8, height: 8)
                                .rotationEffect(Angle(degrees: 180))
                                .offset(y: -2.5)
                                .padding(.bottom, 40)
                        }
                        .onTapGesture {
                            self.ShowDetailPlaceAnnotation = location.mapItem
                            ShowInformationMapItem.toggle()
                            
                        }
                    }
                }).edgesIgnoringSafeArea(.all)
                
                if ShowInformationMapItem == true {
                    
                    VStack{
                        Spacer()
                        InformationMapItem(place: self.ShowDetailPlaceAnnotation!)
                    }
                }
            }
        }else {
            
            VStack{
                Text("Mon trip")
            }
            ZStack{
                Carte(coordinateRegion: $region ,type: MKStandardMapConfiguration(), userTrackingMode: $userTrackingMode ,annotationItems: MockedDataMapAnnotation,
                      annotationContent: { location in
                    CarteAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
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
                },overlays: [
                    MKPolyline(coordinates: polylineCoordinates, count: polylineCoordinates.count)
                      ],overlayContent: { overlay in
                          RendererCarteOverlay(overlay: overlay) { _, overlay in
                              
                              if let polyline = overlay as? MKPolyline {
                                  let renderer = MKPolylineRenderer(polyline: polyline)
                                  renderer.lineWidth = 2
                                  renderer.lineCap = .butt
                                  renderer.lineJoin = .miter
                                  renderer.miterLimit = 0
                                  renderer.lineDashPhase = 0
                                  renderer.lineDashPattern = [10,5]
                                  renderer.strokeColor = .orange
                                  return renderer
                              } else {
                                  assertionFailure("Unknown overlay type found.")
                                  print("Probleme overlay")
                                  return MKOverlayRenderer(overlay: overlay)
                              }
                          }
                      }
                ).edgesIgnoringSafeArea(.all)
                Spacer()
                HStack{
                    Spacer()
                    VStack{
                        Button {
                            createPolylineCoordinates()
                        } label: {
                            Image(systemName: "map")
                                .font(.title2)
                                .padding(10)
                                .background(Color.primary)
                                .clipShape(Circle())
                        }
                        Button {
                            search.searchMuseums()
                            ShowListPointOfInterest.toggle()
                        } label: {
                            Image(systemName: "info")
                                .font(.title2)
                                .padding(10)
                                .background(Color.primary)
                                .clipShape(Circle())
                        }

                    }.frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()
                }
            }
            .sheet(isPresented: $ShowListPointOfInterest){
                PointOfInterestListView(show: $ShowPointOfInterestMarker, dismiss: $ShowListPointOfInterest, pointofinterest: search.places)
            }
            
            
            
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct InformationMapItem: View {
    var place : MKMapItem
    
    var body: some View{
        VStack{
            Text(place.name ?? "")
            Text(place.placemark.thoroughfare ?? "")
        }.background(Color.white)
    }
}






struct PointOfInterestListView : View {
    @Binding var show : Bool
    @Binding var dismiss : Bool
    var pointofinterest: [PointOfInterest]
    var body: some View{
        ScrollView{
            Text("List of point of interest")
            Button {
                show.toggle()
                dismiss.toggle()
            } label: {
                Text("see the marker ")
            }

            ForEach(pointofinterest) { i in
                VStack(alignment: .leading){
                    Text(i.mapItem.name ?? "")
                    Text(i.mapItem.placemark.title ?? "")
                        .font(.caption)
                    Divider()
                }.padding(.horizontal, 8)
            }
        }
    }
}

struct PointOfInterest : Identifiable {
    var id = UUID()
    var mapItem: MKMapItem
}
