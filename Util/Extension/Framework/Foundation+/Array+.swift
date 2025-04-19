import Foundation

public extension Array {
    
    subscript(safe index: Int) -> Element? {
        self.indices ~= index ? self[index] : nil
    }
    
}
