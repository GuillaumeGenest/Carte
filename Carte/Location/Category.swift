//
//  Category.swift
//  Carte
//
//  Created by Guillaume Genest on 15/05/2023.
//

import Foundation
import Foundation
import SwiftUI

enum CategoryPlace : String, CaseIterable, Codable {
        case Logement
        case Alimentation
        case Bar
        case Restaurant
        case Musee
        case Vue

    var systemNameIcon: String {
        switch self {
        case .Logement: return "bed.double"
        case .Alimentation: return "cart.fill"
        case .Bar: return "wineglass"
        case .Restaurant: return "fork.knife"
        case .Musee: return "books.vertical"
        case .Vue: return "binoculars"
 
        }
    }
    
    var color: Color {
        switch self {
        case .Logement: return Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
        case .Alimentation: return Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
        case .Restaurant: return Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
        case .Bar: return Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
        case .Musee: return Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        case .Vue: return Color(#colorLiteral(red: 0.9254902005, green: 0.066734083, blue: 0.2666666806, alpha: 1))
        }
    }
}



extension CategoryPlace: Identifiable {
    var id: String { rawValue }
}

struct CategoryPlaceView: View {
    
    let category: CategoryPlace
    
    var body: some View {
        Image(systemName: category.systemNameIcon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80)
            .padding(.all, 8)
            .foregroundColor(.white)
            .background(category.color)
            .cornerRadius(18)
    }
}

struct CategoryPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CategoryPlaceView(category: .Logement)
            CategoryPlaceView(category: .Alimentation)
            CategoryPlaceView(category: .Bar)
            CategoryPlaceView(category: .Restaurant)
            CategoryPlaceView(category: .Musee)
            CategoryPlaceView(category: .Vue)
        }
    }
}
