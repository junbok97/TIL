import Foundation

public extension Encodable {
    
    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601 // 서버와 싱크 필요
        return try encoder.encode(self)
    }
    
    func parameters() -> [String: Any] {
        guard let jsonData = try? jsonData() else { return [:] }
        let parameters = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        return parameters ?? [:]
    }
    
}
