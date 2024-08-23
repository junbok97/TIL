import Foundation

extension String {

    func toDate() -> Date? {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self) {
            return date
        }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: self) {
            return date
        }
        
        return nil
    }
    
}
