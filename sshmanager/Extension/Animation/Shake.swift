//
//  Animation.swift
//  sshmanager
//
//  Created by gejw on 2018/4/6.
//  Copyright © 2018 robinge. All rights reserved.
//

import Cocoa

public extension NSView {
    
    public func shake(dValue: CGFloat = 5, repeatCount: Float = 5) {
        layer?.shake(dValue: dValue, repeatCount: repeatCount)
    }

}

public extension CALayer {

    public func shake(dValue: CGFloat = 5, duration: CFTimeInterval = 0.05, repeatCount: Float = 5) {
        var fromValue: NSValue = NSValue(point: CGPoint.zero)
        var toValue: NSValue = NSValue(point: CGPoint.zero)
        fromValue = NSValue(point: CGPoint(x: position.x - dValue, y: position.y))
        toValue = NSValue(point: CGPoint(x: position.x + dValue, y: position.y))

        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = fromValue
        moveAnimation.toValue = toValue
        moveAnimation.autoreverses = false
        moveAnimation.repeatCount = repeatCount
        moveAnimation.isRemovedOnCompletion = true
        moveAnimation.fillMode = kCAFillModeForwards
        moveAnimation.duration = duration
        moveAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        add(moveAnimation, forKey: "moveAnimation")
    }

}
