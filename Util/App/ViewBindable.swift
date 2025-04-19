import Foundation

public protocol ViewBindable {
    associatedtype State
    associatedtype OutputError: Error
    
    func bind()
    func render(_ state: State)
    func handleError(_ error: OutputError)
}

public extension ViewBindable {
    func handleError(_ error: OutputError) { }
}

