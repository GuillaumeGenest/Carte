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
    case Histoire
    case Greographie
    
    
    var color: Color {
        switch self {
        case .Histoire:
            return Color.red
        case .Greographie:
            return Color.green
        }
    }
    
    var queries: [String] {
        switch self {
        case .Histoire:
            return ["Chateau", "palais", "musée", "cathedrale", "tour"]
        case .Greographie:
            return ["Parc ", "Bois ", "Square "]
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
        ScrollView(.horizontal){
            HStack{
            ForEach(categories.indices) { index in
                    Button {
                        selectedCategories = categories [index]
                    } label: {
                        Text(categories[index].rawValue.capitalized)
                            .foregroundColor(selectedCategories == categories[index] ? Color.white : offcolor)
                    }.padding(.horizontal, 8)
                   
                    .background(selectedCategories == categories[index] ? oncolor : Color.white )
                    .cornerRadius(10)
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
