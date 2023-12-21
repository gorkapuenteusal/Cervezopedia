import Foundation

/// Clase encargada de gestionar la serialización de datos utilizando UserDefaults y Codable.
struct Serializer {
    // MARK: - Type properties
    /// Instancia compartida de Serializer, utilizando el patrón Singleton.
    static let shared = Serializer()
    
    // MARK: - Properties
    private let standard = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Methods
    /// Guarda un valor codificable en UserDefaults asociado con la clave proporcionada.
    ///
    /// - Parameters:
    ///   - value: Valor codificable a guardar.
    ///   - key: Clave asociada con el valor.
    public func save<T: Codable>(value: T, key: String) {
        do {
            let encoded = try encoder.encode(value)
            standard.setValue(encoded, forKey: key)
            standard.synchronize()
            
            print("Successfully saved \"\(key)\"")
        } catch {
            print("Error while saving \"\(key)\": FATAL ERROR!")
        }
    }
    
    /// Carga un valor decodificable desde UserDefaults asociado con la clave proporcionada.
    ///
    /// - Parameters:
    ///   - key: Clave asociada con el valor a cargar.
    ///   - defaultValue: Valor por defecto a devolver si no se encuentra ningún valor asociado a la clave.
    ///   
    /// - Returns: Valor decodificado o el valor por defecto si no se encuentra ningún valor.
    public func load<T: Codable>(key: String, defaultValue: T? = nil) -> T? {
        if let data = standard.object(forKey: key) as? Data {
            if let decodedValue = try? decoder.decode(T.self, from: data) {
                print("Successfully loaded \"\(key)\"")
                return decodedValue
            }
            print("Error while loading \"\(key)\": FATAL ERROR")
            return defaultValue
        }
        print("Error while loading \"\(key)\": No data found")
        return defaultValue
    }
}
