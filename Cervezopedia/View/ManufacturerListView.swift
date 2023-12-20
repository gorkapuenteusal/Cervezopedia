//
//  ManufacturerListView.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import SwiftUI

struct ManufacturerListView: View {
    @StateObject var manager = ManufacturerManager.shared
    @State private var addingManuf = false
    @State private var selectedManufacturer: ManufacturerModel? // Agregamos una propiedad para rastrear el fabricante seleccionado

    var body: some View { // TODO: - Añadir buscador por nombre (en cada sección o en general)
        NavigationView { // Envuelve la lista en un NavigationView
            VStack {
                List {
                    Section("Nacionales") {
                        ForEach(manager.manufacturers
                            .filter { man in
                                man.isNational()
                            }
                            .sorted(by: { man1, man2 in
                                man1.name < man2.name
                            })
                        ) { natMan in
                            // Utiliza NavigationLink para la navegación
                            NavigationLink(destination: EmptyView()) {
                                ManufacturerRowView(name: natMan.name, location: natMan.location, logo: natMan.logoName)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    _ = manager.remove(toRemove: natMan)
                                    Serializer.shared.save(value: manager.manufacturers, key: "manufacturers")
                                } label: {
                                    Label("Eliminar", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        }
                    }
                    Section("Importadas") { // TODO: - añadir una sección por cada país
                        ForEach(manager.manufacturers
                            .filter { man in
                                !man.isNational()
                            }
                            .sorted(by: { man1, man2 in
                                man1.id < man2.id
                            })
                        ) { importMan in
                            NavigationLink(destination: EmptyView()) {
                                ManufacturerRowView(name: importMan.name, location: importMan.location, logo: importMan.logoName)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    _ = manager.remove(toRemove: importMan)
                                    Serializer.shared.save(value: manager.manufacturers, key: "manufacturers")
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
