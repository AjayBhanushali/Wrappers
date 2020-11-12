//
//  NSLayoutConstraint+Extensions.swift
//  AssignmentBMS
//
//  Created by Ajay on 10/10/20.
//  Copyright © 2020 Ajay Bhanushali. All rights reserved.
//

import Foundation

import Foundation
import UIKit

#if swift(>=4.2)
import UIKit.UIGeometry
extension UIEdgeInsets {
    public static let zero = UIEdgeInsets()
}
#endif

//MARK: NSLayoutConstraint Convenience methods
extension NSLayoutConstraint {
    
    // Pins an attribute of a view to an attribute of another view
    static func pinning(view: UIView,attribute: NSLayoutConstraint.Attribute,toView: UIView?,toAttribute: NSLayoutConstraint.Attribute,multiplier: CGFloat,constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view,attribute: attribute,relatedBy: .equal,toItem: toView,attribute:toAttribute,multiplier: multiplier,constant: constant)
    }
    
    // Pins an array of NSLayoutAttributes of a view to a specific view (has to respect view tree hierarchy)
    static func pinning(view: UIView,toView: UIView?,attributes: [NSLayoutConstraint.Attribute],multiplier: CGFloat,constant: CGFloat) -> [NSLayoutConstraint] {
        return attributes.compactMap({ (attribute) -> NSLayoutConstraint in
            return NSLayoutConstraint(item: view,attribute: attribute,relatedBy: .equal,toItem: toView,attribute: attribute,multiplier: multiplier,constant: constant)
        })
    }
    
    // Pins bottom,top,leading and trailing of a view to a specific view (has to respect view tree hierarchy)
    static func pinningEdges(view: UIView,toView: UIView?) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.top,.bottom,.leading,.trailing]
        return NSLayoutConstraint.pinning(view: view,toView: toView,attributes: attributes,multiplier: 1.0,constant: 0.0)
    }
    
    // Pins bottom,top,leading and trailing of a view to its superview
    static func pinningEdgesToSuperview(view: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.pinningEdges(view: view,toView: view.superview)
    }
    
    // Pins specified attribute to superview with specified or default multiplier and constant
    static func pinningToSuperview(view: UIView,attributes: [NSLayoutConstraint.Attribute],multiplier: CGFloat,constant: CGFloat) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.pinning(view: view,toView: view.superview,attributes: attributes,multiplier: multiplier,constant: constant)
    }
}

//MARK: UIView Convenience methods
extension UIView {
    
    func pinEdgesToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        let constraints = NSLayoutConstraint.pinningEdgesToSuperview(view: self)
        superview.addConstraints(constraints)
    }
    
    func pinToSuperview(forAtrributes attributes: [NSLayoutConstraint.Attribute],
                        multiplier: CGFloat = 1.0,constant: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        let constraints = NSLayoutConstraint.pinningToSuperview(view: self,attributes: attributes,multiplier: multiplier,constant: constant)
        superview.addConstraints(constraints)
    }
    
    func pin(toView: UIView,attributes: [NSLayoutConstraint.Attribute],multiplier: CGFloat = 1.0,constant: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        let constraints = NSLayoutConstraint.pinning(view: self,toView: toView,attributes: attributes,multiplier: multiplier,constant: constant)
        superview.addConstraints(constraints)
    }
    
    func pin(attribute: NSLayoutConstraint.Attribute,toView: UIView? = nil,toAttribute: NSLayoutConstraint.Attribute,multiplier: CGFloat = 1.0,constant: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        let constraint = NSLayoutConstraint.pinning(view: self,attribute: attribute,toView: toView,toAttribute: toAttribute,multiplier: multiplier,constant: constant)
        superview.addConstraint(constraint)
    }
    
    
    // Added
    
    func pinToSuperviewOnly(atrribute: NSLayoutConstraint.Attribute,constant: CGFloat = 0.0){
        pinToSuperview(forAtrributes: [atrribute],constant: constant)
    }
    
    func pinTo(atrribute: NSLayoutConstraint.Attribute,
               toView: UIView? = nil,toAttribute: NSLayoutConstraint.Attribute? = nil,constant: CGFloat = 0.0){
        pin(attribute: atrribute,toView: toView,toAttribute: toAttribute ?? atrribute,constant: constant)
    }
    
    func pinToSuperview(atrribute: NSLayoutConstraint.Attribute,toAttribute: NSLayoutConstraint.Attribute? = nil,constant: CGFloat = 0.0){
        
        guard let superView = superview else { return }
        pin(attribute: atrribute,toView: superView,toAttribute: toAttribute ?? atrribute,constant: constant)
    }
    
    func pinToSuperview(atrribute: NSLayoutConstraint.Attribute,toAttribute: NSLayoutConstraint.Attribute,constant: CGFloat){
        pin(attribute: atrribute,toView: superview,toAttribute: toAttribute,constant: constant)
    }
    
    func pinEdgesEquallyToSuperview(atrributes: [NSLayoutConstraint.Attribute]? = nil,
                                    constant: CGFloat = 0){
        
        for atrribute in Array(Set(atrributes ?? [.top,.leading,.trailing,.bottom])) {
            switch atrribute {
            case .top: pinToSuperview(atrribute: .top,constant: constant)
            case .leading: pinToSuperview(atrribute: .leading,constant: constant)
            case .trailing: pinToSuperview(atrribute: .trailing,constant: -constant)
            case .bottom: pinToSuperview(atrribute: .bottom,constant: -constant)
            case .centerX: pinToSuperview(atrribute: .centerX)
            case .centerY: pinToSuperview(atrribute: .centerY)
            default: break
            }
        }
    }
    
    func pinHeightWidth(constant heightWidth: CGFloat) {
        pinWidth(heightWidth)
        pinHeight(heightWidth)
    }
    
    func pin(height : CGFloat,width: CGFloat) {
        pinWidth(width)
        pinHeight(height)
    }
    
    func pinHeight(_ constant: CGFloat) {
        pin(attribute: .height,toAttribute: .notAnAttribute,constant: constant)
    }
    
    func pinWidth(_ constant: CGFloat) {
        pin(attribute: .width,toAttribute: .notAnAttribute,constant: constant)
    }
}
