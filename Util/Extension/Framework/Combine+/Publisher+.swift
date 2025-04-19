import Combine

extension Publisher {

    func withUnretained<O: AnyObject>(_ object: O) -> Publishers.CompactMap<Self, (O, Self.Output)> {
        return compactMap { [weak object] output in
            guard let object else { return nil }
            return (object, output)
        }
    }
    
    func withOnly<O: AnyObject>(_ object: O) -> Publishers.CompactMap<Self, O> {
        return compactMap { [weak object] _ in
            return object
        }
    }
    
}
