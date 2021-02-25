//
// Created by Андрей Кривобок on 23.12.2020.
//

import Foundation

public struct Filter {

    public enum Operator {
        case EQ // Equal
        case NE // Not Equal
        case GE // Greater or Equal
        case LE // Lower or Equal
    }

    public enum ValueType {
        case UUID
        case OffsetDateTime
        case WorkSlotStatus
        case Boolean
    }

    var key: String
    var value: Any
    var `operator`: Operator
    var valueType: ValueType?
}

public struct Filters {
    var values: [Filter]
}

extension Filters: CustomStringConvertible {

    public var description: String {
        var description = ""
        for filter in values {
            description += "\(filter.key),\(filter.value),\(filter.operator)"
            if let valueType = filter.valueType { description += ",\(valueType)" }
            description += ";"
        }
        return description
    }
}
