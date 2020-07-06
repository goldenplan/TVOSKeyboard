//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 05.07.2020.
//

import Foundation
import Cartography
import UIKit

public extension UIView{
    
    func addLayoutGuide() -> UIFocusGuide {
        let focusGuide = UIFocusGuide()
        self.addLayoutGuide(focusGuide)
        constrain(focusGuide, self) {
            guide, view in
            guide.bottom == view.bottom
            guide.trailing == view.trailing
            guide.leading == view.leading
            guide.top == view.top
        }
        return focusGuide
    }
    
}
