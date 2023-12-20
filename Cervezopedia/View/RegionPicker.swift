//
//  RegionPicker.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import SwiftUI

struct RegionPicker: View {
    @State private var locationFilter = ""
    @Binding var location: String
    var body: some View {
        VStack {
            TextField("Filtro...", text: $locationFilter).font(.subheadline)
                .onChange(of: locationFilter) { newValue in
                    location = Locale.Region.isoRegions.filter({ region in
                        region.subRegions.isEmpty
                    }).map({ region in
                        region.identifier
                    }).filter({ region in
                        region.hasPrefix(newValue.capitalized) || Locale.current.localizedString(forRegionCode: region)!.capitalized.hasPrefix(newValue.capitalized)
                    }).first ?? Locale.current.region!.identifier
                }
            Picker(selection: $location) {
                ForEach(Locale.Region.isoRegions.filter({ region in // TODO: - Extraer lógica de regiones a un gestor de regiones
                    region.subRegions.isEmpty
                }).map({ region in
                    region.identifier
                }).filter({ region in
                    region.hasPrefix(locationFilter.capitalized) || Locale.current.localizedString(forRegionCode: region)!.capitalized.hasPrefix(locationFilter.capitalized)
                }), id: \.self) { region in
                    Text("\(Locale.current.localizedString(forRegionCode: region)!) (\(region))")
                }
            } label: {
                Text("País del fabricante")
            }
        }
    }
}
