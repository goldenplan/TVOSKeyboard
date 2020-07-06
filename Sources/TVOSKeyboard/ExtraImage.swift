//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 04.07.2020.
//

import Foundation
import Cartography
import UIKit

public class ExtraImage: UIView {
    
    var label: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var backgroundView: UIView = {
        
        let view = UIView()
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 15
        
        return view
    }()
    
    let borderHeight: CGFloat = 5
    let borderWidth: CGFloat = 7
    
    public init(text: String, font: UIFont, textColor: UIColor, backgroundColor: UIColor) {
        
        label.font = font
        label.textColor = textColor
        
        backgroundView.backgroundColor = backgroundColor

        let frame = CGRect(
            x: 0, y: 0,
            width: text.width(font: font) + borderWidth * 2,
            height: text.height(font: font) + borderHeight * 2)

        print("text.width(font: font)", text.width(font: font))
        print("text.height(font: font)", text.height(font: font))
        
        super.init(frame: frame)
        print("init", self)
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        label.text = text
        
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView(){
        
        addSubview(label)
        constrain(self, label) {
            view, label in
            label.leading == view.leading
            label.trailing == view.trailing
            label.centerY == view.centerY
        }
        
        insertSubview(backgroundView, at: 0)
        
        constrain(backgroundView, label) {
            backgroundView, label in
            backgroundView.leading == label.leading - borderWidth
            backgroundView.trailing == label.trailing + borderWidth
            backgroundView.top == label.top - borderWidth
            backgroundView.bottom == label.bottom + borderWidth
        }
        
    }
    
    public func asImage() -> UIImage {
        
        layoutIfNeeded()
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.cornerRadius = 5
            layer.masksToBounds = true
            layer.render(in: rendererContext.cgContext)
        }
    }
    
}

extension String{
    
    func height(withConstrainedWidth width: CGFloat = 1000, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat = 100, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}
