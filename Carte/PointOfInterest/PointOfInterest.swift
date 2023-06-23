//
//  MKPointOfInterest.swift
//  Carte
//
//  Created by Guillaume Genest on 22/05/2023.
//

import Foundation
import SwiftUI
import MapKit


struct PointOfInterest : Identifiable {
    var id = UUID()
    var mapItem: MKMapItem
}



struct PointOfInterestListView : View {
    @EnvironmentObject var search: SearchPointOfInterests
    
    
    @Binding var show : Bool
    @Binding var dismiss : Bool
    
    @Binding var category : PointOfInterestType
    
    var pointofinterest: [PointOfInterest]
    var body: some View{
        VStack{
            Text("Liste des points")
                .foregroundColor(Color.orange)
                .font(.title)
                .fontWeight(.bold)
                .tracking(0.15)
        }
        HStack{
            PickerPointOfInterestCategory(selectedCategories: $category)
            Button(action: {search.ShowPointOfInterestOnMap = true
                dismiss.toggle()
            },label: {
                Image(systemName: "map")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .font(.headline)
                    .padding(8)
                    .foregroundColor(.primary)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    //.padding()
            })
        }
                .padding(10)
    Divider()
        ListPointOfInterest(pointofinterest: search.pointsOfInterest)
    }
}



extension MKPointOfInterestCategory {
    
    static let travelPointsOfInterest: [MKPointOfInterestCategory] = [.bakery, .brewery, .cafe, .restaurant, .winery, .hotel]
    static let defaultPointOfInterestSymbolName = "mappin.and.ellipse"
    
    var symbolName: String {
        switch self {
        case .airport:
            return "airplane"
        case .atm, .bank:
            return "banknote"
        case .bakery, .brewery, .cafe, .foodMarket, .restaurant, .winery:
            return "fork.knife"
        case .campground, .hotel:
            return "bed.double"
        case .carRental, .evCharger, .gasStation, .parking:
            return "car"
        case .laundry, .store:
            return "tshirt"
        case .museum:
            return "building.columns"
        case .nationalPark, .park:
            return "leaf"
        case .postOffice:
            return "envelope"
        case .publicTransport:
            return "bus"
        default:
            return MKPointOfInterestCategory.defaultPointOfInterestSymbolName
        }
    }
}


enum PointOfInterestType: String, CaseIterable, Codable {
    case Monument
    case nature
    case attractions
    case plages
    case ville
    case cuisine
    case sport
    case sante
    case culture
    case art
        
        var color: Color {
            switch self {
            case .Monument:
                return Color.red
            case .nature:
                return Color.green
            case .attractions:
                return Color.blue
            case .plages:
                return Color.orange
            case .ville:
                return Color.purple
            case .cuisine:
                return Color.red
            case .sport:
                return Color.yellow
            case .sante:
                return Color.gray
            case .culture:
                return Color.pink
            case .art:
                return Color.brown
            }
        }
        
        var queries: [String] {
            switch self {
            case .Monument:
                return ["chateau", "palais", "musee"]
            case .nature:
                return ["Parcs", "reserves", "montagnes"]
            case .attractions:
                return ["foraine", "Bowling"]
            case .plages:
                return ["plages", "lac"]
            case .ville:
                return ["restaurants", "boutiques"]
            case .cuisine:
                return ["cuisine", "specialites", "vins"]
            case .sport:
                return ["ski", "surf", "plongée", "golf"]
            case .sante:
                return ["spas", "piscine"]
            case .culture:
                return ["theatre", "opera", "festivals"]
            case .art:
                return ["art", "galerie"]
            }
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

struct PickerPointOfInterestCategory: View {
    let oncolor: Color = .orange
    let offcolor: Color = .gray
    
    @State private var isSelectingMode = false
    @Binding var selectedCategories: PointOfInterestType
    private let categories = PointOfInterestType.allCases
    
    var body : some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
            ForEach(categories.indices) { index in
                    Button {
                        selectedCategories = categories [index]
                    } label: {
                        Text(categories[index].rawValue.capitalized)
                            .foregroundColor(selectedCategories == categories[index] ? Color.white : offcolor)
                    }.padding(12)
                    .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(selectedCategories == categories[index] ? oncolor : Color(UIColor.lightGray), lineWidth: 1))
                    .background(selectedCategories == categories[index] ? oncolor : Color.white )
                    .cornerRadius(15)
                }
            }
        }
    }
}


struct ListPointOfInterest : View{
    var pointofinterest: [PointOfInterest]
    var body: some View{
        ScrollView{
            ForEach(pointofinterest) { i in
                NavigationLink(destination: RegisterInformation(point: i),
                        label: {
                        VStack{
                            Text(i.mapItem.name ?? "")
                            Text(i.mapItem.placemark.title ?? "")
                            Text(i.mapItem.phoneNumber ?? "")
                       
                                .font(.caption)
                            
                            
                        }.foregroundColor(.black)
                })
            }
        }
    }
}


struct RegisterInformation: View {
    var point : PointOfInterest
    var body: some View{
        
        VStack{
            Text(point.mapItem.name ?? "")
            Text(point.mapItem.phoneNumber ?? "")
            
            
        }
    }
}



struct ListPointOfInterestView: View {
    @Environment(\.presentationMode) var presentationMode
    var pointofinterest: [PointOfInterest]
    var body: some View {
        VStack{
            HeaderModelView(title: "Liste des Points ", PresenseBackButton: true, PresenceIcon: false, BackButtonIcon: "map", BackButtonClick: {self.presentationMode.wrappedValue.dismiss()}, value: [])
                .frame(maxWidth: .infinity)
            ScrollView{
                ForEach(pointofinterest) { i in
                    VStack(alignment: .leading){
                            Text(i.mapItem.name ?? "")
                            Text(i.mapItem.placemark.title ?? "")
                            Text(i.mapItem.phoneNumber ?? "")
                                .font(.caption)
                        Divider()
                    }.foregroundColor(.black)
                        .padding(10)
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ListPointOfInterestView_Previews: PreviewProvider {
    static var previews: some View {
        MapPointOfInterest()
    }
}
