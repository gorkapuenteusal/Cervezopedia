//
//  Serializer.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 14/12/23.
//

import Foundation

struct Serializer {
    static let shared = Serializer()
    
    private let standard = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    
    private init() {}
    
    public func save<T: Codable>(value: T, key: String) {
        if let encoded = try? encoder.encode(value) {
            standard.setValue(encoded, forKey: key)
            standard.synchronize()
        }
    }
    
    public func load<T: Codable>(key: String, defaultValue: T? = nil) -> T? {
        if let data = standard.object(forKey: key) as? Data {
            if let t = try? decoder.decode(T.self, from: data) {
                return t
            }
        }
        return defaultValue;
    }
}
