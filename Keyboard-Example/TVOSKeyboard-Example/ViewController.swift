//
//  ViewController.swift
//  TVOSKeyboard-Eample
//
//  Created by Stanislav Belsky on 04.07.2020.
//  Copyright © 2020 Stanislav Belsky. All rights reserved.
//

import UIKit
import TVOSKeyboard

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    var focusedElement: UIView!{
        didSet{
            setNeedsFocusUpdate()
            updateFocusIfNeeded()
        }
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment]{
        return [focusedElement]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        focusedElement = keyboardView
        
        button.alpha = 0
        label.alpha = 0
        
        let config = KeyboardConfig()
        let cz = KeyboardDescription(code: "cz", type: .letters, simbols: "aábcčdďeéěfghiíjklmnňoópqrřsštťuúůvwxyýzž", label: "абв", spaceName: "mezera")
        config.keyboardDescriptions = [
            Presets.eng,
            cz
        ]
        config.topFocusedElement = button
        config.isUppercasedOnStart = true
        config.allowNumeric = false
        config.allowSimbolic = true
        config.allowSpaceButton = false
        config.allowDeleteButton = false
        config.hideOptionalPanel = false
        keyboardView.config = config
        keyboardView.delegate = self
    }
    
}

extension ViewController: KeyboardViewProtocol{
    
    func addSimbol(_ value: String){
        
        guard let text = label.text else { return }
        
        label.text = text + value
    }
    
    func deleteSimbol(){
        
        guard let text = label.text, text.count > 0 else { return }
        
        label.text = String(text.dropLast())
        
    }
    
    func swipeFromDown(){
        focusedElement = button
    }
    
    func deleteLongPress(){
        label.text = ""
    }
    
    func updateString(_ cachedString: String){
        button.setTitle(cachedString, for: .normal)
    }
    
    func performFocus(element: UIView) {
        focusedElement = element
    }
    
}

