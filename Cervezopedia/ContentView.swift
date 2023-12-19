//
//  ContentView.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ManufacturerListView()
        }
        .onAppear {
            ManufacturerManager.shared.manufacturers = Serializer.shared.load(key: "manufacturers", defaultValue: [])!
        }
    }
}
