import Foundation

/// Gestor de fabricantes encargado de administrar la lista de fabricantes en la aplicación.
final class ManufacturerManager: ObservableObject {
    /// Instancia compartida de ManufacturerManager, utilizando el patrón Singleton.
    static let shared = ManufacturerManager()
    /// Lista de fabricantes de cerveza, publicada para notificar cambios a las vistas.
    @Published var manufacturers: [ManufacturerModel] = []
    
    private init() {}
    
    /// Añade un nuevo fabricante a la lista, evitando duplicados.
    ///
    /// - Parameters:
    ///   - toAdd: Fabricante a añadir.
    /// - Returns: `true` si el fabricante fue añadido correctamente, `false` si ya existe.
    func add(toAdd: ManufacturerModel) -> Bool {
        if manufacturers.contains(where: { $0 == toAdd } ) {
            print("Error while adding manufacturer \"\(toAdd)\": it was already added")
            return false
        }
        manufacturers.append(toAdd)
        print("Succesfully added manufacturer \"\(toAdd)\"")
        return true
    }
    
    /// Edita un fabricante existente en la lista.
    ///
    /// - Parameters:
    ///   - toEdit: Fabricante a editar.
    ///   - edited: Nueva información del fabricante.
    /// - Returns: `true` si la edición fue exitosa, `false` si el nuevo fabricante ya existe.
    func edit(toEdit: ManufacturerModel, edited: ManufacturerModel) -> Bool {
        if manufacturers.contains(where: { $0 != toEdit && $0 == edited } ) {
            print("Error while editing manufacturer \"\(toEdit)\": the edition is already added")
            return false
        }
        if let index = manufacturers.firstIndex(where: { $0 == toEdit }) {
            manufacturers[index].id = edited.id
            manufacturers[index].name = edited.name
            manufacturers[index].location = edited.location
            manufacturers[index].logoName = edited.logoName
            manufacturers[index].beers = edited.beers
            print("Successfully edited \"\(toEdit)\"")
            return true
        }
        print("Error while editing manufacturer \"\(toEdit)\": manufacturer not found")
        return false
    }
    
    /// Elimina un fabricante de la lista.
    ///
    /// - Parameters:
    ///   - toRemove: Fabricante a eliminar.
    /// - Returns: `true` si el fabricante fue eliminado correctamente, `false` si no se encontró.
    func remove(toRemove: ManufacturerModel) -> Bool {
        if let index = manufacturers.firstIndex(where: { $0 == toRemove }) {
            manufacturers.remove(at: index)
            print("Successfully removed manufacturer \"\(toRemove)\"")
            return true
        }
        print("Error while removing manufacturer \"\(toRemove)\": manufacturer not found")
        return false
    }
    
    /// Elimina todos los fabricantes de la lista.
    func clear() {
        manufacturers.removeAll()
        print("Cleared all manufacturers")
    }
    
    /// Verifica si la lista de fabricantes está vacía.
    ///
    /// - Returns: `true` si la lista está vacía, `false` en caso contrario.
    func isEmpty() -> Bool {
        return manufacturers.isEmpty
    }
}
