////  Double+Rounding.swift
//

extension Double {
    func roundedToTenth() -> Double {
        (self * 10).rounded() / 10
    }

    func roundedToTenDecimalPlaces() -> Double {
        (self * 1e10).rounded() / 1e10
    }
}
