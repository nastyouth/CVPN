//
//  CustomButton.swift
//  CheburnetVPN
//
//  Created by Анастасия on 27.04.2020.
//  Copyright © 2020 Анастасия. All rights reserved.
//

import UIKit

@IBDesignable
class customButton: UIButton {
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            layer.cornerRadius = frame.height / 2
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = frame.height / 2
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
       
    @IBInspectable
    var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
       
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
}
