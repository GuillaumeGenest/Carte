//
//  ContentView.swift
//  Carte
//
//  Created by Guillaume Genest on 12/05/2023.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.861, longitude: 2.335833), latitudinalMeters: 8000, longitudinalMeters: 8000)
    
    @State private var polylineCoordinates: [CLLocationCoordinate2D] = []
    func createPolylineCoordinates() {
        polylineCoordinates = MockedDataMapAnnotation.map { location in
            CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
        }
    }
    init() {
        print("tentative init")
        createPolylineCoordinates()
        print("AFFICHAGE -------------------------------")
        print("\(polylineCoordinates)")
    }

    func createpolyne() -> MKPolyline{
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for annotation in MockedDataMapAnnotation {
            var coord = CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)
            points.append(coord)
        }
        var polyline = MKPolyline(coordinates: &points, count: points.count)
        return polyline
    }
//    let polyLine = overlay
//    let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
//    polyLineRenderer.strokeColor = UIColor.blue
//    polyLineRenderer.lineWidth = 2.0
    
    
    
//
//    func createoverlay(annotations: [Location]) -> MKOverlay {
//        var locations = annotations.map {$0.coordinate}
//        let polyline = MKPolyline(coordinates: &locations, count: locations.count)
//        return polyline
//
//
//    }
    
    var body: some View {
        VStack {
//            Carte(coordinateRegion:  $region ,overlays: <#T##[MKOverlay]#>, overlayContent: <#T##(MKOverlay) -> MapOverlay#>)
//            Carte(coordinateRegion: $region, overlayItems: createoverlay(annotations: annotations), overlayContent: { overlay in
//                RendererCarteOverlay(overlay: overlay as! MKOverlay){
//                    _, overlay in
//                    if let polyline = overlay as? MKPolyline {
//                        let renderer = MKPolylineRenderer(polyline: overlay)
//                                              renderer.lineWidth = 6
//                        renderer.strokeColor = .blue
//                                              return renderer
//                    }
//
//                }
//            })
                
            Button {
                createPolylineCoordinates()
            } label: {
                Image(systemName: "map")
                    .font(.title2)
                    .padding(10)
                    .background(Color.primary)
                    .clipShape(Circle())
            }

                
                
       Carte(coordinateRegion: $region, annotationItems: MockedDataMapAnnotation,
             annotationContent: { location in
           CarteAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
               VStack(spacing: 0) {
                   Image(systemName: "")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 20, height: 20)
                       .font(.headline)
                       .foregroundColor(.white)
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
                                           renderer.lineWidth = 4
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
       ).ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
