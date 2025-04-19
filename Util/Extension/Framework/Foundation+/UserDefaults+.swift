import Foundation

public extension UserDefaults {
    
    // MARK: - Create
    static func saveData(key: String, _ data: Codable) {
        let encoder = JSONEncoder()
        if let encodedObject = try? encoder.encode(data) {
            standard.set(encodedObject, forKey: key)
        }
    }

    // MARK: - Read
    static func readData<T: Codable>(key: String, _ type: T) -> T? {
        let decoder = JSONDecoder()
        guard let savedData = standard.object(forKey: key) as? Data,
              let loadedObject = try? decoder.decode(T.self, from: savedData) else { return nil }
            
        return loadedObject
    }
    
}
