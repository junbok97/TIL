import Foundation

public protocol ViewModelable {
    associatedtype Input
    associatedtype State
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}