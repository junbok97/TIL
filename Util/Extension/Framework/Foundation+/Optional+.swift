import Foundation

extension Optional<String> {
    var value: String {
        switch self {
        case .none:
            return ""
        case let .some(wrapped):
            return wrapped
        }
    }
}

extension Optional<Int> {
    var value: Int {
        switch self {
        case .none:
            return 0
        case let .some(wrapped):
            return wrapped
        }
    }
}

extension Optional<Double> {
    var value: Double {
        switch self {
        case .none:
            return 0
        case let .some(wrapped):
            return wrapped
        }
    }
}

extension Optional<TrueOrFalse> {
    var value: TrueOrFalse {
        switch self {
        case .none:
            return .False
        case let .some(wrapped):
            return wrapped
        }
    }

}
