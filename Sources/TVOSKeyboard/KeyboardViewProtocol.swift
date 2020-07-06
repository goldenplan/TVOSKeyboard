//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 05.07.2020.
//

import Foundation
import UIKit

public protocol KeyboardViewProtocol: class {
    func addSimbol(_ value: String)
    func deleteSimbol()
    func swipeFromDown()
    func deleteLongPress()
    func updateString(_ cachedString: String)
    func performFocus(element: UIView)
}

public extension KeyboardViewProtocol{
    func addSimbol(_ value: String) {}
    func deleteSimbol() {}
    func swipeFromDown() {}
    func deleteLongPress() {}
    func updateString(_ cachedString: String) {}
    func performFocus(element: UIView) {}
}
