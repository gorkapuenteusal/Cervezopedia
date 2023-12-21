//
//  BeerRowView.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 21/12/23.
//

import SwiftUI

struct BeerRowView: View {
    var name: String
    var type: BeerType
    var beerImageName: String
    
    var body: some View {
        VStack {
            Text(name)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.leading)
            Text("Cerveza \(type.formattedString)")
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            Divider()
            Image(uiImage: BeerImageManager.shared.getBeerImage(withName: beerImageName))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 400, maxHeight: 200)
        }
        .frame(alignment: .leading)
    }
}
