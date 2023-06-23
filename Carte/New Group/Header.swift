//
//  Header.swift
//  Carte
//
//  Created by Guillaume Genest on 26/05/2023.
//

import Foundation
import SwiftUI

struct HeaderModelView: View {
    @Environment(\.colorScheme) var colorScheme
    var title: String
    var PresenseBackButton: Bool?
    var PresenceIcon: Bool?
    var BackButtonIcon: String?
    var ButtonOneIcon: String?
    var BackButtonClick: (() -> ())?
    let value: [ConfigurationHeaderButton]?
    
    var body: some View {
        ZStack {
            HStack{
                if PresenseBackButton == true {
                    if self.BackButtonClick != nil {
                        if self.BackButtonIcon != nil {
                            HeaderButton(action: {BackButtonClick!()}, nameIcon: BackButtonIcon ?? "")
                        }else{
                            HeaderButton(action: {BackButtonClick!()}, nameIcon: "chevron.backward")
                        }
                    }
                }else{
                    Spacer()
                
                }
            
            Spacer()
                if PresenceIcon == true {
                    if value != nil {
                        if value!.count == 1 {
                            HeaderButton(action: value!.first!.action, nameIcon: value!.first!.NameIcon)
                        } else {
                            Menu {
                            ForEach(value!){ configurationArray in
                                if configurationArray.NameIcon == "trash" {
                                    Button(role: .destructive, action: configurationArray.action,
                                           label: {
                                               Label(configurationArray.NameLabel, systemImage: configurationArray.NameIcon)
                                           })
                                }else {
                                    Button(action: configurationArray.action,
                                           label: {
                                        Label(configurationArray.NameLabel, systemImage: configurationArray.NameIcon)
                                    })
                                }
                                
                            }
                                    } label: {
                                        Image(systemName: ButtonOneIcon!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .font(.headline)
                                            .padding(8)
                                            .foregroundColor(.primary)
                                            .background(.thickMaterial)
                                            .cornerRadius(10)
                                            .shadow(radius: 4)
                                    }
                        }
                        }
                }
                else
                {
                    Spacer()
                
                }
            
            }
            HStack {
                Text(title)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.orange)
                    .font(.title)
                    .fontWeight(.bold)
                    .tracking(0.15)
            }
        }
        .padding(20)
        .padding(.top, 20)
        
    }
}


struct ConfigurationHeaderButton : Identifiable, Equatable{
    static func == (lhs: ConfigurationHeaderButton, rhs: ConfigurationHeaderButton) -> Bool {
        lhs.id == rhs.id
    }
    
    let id : UUID = UUID()
    var NameLabel: String
    var NameIcon: String
    var action: () -> Void
}

struct HeaderButton: View {
    var action: () -> Void
    var nameIcon: String
    var body: some View{
        Button(action: action,label: {
            Image(systemName: nameIcon)
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
}
