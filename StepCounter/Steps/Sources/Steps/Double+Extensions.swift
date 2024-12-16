import SwiftUI

public extension Double {

    func toRadians() -> Double {
        return self * Double.pi / 180
    }

    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }

}
