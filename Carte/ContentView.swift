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
    
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.861, longitude: 2.335833), latitudinalMeters: 8000, longitudinalMeters: 8000)
    @State private var annotationsIndex = 0
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
        ZStack {
            
            if ShowPointOfInterestMarker == true {
                Map(coordinateRegion: $region, annotationItems: search.places)
                { place in
                    MapMarker(coordinate: place.mapItem.placemark.coordinate,
                           tint: Color.purple)
                }
            }else {
                
                
                
                
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
                },
                      overlays: [
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
            }
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
            }.sheet(isPresented: $ShowListPointOfInterest){
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
