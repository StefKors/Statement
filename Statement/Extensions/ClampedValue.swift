//
//  ClampedValue.swift
//  Statement
//
//  Created by Stef Kors on 07/07/2023.
//

import Foundation

@propertyWrapper
struct Clamped<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>

    init(wrappedValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    var wrappedValue: Value {
        get { value }
        set {
            value = min(max(range.lowerBound, newValue), range.upperBound)
        }
    }
}
