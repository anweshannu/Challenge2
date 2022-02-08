//
//  Extensions.swift
//  Challenge2
//
//  Created by Anwesh M on 08/02/22.
//

import Foundation
import UIKit

extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 0.1
        )
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
