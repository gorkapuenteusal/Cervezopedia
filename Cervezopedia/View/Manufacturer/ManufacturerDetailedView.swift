//
//  ManufacturerDetailedView.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 21/12/23.
//

import SwiftUI

struct ManufacturerDetailedView: View {
    @StateObject var manufacturer: ManufacturerModel
    
    @State private var isAddingBeer = false
    @State private var isShowingDeleteAllAlert = false
    @State private var update = false
    
    @State private var selectedSortOption: SortOption = .name
    
    @State var typeFilter: BeerType = .sinFiltro
    
    var body: some View {
        NavigationStack {
            if update {
                EmptyView()
            }
            VStack {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Fabricante \(manufacturer.isNational() ? "Nacional" : "de \(Locale.current.localizedString(forRegionCode: manufacturer.location)!)")")
                            .foregroundColor(.accentColor)
                            .padding(.leading)
                        Divider()
                        HStack {
                            Text("Ordenar por:")
                            Picker("SortOption", selection: $selectedSortOption) {
                                Text("Nombre").tag(SortOption.name)
                                Text("Alcohol").tag(SortOption.alcoholContent)
                                Text("Kcal").tag(SortOption.caloricIntake)
                            }
                        }
                        .padding(.leading)
                    }
                    Image(uiImage: LogoManager.shared.getLogo(withName: manufacturer.logoName))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                }
                
                List {
                    if !manufacturer.beers.isEmpty {
                        Picker("Filtrar por tipo", selection: $typeFilter) {
                            ForEach(BeerType.allCases, id: \.self) { beerType in
                                Text(beerType.formattedString)
                            }
                        }
                    }
                    ForEach(groupBeers(beers: manufacturer.beers, sortBy: selectedSortOption), id: \.key) { section in
                        if typeFilter == .sinFiltro || section.key == typeFilter {
                            if typeFilter == .sinFiltro {
                                Section(header: Text(section.key.formattedString)) {
                                    ForEach(section.value, id: \.id) { beer in
                                        NavigationLink(destination: BeerDetailedView(beer: beer, name: beer.name, type: beer.type, alcoholContent: beer.alcoholContent, caloricIntake: beer.caloricIntake, beerImageName: beer.beerImageName, update: $update)) {
                                            BeerRowView(name: beer.name, type: beer.type, beerImageName: beer.beerImageName)
                                        }
                                    }
                                    .onDelete { indexSet in
                                        manufacturer.removeBeer(toRemoveIdx: indexSet)
                                        Serializer.shared.save(value: ManufacturerManager.shared.manufacturers, key: "manufacturers")
                                    }
                                }
                            } else {
                                ForEach(section.value, id: \.id) { beer in
                                    NavigationLink(destination: BeerDetailedView(beer: beer, name: beer.name, type: beer.type, alcoholContent: beer.alcoholContent, caloricIntake: beer.caloricIntake, beerImageName: beer.beerImageName, update: $update)) {
                                        BeerRowView(name: beer.name, type: beer.type, beerImageName: beer.beerImageName)
                                    }
                                }
                                .onDelete { indexSet in
                                    manufacturer.removeBeer(toRemoveIdx: indexSet)
                                    Serializer.shared.save(value: ManufacturerManager.shared.manufacturers, key: "manufacturers")
                                }
                            }
                        }
                    }
                }
                
                Button {
                    isShowingDeleteAllAlert = true
                } label: {
                    Label("Eliminar todas las cervezas", systemImage: "trash.fill")
                }
                .tint(.red)
                .alert(isPresented: $isShowingDeleteAllAlert) {
                    Alert(title: Text("¿Eliminar todas las cervezas?"), message: Text("Esta acción eliminará todas las cervezas. ¿Estás seguro?"), primaryButton: .destructive(Text("Eliminar todas")) {
                        manufacturer.clearBeers()
                        Serializer.shared.save(value: ManufacturerManager.shared.manufacturers, key: "manufacturers")
                    }, secondaryButton: .cancel())
                }
                .padding()
                
                Button {
                    isAddingBeer = true
                } label: {
                    Label("Añadir cerveza", systemImage: "plus")
                }
                .sheet(isPresented: $isAddingBeer) {
                    AddBeerView(isPresented: $isAddingBeer, manufacturer: manufacturer)
                }
                .padding()
                
            }
            .navigationTitle(manufacturer.name)
        }
    }
    
    private func groupBeers(beers: [BeerModel], sortBy sortOption: SortOption) -> [(key: BeerType, value: [BeerModel])] {
        var sortedBeers = beers

        switch sortOption {
        case .name:
            sortedBeers.sort { $0.name < $1.name }
        case .alcoholContent:
            sortedBeers.sort { $0.alcoholContent < $1.alcoholContent }
        case .caloricIntake:
            sortedBeers.sort { $0.caloricIntake < $1.caloricIntake }
        }

        let groupedDictionary = Dictionary(grouping: sortedBeers) { $0.type }
        return groupedDictionary.sorted { group1, group2 in
            return group1.key.rawValue < group2.key.rawValue
        }
    }
}

enum SortOption: String {
    case name = "Nombre"
    case alcoholContent = "Alcohol"
    case caloricIntake = "Kcal"
}
