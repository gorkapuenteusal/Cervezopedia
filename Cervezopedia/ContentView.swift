//
//  ContentView.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var manager = ManufacturerManager.shared
    
    var body: some View {
        VStack {
            ManufacturerListView(manager: manager)
        }
        .onAppear {
            ManufacturerManager.shared.manufacturers = Serializer.shared.load(key: "manufacturers", defaultValue: [])!
        }
    }
}
