//
//  ManufacturerRowPreview.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 19/12/23.
//

import SwiftUI

struct ManufacturerRowView: View {
    var name: String
    var location: String
    var logo: String
    
    var body: some View {
        HStack {
            Image(uiImage: LogoManager.shared.getLogo(withName: logo))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 25, maxHeight: 25)
            Text(name)
            Spacer()
            Circle()
                .frame(width: 25, height: 25)
                .foregroundColor(.accentColor)
                .overlay(
                    Text(location)
                        .font(.subheadline)
                        .foregroundColor(.white)
                )
        }
        .padding(.horizontal)
    }
}
