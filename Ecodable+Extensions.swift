import Foundation

extension Encodable {
    // Converts the Model class to JSON Data
    func toJSONData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    // Converts the Model class to JSON string
    func toJSONString() throws -> String? {
        let jsonData = try JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)
    }
}
