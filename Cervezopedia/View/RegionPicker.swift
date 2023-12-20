//
//  RegionPicker.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import SwiftUI

struct RegionPicker: View {
    @State private var locationFilter = ""
    @State private var isPickerEnabled = true
    
    @Binding var location: String
    
    var body: some View {
        VStack {
            TextField("Filtro...", text: $locationFilter).font(.subheadline)
                .onChange(of: locationFilter) { newValue in
                    if let filteredFirst = filterRegions(filter: newValue).first {
                        location = filteredFirst
                        if !isPickerEnabled { isPickerEnabled.toggle() }
                    } else {
                        isPickerEnabled = false
                        location = Locale.current.region!.identifier
                    }
                }
            if isPickerEnabled {
                Picker(selection: $location) {
                    ForEach(filterRegions(filter: locationFilter), id: \.self) { region in
                        Text("\(Locale.current.localizedString(forRegionCode: region)!) (\(region))")
                    }
                } label: {
                    Text("País del fabricante")
                }
            } else {
                Text("No hay regiones disponibles para ese filtro")
            }
        }
    }
    
    private func filterRegions(filter: String) -> [String] {
        return Locale.Region.isoRegions.filter({ region in
            region.subRegions.isEmpty
        }).map({ region in
            region.identifier
        }).filter({ region in
            region.capitalized.hasPrefix(filter.capitalized) || Locale.current.localizedString(forRegionCode: region)!.capitalized.hasPrefix(filter.capitalized)
        })
    }
}
