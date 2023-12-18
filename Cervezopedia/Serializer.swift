import Foundation

/// Clase encargada de gestionar la serialización de datos utilizando UserDefaults y Codable.
struct Serializer {
    /// Instancia compartida de Serializer, utilizando el patrón Singleton.
    static let shared = Serializer()
    private let standard = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {}
    
    /// Guarda un valor codificable en UserDefaults asociado con la clave proporcionada.
    ///
    /// - Parameters:
    ///   - value: Valor codificable a guardar.
    ///   - key: Clave asociada con el valor.
    public func save<T: Codable>(value: T, key: String) {
        if let encoded = try? encoder.encode(value) {
            standard.setValue(encoded, forKey: key)
            standard.synchronize()
        }
    }
    
    /// Carga un valor decodificable desde UserDefaults asociado con la clave proporcionada.
    ///
    /// - Parameters:
    ///   - key: Clave asociada con el valor a cargar.
    ///   - defaultValue: Valor por defecto a devolver si no se encuentra ningún valor asociado a la clave.
    /// - Returns: Valor decodificado o el valor por defecto si no se encuentra ningún valor.
    public func load<T: Codable>(key: String, defaultValue: T? = nil) -> T? {
        if let data = standard.object(forKey: key) as? Data {
            if let decodedValue = try? decoder.decode(T.self, from: data) {
                return decodedValue
            }
        }
        return defaultValue
    }
}
