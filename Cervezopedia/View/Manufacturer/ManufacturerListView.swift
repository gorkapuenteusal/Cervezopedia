import SwiftUI

struct ManufacturerListView: View {
    @ObservedObject var manager: ManufacturerManager
    
    @State private var isAddingManufacturer = false
    @State private var isShowingDeleteAllAlert = false
    @State private var update = false

    var body: some View {
        NavigationStack {
            if update {
                EmptyView()
            }
            VStack {
                List {
                    ForEach(groupManufacturers(manufacturers: manager.manufacturers.sorted(by: { man1, man2 in
                        man1.id < man2.id // TODO: - Para mayor eficiencia, organizar al añadir nuevo
                    })), id: \.key) { section in
                        Section(header: Text(section.key)) {
                            ForEach(section.value, id: \.id) { manufacturer in
                                NavigationLink(destination: ManufacturerDetailedView(manufacturer: manufacturer)) {
                                    ManufacturerRowView(name: manufacturer.name, location: manufacturer.location, logoName: manufacturer.logoName)
                                }
                            }
                            .onDelete { indexSet in
                                if let idx = indexSet.first {
                                    let manufacturerToDelete = section.value[idx]
                                    if ManufacturerManager.shared.remove(toRemove: manufacturerToDelete) {
                                        Serializer.shared.save(value: ManufacturerManager.shared.manufacturers, key: "manufacturers")
                                    }
                                }
                            }
                        }
                    }
                }
                
                Button {
                    isShowingDeleteAllAlert = true
                } label: {
                    Label("Eliminar todos los fabricantes", systemImage: "trash.fill")
                }
                .tint(.red)
                .alert(isPresented: $isShowingDeleteAllAlert) {
                    Alert(title: Text("¿Eliminar todos los fabricantes?"), message: Text("Esta acción eliminará todos los fabricantes. ¿Estás seguro?"), primaryButton: .destructive(Text("Eliminar todos")) {
                        ManufacturerManager.shared.clear()
                        Serializer.shared.save(value: ManufacturerManager.shared.manufacturers, key: "manufacturers")
                    }, secondaryButton: .cancel())
                }
                .padding()
                
                Button {
                    isAddingManufacturer = true
                } label: {
                    Label("Añadir fabricante", systemImage: "plus")
                }
                .sheet(isPresented: $isAddingManufacturer) {
                    AddManufacturerView(isPresented: $isAddingManufacturer)
                }
                .padding()
            }
            .navigationTitle("Fabricantes")
        }
    }

    private func groupManufacturers(manufacturers: [ManufacturerModel]) -> [(key: String, value: [ManufacturerModel])] {
        let groupedDictionary = Dictionary(grouping: manufacturers) { (manufacturer) -> String in
            return manufacturer.isNational() ? "Nacional" : "Importadas"
        }
        return groupedDictionary.sorted { group1, group2 in
            if group1.key == "Nacional" {
                return true
            } else if group2.key == "Nacional" {
                return false
            } else {
                return group1.key < group2.key
            }
        }
    }
}
