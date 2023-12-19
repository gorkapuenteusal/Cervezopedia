//
//  ManufacturerListView.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import SwiftUI

struct ManufacturerListView: View { // TODO: - !!! Cuando se aplique la serialización. El logo aunque se borre se mantiene en la sesión en la que se borra. Comprobar si después el manufacturador estará corrompido
    @StateObject var manager = ManufacturerManager.shared
    @State private var addingManuf = false
    @State private var selectedManufacturer: ManufacturerModel? // Agregamos una propiedad para rastrear el fabricante seleccionado

    var body: some View {
        NavigationView { // Envuelve la lista en un NavigationView
            VStack {
                List {
                    Section("Nacionales") {
                        ForEach(manager.manufacturers.filter { $0.isNational() }) { natMan in
                            // Utiliza NavigationLink para la navegación
                            NavigationLink(destination: EmptyView()) {
                                ManufacturerRowView(name: natMan.name, location: natMan.location, logo: natMan.logoName)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    _ = manager.remove(toRemove: natMan)
                                } label: {
                                    Label("Eliminar", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        }
                    }
                    Section("Importadas") {
                        ForEach(manager.manufacturers.filter { !$0.isNational() }) { importMan in
                            NavigationLink(destination: EmptyView()) {
                                ManufacturerRowView(name: importMan.name, location: importMan.location, logo: importMan.logoName)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    _ = manager.remove(toRemove: importMan)
                                } label: {
                                    Label("Eliminar", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
                Button("Añadir fabricante") {
                    addingManuf = true
                }
                .sheet(isPresented: $addingManuf) {
                    AddManufacturerView(isPresented: $addingManuf)
                }
            }
            .navigationBarTitle("Lista de Fabricantes")
        }
    }
}
