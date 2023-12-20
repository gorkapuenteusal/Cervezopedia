import SwiftUI

struct ManufacturerListView: View {
    @StateObject var manager = ManufacturerManager.shared
    @State private var isAddingManufacturer = false

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(groupManufacturers(manufacturers: manager.manufacturers.sorted(by: { man1, man2 in
                        man1.location < man2.location
                    })), id: \.key) { section in
                        Section(header: Text(section.key)) {
                            ForEach(section.value, id: \.id) { manufacturer in
                                NavigationLink(destination: EmptyView()) { // TODO: - sustituir EmptyView() por ManufacturerDetailedView(manufacturerIdx: manager.getIndex(of: manufacturer), manufacturers: manager.manufacturers)
                                    ManufacturerRowView(manufacturer: manufacturer)
                                }
                            }
                            .onDelete { indexSet in
                                if let idx = indexSet.first {
                                    let manufacturerToDelete = section.value[idx]
                                    if manager.remove(toRemove: manufacturerToDelete) {
                                        Serializer.shared.save(value: manager.manufacturers, key: "manufacturers")
                                    }
                                }
                            }
                        }
                    }
                }
                
                Button {
                    isAddingManufacturer = true
                } label: {
                    Label("Añadir fabricante", systemImage: "plus")
                }
                .sheet(isPresented: $isAddingManufacturer) {
                    AddManufacturerView(isPresented: $isAddingManufacturer)
                }
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
