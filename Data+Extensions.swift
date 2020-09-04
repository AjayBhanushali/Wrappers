
import Foundation


extension Data {
    // Converts JSON data to specified object
    func fromJsonData<T : Decodable>(to type: T.Type) throws -> T {
        return  try JSONDecoder().decode(T.self, from: self)
    }
}
