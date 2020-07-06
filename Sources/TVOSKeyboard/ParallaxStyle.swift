//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 04.07.2020.
//

import UIKit

public struct ParallaxStyle {
    
    let min: CGFloat
    
    let max: CGFloat
    
    static let defaultParallaxStyle = ParallaxStyle(min: -4, max: 4)
    
    var motionEffectGroup: UIMotionEffectGroup {
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        
        return motionEffectGroup
    }
}

