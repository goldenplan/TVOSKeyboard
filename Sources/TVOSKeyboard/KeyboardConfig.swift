//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 05.07.2020.
//

import Foundation
import UIKit

public class KeyboardConfig: DefaultKeyboardConfig{
    
    public var isDebug: Bool!
    public var keyboardDescriptions: [KeyboardDescription]!
    public var keyboardButtonsStackSpacing: CGFloat!
    public var keyboardButtonsSummaryStackSpacing: CGFloat!
    public var keyboardOptionalButtonsStackSpacing: CGFloat!
    public var keyboardStackSpacing: CGFloat!
    public var allowNumeric: Bool!
    public var allowSimbolic: Bool!
    public var hideOptionalPanel: Bool!
    public var keyboardNormalTitleColor: UIColor!
    public var keyboardFocusedTitleColor: UIColor!
    public var keyboardFocusedBackgroundColor: UIColor!
    public var keyboardFocusedBackgroundEndColor: UIColor!
    public var keyboardNormalBackgroundColor: UIColor!
    public var keyboardNormalBackgroundEndColor: UIColor!
    public var keyboardFont: UIFont!
    public var deleteButtonFont: UIFont!
    public var spaceButtonFont: UIFont!
    public var langButtonFont: UIFont!
    public var caseButtonFont: UIFont!
    public var simbolsButtonFont: UIFont!
    public var numberButtonFont: UIFont!
    public var deleteButtonImage: UIImage!
    public var langButtonImage: UIImage!
    public var simbolLimitOnLine: Int!
    public var allowSpaceButton: Bool!
    public var allowDeleteButton: Bool!
    public var topFocusedElement: UIView? = nil
    public var keyboardButtonsWidth: CGFloat!
    public var keyboardOptionalButtonsWidth: CGFloat!
    public var isUppercasedOnStart: Bool!
    
    public override init() {
        super.init()
        setDefaults()
    }
    
    func setDefaults(){
        
        isDebug = defaultIsDebug
        keyboardDescriptions = defaultKeyboardDescriptions
        keyboardButtonsStackSpacing = defaultKeyboardButtonsStackSpacing
        keyboardButtonsSummaryStackSpacing = defaultKeyboardButtonsSummaryStackSpacing
        keyboardOptionalButtonsStackSpacing = defaultKeyboardOptionalButtonsStackSpacing
        keyboardStackSpacing = defaultKeyboardStackSpacing
        allowNumeric = defaultAllowNumeric
        allowSimbolic = defaultAllowSimbolic
        keyboardNormalTitleColor = defaultKeyboardNormalTitleColor
        keyboardFocusedTitleColor = defaultKeyboardFocusedTitleColor
        keyboardFocusedBackgroundColor = defaultKeyboardFocusedBackgroundColor
        keyboardFocusedBackgroundEndColor = defaultKeyboardFocusedBackgroundEndColor
        keyboardNormalBackgroundColor = defaultKeyboardNormalBackgroundColor
        keyboardNormalBackgroundEndColor = defaultKeyboardNormalBackgroundEndColor
        keyboardFont = defaultKeyboardFont
        deleteButtonFont = defaultDeleteButtonFont
        spaceButtonFont = defaultSpaceButtonFont
        langButtonFont = defaultLangButtonFont
        caseButtonFont = defaultCaseButtonFont
        simbolsButtonFont = defaultSimbolsButtonFont
        numberButtonFont = defaultNumberButtonFont
        deleteButtonImage = defaultDeleteButtonImage
        langButtonImage = defaultLangButtonImage
        simbolLimitOnLine = defaultSimbolsLimitOnLine
        allowSpaceButton = defaultAllowSpaceButton
        allowDeleteButton = defaultAllowDeleteButton
        keyboardButtonsWidth = defaultKeyboardButtonsWidth
        keyboardOptionalButtonsWidth = defaultKeyboardOptionalButtonsWidth
        hideOptionalPanel = defaultHideOptionalPanel
        isUppercasedOnStart = defaultIsUppercasedOnStart
    }

}

public class DefaultKeyboardConfig{
    
    let defaultIsDebug = false
    let defaultKeyboardDescriptions: [KeyboardDescription] = [
        Presets.eng,
        Presets.rus
    ]
    let defaultKeyboardButtonsStackSpacing = CGFloat(5)
    let defaultKeyboardButtonsSummaryStackSpacing = CGFloat(10)
    let defaultKeyboardOptionalButtonsStackSpacing = CGFloat(10)
    let defaultKeyboardStackSpacing = CGFloat(20)
    let defaultAllowNumeric: Bool = true
    let defaultAllowSimbolic: Bool = true
    let defaultKeyboardNormalTitleColor: UIColor = UIColor.white.withAlphaComponent(0.7)
    let defaultKeyboardFocusedTitleColor: UIColor = .black
    let defaultKeyboardFocusedBackgroundColor: UIColor =
        UIColor(red: 200/255, green: 200/255, blue: 200/234, alpha: 1)
    let defaultKeyboardFocusedBackgroundEndColor: UIColor =
        UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    let defaultKeyboardNormalBackgroundColor: UIColor = .clear
    let defaultKeyboardNormalBackgroundEndColor: UIColor = .clear
    let defaultKeyboardFont: UIFont = .systemFont(ofSize: 45)
    let defaultDeleteButtonFont: UIFont = .boldSystemFont(ofSize: 30)
    let defaultSpaceButtonFont: UIFont = .boldSystemFont(ofSize: 18)
    let defaultLangButtonFont: UIFont = .systemFont(ofSize: 45, weight: .light)
    let defaultCaseButtonFont: UIFont = .systemFont(ofSize: 30)
    let defaultSimbolsButtonFont: UIFont = .systemFont(ofSize: 30)
    let defaultNumberButtonFont: UIFont = .systemFont(ofSize: 30)
    
    var defaultDeleteButtonImage: UIImage{
        let defaultDeleteImageConfig = UIImage.SymbolConfiguration(font: defaultDeleteButtonFont)
        let defaultdeleteButtonImageName = "delete.left.fill"
        return UIImage(systemName: defaultdeleteButtonImageName, withConfiguration: defaultDeleteImageConfig) ?? UIImage()
    }
    
    var defaultLangButtonImage: UIImage{
        let defaultLangImageConfig = UIImage.SymbolConfiguration(font: defaultLangButtonFont)
        let defaultLangButtonImageName = "globe"
        return UIImage(systemName: defaultLangButtonImageName, withConfiguration: defaultLangImageConfig) ?? UIImage()
    }
    
    let defaultSimbolsLimitOnLine: Int = 26
    
    let defaultAllowSpaceButton: Bool = true
    let defaultAllowDeleteButton: Bool = true
    let defaultHideOptionalPanel: Bool = false
    
    let defaultTopFocusedElement: UIView? = nil
    
    let defaultKeyboardButtonsWidth: CGFloat = 50
    let defaultKeyboardOptionalButtonsWidth: CGFloat = 100
    let defaultIsUppercasedOnStart = false
}
