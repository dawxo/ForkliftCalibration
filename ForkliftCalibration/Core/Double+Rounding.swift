////  Double+Rounding.swift
//

extension Double {
    func roundedToTenth() -> Double {
        (self * 10).rounded() / 10
    }
}
