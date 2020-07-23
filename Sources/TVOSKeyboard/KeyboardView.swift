//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 04.07.2020.
//

import Foundation
import UIKit
import Cartography

public class KeyboardView: UIView  {
    
    public var config: KeyboardConfig!{
        didSet{
            isUppercased = config.isUppercasedOnStart
            setDefaultType()
        }
    }
    
    private var keyboardStack: UIStackView!
    private var keyboardOptionalStack: UIStackView!
    private var keyboardMainStack: UIStackView!
    private var keyboardButtonsSummary: UIStackView!
    private var keyboardTypesStack: UIStackView!
    private var deleteButton: KeyboardButton!
    private var spaceButton: KeyboardButton!
    private var langButton: KeyboardButton!
    private var largeCaseButton: KeyboardButton!
    private var smallCaseButton: KeyboardButton!
    private var simbolsButton: KeyboardButton!
    private var numberButton: KeyboardButton!
    private var keyboardButtons: [[KeyboardButton]] = []
    public var keyboardButtonsTitles: [String]{
        currentKeyboardDescription.getSimbols(isUppercased: isUppercased)
    }
    
    
    weak var fastTransitionTimer: Timer?
    
    var isUppercased: Bool = false
    
    var isLangSwitchEnable: Bool{
        return config.keyboardDescriptions.count > 1
    }
    
    private var cachedString: String = ""{
        didSet{
            delegate.updateString(cachedString)
        }
    }
    
    var focusState: KeyboardState!{
        willSet(nextState){
            
            if focusState != nextState{
                startFastTransitionTimer()
            }
            
        }
        didSet{
            
            switch focusState {
            case .lastButtonsRow:
                
                buttonsBottomRightGuide?.preferredFocusEnvironments = deleteButton != nil ? [deleteButton] : []
                buttonsBottomLeftGuide?.preferredFocusEnvironments = spaceButton != nil ? [spaceButton] : []
                
                if
                    !config.hideOptionalPanel,
                    let leftView = keyboardOptionalStack.arrangedSubviews.first(where: { $0 is KeyboardButton
                }),
                    let rightView = keyboardOptionalStack.arrangedSubviews.last(where: { $0 is KeyboardButton
                    }){
                    
                    optionalsLeftGuide.preferredFocusEnvironments = [leftView]
                    optionalsRightGuide.preferredFocusEnvironments = [rightView]
                }
                
                
                if spaceTopGuide != nil && spaceBottomGuide != nil{
                    spaceTopGuide.preferredFocusEnvironments = [spaceButton]
                    spaceBottomGuide.preferredFocusEnvironments = [spaceButton]
                }
                if deleteTopGuide != nil && deleteBottomGuide != nil{
                    deleteTopGuide.preferredFocusEnvironments = [deleteButton]
                    deleteBottomGuide.preferredFocusEnvironments = [deleteButton]
                }
                
            case .buttons:
                
                if keyboardButtons.count > 1{
                    buttonsBottomRightGuide?.preferredFocusEnvironments = [keyboardButtons.last!.last!]
                    buttonsBottomLeftGuide?.preferredFocusEnvironments = [keyboardButtons.last!.first!]
                }else if
                    keyboardOptionalStack != nil,
                    let leftView = keyboardOptionalStack.arrangedSubviews.first(where: { $0 is KeyboardButton
                }),
                    let rightView = keyboardOptionalStack.arrangedSubviews.last(where: { $0 is KeyboardButton
                    }){
                    
                    buttonsBottomLeftGuide?.preferredFocusEnvironments = [leftView]
                    buttonsBottomRightGuide?.preferredFocusEnvironments = [rightView]
                    
                    optionalsLeftGuide.preferredFocusEnvironments = [leftView]
                    optionalsRightGuide.preferredFocusEnvironments = [rightView]
                }
                
                if spaceTopGuide != nil && spaceBottomGuide != nil{
                    spaceTopGuide.preferredFocusEnvironments = [spaceButton]
                    spaceBottomGuide.preferredFocusEnvironments = [spaceButton]
                }
                if deleteTopGuide != nil && deleteBottomGuide != nil{
                    deleteTopGuide.preferredFocusEnvironments = [deleteButton]
                    deleteBottomGuide.preferredFocusEnvironments = [deleteButton]
                }
                
            case .delete:
                if config.topFocusedElement != nil{
                    deleteTopGuide.preferredFocusEnvironments = [config.topFocusedElement!]
                }
                
                if !config.hideOptionalPanel,
                    let rightView = keyboardOptionalStack.arrangedSubviews.last(where: { $0 is KeyboardButton
                    }){
                    
                    deleteBottomGuide.preferredFocusEnvironments = [rightView]
                }
                
                
                buttonsBottomRightGuide?.preferredFocusEnvironments = [keyboardButtons.first!.last!]
                
            case .space:
                
                if config.topFocusedElement != nil{
                    spaceTopGuide.preferredFocusEnvironments = [config.topFocusedElement!]
                }
                
                if  !config.hideOptionalPanel,
                    let leftView = keyboardOptionalStack.arrangedSubviews.first(where: { $0 is KeyboardButton
                }){
                    spaceBottomGuide.preferredFocusEnvironments = [leftView]
                }
                
                
                buttonsBottomLeftGuide?.preferredFocusEnvironments = [keyboardButtons.first!.first!]
                
            case .optionals:
                
                buttonsBottomLeftGuide?.preferredFocusEnvironments = [keyboardButtons.last!.first!]
                buttonsBottomRightGuide?.preferredFocusEnvironments = [keyboardButtons.last!.last!]
                
                if spaceTopGuide != nil && spaceBottomGuide != nil{
                    spaceBottomGuide.preferredFocusEnvironments = [spaceButton]
                }
                if deleteTopGuide != nil && deleteBottomGuide != nil{
                    deleteBottomGuide.preferredFocusEnvironments = [deleteButton]
                }
                
                optionalsLeftGuide.preferredFocusEnvironments = []
                optionalsRightGuide.preferredFocusEnvironments = []
            default:
                break
            }
            
        }
    }
    

    private var simbolsButtonTitle: String{
        Presets.simbols.label
    }
    private var numberButtonTitle: String{
        Presets.numbers.label
    }
    
    private var caseSmallButtonTitle: String{
        
        switch currentKeyboardDescription.type {
        case .letters:
            return currentKeyboardDescription.label.lowercased()
        default:
            return prevKeyboardDescription.label.lowercased()
        }
        
    }
    
    private var caseLargeButtonTitle: String{
        
        switch currentKeyboardDescription.type {
        case .letters:
            return currentKeyboardDescription.label.uppercased()
        default:
            return prevKeyboardDescription.label.uppercased()
        }
    }
    
    private var currentFocusedElement: KeyboardButton!
    
    public weak var delegate: KeyboardViewProtocol!
    
    private var spaceTopGuide: UIFocusGuide!
    private var spaceBottomGuide: UIFocusGuide!
    private var deleteTopGuide: UIFocusGuide!
    private var deleteBottomGuide: UIFocusGuide!
    private var buttonsBottomLeftGuide: UIFocusGuide?
    private var buttonsBottomRightGuide: UIFocusGuide?
    private var optionalsLeftGuide: UIFocusGuide!
    private var optionalsRightGuide: UIFocusGuide!
    
    private var backgroundView: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        background.layer.cornerRadius = 5
        background.layer.masksToBounds = true
        return background
    }()
    
    var prevKeyboardDescription: KeyboardDescription!
    
    var currentKeyboardDescription: KeyboardDescription!{
        didSet{
            
            switch currentKeyboardDescription.type {
            case .letters:
                prevKeyboardDescription = currentKeyboardDescription
            default:
                break
            }
            
            updateType()
        }
    }
    
    public override var preferredFocusEnvironments: [UIFocusEnvironment]{
        
        if currentFocusedElement != nil{
            return [currentFocusedElement]
        }else if let firstElement = keyboardButtons.first?.first{
            return [firstElement]
        }else{
            return []
        }
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGesture()
    }
    
    private func setDefaultType(){
        
        if let preferredLanguage = Locale.preferredLanguages.first,
            let defaultKeyboard = config.keyboardDescriptions.first(where: { (keyboardDescription) -> Bool in
            return preferredLanguage.contains(keyboardDescription.code)
           }){
            currentKeyboardDescription = defaultKeyboard
        }else if let firstKeyboardDescription = config.keyboardDescriptions.first{
            currentKeyboardDescription = firstKeyboardDescription
        }
        
    }
    
    private func setupGesture(){
    
        let swipeGestureFromDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandleFromDown))
        swipeGestureFromDown.direction = .up
        self.addGestureRecognizer(swipeGestureFromDown)
    }
    
    @objc private func swipeHandleFromDown(){
        
        guard
            let delegate = delegate,
            fastTransitionTimer == nil else {
            return
        }
        
        if keyboardButtons.first!.contains(currentFocusedElement) ||
            currentFocusedElement == spaceButton ||
            currentFocusedElement == deleteButton{
            delegate.swipeFromDown()
        }
        
        
    }
    
    private func updateType(){
        
        setupView()
        setUpContrainsts()
        colorizeOptionButtons()
        updateTitleOptionalsButtons()
        
    }
    
    private func setupView(){
        
        setUpKeyboardStack()
        setUpMainStack()
        
        if !config.hideOptionalPanel{
            setUpOptionalStack()
        }
        
        setUpSummaryStack()
        generateButtonStacks()
        
        if config.allowDeleteButton{
            setUpDeleteButton()
        }
        
        if config.allowSpaceButton{
            setUpSpaceButton()
        }
        
        if !config.hideOptionalPanel{
            setUpOptionalStackBackground()
        }
        
    }
    
    private func setUpOptionalStackBackground(){
        
        if let leftView = keyboardOptionalStack.arrangedSubviews.first(where: { $0 is KeyboardButton
        }),
            let rightView = keyboardOptionalStack.arrangedSubviews.last(where: { $0 is KeyboardButton
            }){
         
            insertSubview(backgroundView, at: 0)
            constrain(leftView, rightView, backgroundView) {
                leftView, rightView, background in
                background.leading == leftView.leading
                background.trailing == rightView.trailing
                background.top == rightView.top
                background.bottom == rightView.bottom
            }
            
        }
        
    }
    
    private func setUpKeyboardStack(){
        
        guard keyboardStack == nil else {
            return
        }

        keyboardStack = UIStackView()
        keyboardStack.distribution = .equalSpacing
        keyboardStack.axis = .vertical
        keyboardStack.alignment = .fill
        keyboardStack.spacing = config.keyboardStackSpacing
        addSubview(keyboardStack)

    }
    
    private func setUpOptionalStack(){
        
        guard keyboardOptionalStack == nil else {
            return
        }
        
        keyboardOptionalStack = UIStackView()
        keyboardOptionalStack.distribution = .fill
        keyboardOptionalStack.axis = .horizontal
        keyboardOptionalStack.alignment = .fill
        keyboardOptionalStack.spacing = config.keyboardOptionalButtonsStackSpacing
        keyboardStack.addArrangedSubview(keyboardOptionalStack)
        
        if isLangSwitchEnable{
            setUpLangButton()
        }
        
        
        setUpCaseLargeButton()
        setUpCaseSmallButton()
        
        if config.allowNumeric{
            setUpNumberButton()
        }
        
        if config.allowSimbolic{
            setUpSimbolsButton()
        }
        
        let spaces = addSpacer(for: keyboardOptionalStack)
        optionalsLeftGuide = spaces.first.addLayoutGuide()
        optionalsRightGuide = spaces.second.addLayoutGuide()
        
    }
    
    private func setUpMainStack(){
        
        if keyboardMainStack != nil{
            keyboardMainStack.removeFromSuperview()
        }
        
        keyboardMainStack = UIStackView()
        keyboardMainStack.distribution = .equalSpacing
        keyboardMainStack.axis = .horizontal
        keyboardMainStack.alignment = .fill
        keyboardMainStack.spacing = config.keyboardButtonsStackSpacing
        keyboardStack.insertArrangedSubview(keyboardMainStack, at: 0)
        
    }
    
    private func setUpSummaryStack(){
        
        keyboardButtonsSummary = UIStackView()
        keyboardButtonsSummary.distribution = .equalSpacing
        keyboardButtonsSummary.axis = .vertical
        keyboardButtonsSummary.alignment = .fill
        keyboardButtonsSummary.spacing = config.keyboardButtonsSummaryStackSpacing
        keyboardMainStack.addArrangedSubview(keyboardButtonsSummary)
        
    }
    
    private func generateButtonStacks(){
        
        var currentButtonCountOnStacks = 0
        keyboardButtons = []
        
        var currentLimit = config.simbolLimitOnLine
        if currentLimit == 26 && keyboardButtonsTitles.count > 26{
            let half: Double = Double(keyboardButtonsTitles.count) / 2
            currentLimit = lroundf(Float(half))
        }
        
        repeat {
         
            let endCount = currentButtonCountOnStacks + currentLimit!
            
            if let stack = getButtonStack(from: currentButtonCountOnStacks, to: endCount){
                keyboardButtonsSummary.addArrangedSubview(stack)
            }
            
            currentButtonCountOnStacks = endCount
         
        } while currentButtonCountOnStacks <= keyboardButtonsTitles.count
        
        
    }
    
    private func getButtonStack(from: Int, to: Int) -> UIStackView?{
        
        guard from != min(keyboardButtonsTitles.count, to) else {
            return nil
        }
        
        let keyboardButtonsStack = UIStackView()
        keyboardButtonsStack.distribution = .fill
        keyboardButtonsStack.axis = .horizontal
        keyboardButtonsStack.alignment = .fill
        keyboardButtonsStack.spacing = config.keyboardButtonsStackSpacing
        
        var rowButtons: [KeyboardButton] = []
        
        keyboardButtonsTitles[from..<min(keyboardButtonsTitles.count, to)].forEach {
            let button = getKeyboardButton(withTitle: $0)
            rowButtons.append(button)
            button.addTarget(self, action: #selector(KeyboardButtonWasPressed), for: .primaryActionTriggered)

            button.titleFont = config.keyboardFont
            button.tag = 3
            
            button.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)

            keyboardButtonsStack.addArrangedSubview(button)
            
            constrain(button) {
                button in
                button.width == config.keyboardButtonsWidth
                
            }
        }
        
        keyboardButtons.append(rowButtons)
        
        
        if keyboardButtonsTitles.count - from < config.simbolLimitOnLine! &&
            keyboardButtonsTitles.count - from > 0{
            
            let spaces = addSpacer(for: keyboardButtonsStack)
            buttonsBottomLeftGuide = spaces.first.addLayoutGuide()
            buttonsBottomRightGuide = spaces.second.addLayoutGuide()
            
        }else{
            
            addSpacer(for: keyboardButtonsStack)
        }
        
        
        return keyboardButtonsStack
        
    }
    
    
    
    @discardableResult
    private func addSpacer(for stack: UIStackView) -> (first: UIView, second: UIView){
        
        let placeholder1 = UIView()
        let placeholder2 = UIView()
        
        placeholder1.backgroundColor = config.isDebug ? .lightGray : .clear
        placeholder2.backgroundColor = config.isDebug ? .lightGray : .clear
        
        stack.insertArrangedSubview(placeholder1, at: 0)
        stack.addArrangedSubview(placeholder2)
        
        constrain(placeholder1, placeholder2) {
            placeholder1, placeholder2 in
            placeholder1.width == placeholder2.width
            placeholder1.height == placeholder2.height
        }
        
        return (first: placeholder1, second: placeholder2)
        
    }
    
    private func setUpNumberButton() {
        numberButton = getKeyboardButton(
            withTitle: numberButtonTitle)
        numberButton.accessibilityIdentifier = "Keyboard.Button.Number"
        numberButton.accessibilityLabel = "Number"
        numberButton.titleFont = config.numberButtonFont
        
        numberButton.tag = 2
        numberButton.sizeToFit()
        numberButton.addTarget(self, action: #selector(numberButtonWasPressed), for: .primaryActionTriggered)
        
        numberButton.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: 0,
                                                      right: 0)
        
        keyboardOptionalStack.addArrangedSubview(numberButton)
        
        constrain(numberButton) {
            simbolsButton in
            simbolsButton.width == config.keyboardOptionalButtonsWidth
        }
        
    }
    
    private func setUpSimbolsButton() {
        simbolsButton = getKeyboardButton(
            withTitle: simbolsButtonTitle)
        simbolsButton.accessibilityIdentifier = "Keyboard.Button.Lang"
        simbolsButton.accessibilityLabel = "Lang"
        simbolsButton.titleFont = config.simbolsButtonFont
        
        simbolsButton.tag = 2
        simbolsButton.sizeToFit()
        simbolsButton.addTarget(self, action: #selector(simbolsButtonWasPressed), for: .primaryActionTriggered)
        
        simbolsButton.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: 0,
                                                      right: 0)
        
        keyboardOptionalStack.addArrangedSubview(simbolsButton)
        
        constrain(simbolsButton) {
            simbolsButton in
            simbolsButton.width == config.keyboardOptionalButtonsWidth
        }
        
    }
    
    private func setUpLangButton() {
        langButton = getKeyboardButton(
            image: config.langButtonImage)
        langButton.accessibilityIdentifier = "Keyboard.Button.Lang"
        langButton.accessibilityLabel = "Lang"
        langButton.titleFont = config.langButtonFont
        
        langButton.tag = 2
        langButton.sizeToFit()
        langButton.addTarget(self, action: #selector(langButtonWasPressed), for: .primaryActionTriggered)
        
        langButton.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: 0,
                                                      right: 0)
        
        keyboardOptionalStack.addArrangedSubview(langButton)
        
        constrain(langButton) {
            langButton in
            langButton.width == config.keyboardOptionalButtonsWidth
        }
        
    }
    
    private func setUpCaseLargeButton() {
        largeCaseButton = getKeyboardButton(
            withTitle: caseLargeButtonTitle)
        largeCaseButton.accessibilityIdentifier = "Keyboard.Button.Case"
        largeCaseButton.accessibilityLabel = "Case"
        largeCaseButton.titleFont = config.caseButtonFont
        
        largeCaseButton.tag = 2
        largeCaseButton.sizeToFit()
        largeCaseButton.addTarget(self, action: #selector(caseLargeButtonWasPressed), for: .primaryActionTriggered)
        
        largeCaseButton.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: 0,
                                                      right: 0)
        
        keyboardOptionalStack.addArrangedSubview(largeCaseButton)
        
        constrain(largeCaseButton) {
            langButton in
            langButton.width == config.keyboardOptionalButtonsWidth
        }
    }
    
    private func setUpCaseSmallButton() {
        smallCaseButton = getKeyboardButton(
            withTitle: caseSmallButtonTitle)
        smallCaseButton.accessibilityIdentifier = "Keyboard.Button.Case"
        smallCaseButton.accessibilityLabel = "Case"
        smallCaseButton.titleFont = config.caseButtonFont
        
        smallCaseButton.tag = 2
        smallCaseButton.sizeToFit()
        smallCaseButton.addTarget(self, action: #selector(caseSmallButtonWasPressed), for: .primaryActionTriggered)
        
        smallCaseButton.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: 0,
                                                      right: 0)
        
        keyboardOptionalStack.addArrangedSubview(smallCaseButton)
        
        constrain(smallCaseButton) {
            langButton in
            langButton.width == config.keyboardOptionalButtonsWidth
        }
    }
    
    private func setUpDeleteButton() {
        
        let deleteButtonStack = UIStackView()
        deleteButtonStack.distribution = .fill
        deleteButtonStack.axis = .vertical
        deleteButtonStack.alignment = .fill
        deleteButtonStack.spacing = config.keyboardButtonsStackSpacing
        
        
        deleteButton = getKeyboardButton(
            image: config.deleteButtonImage)
        deleteButton.tag = 1
        deleteButton.accessibilityIdentifier = "Keyboard.Button.Delete"
        deleteButton.accessibilityLabel = "Delete"
        deleteButton.titleFont = config.deleteButtonFont
        
        deleteButton.sizeToFit()
        deleteButton.addTarget(self, action: #selector(deleteButtonWasPressed), for: .primaryActionTriggered)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(deleteButtonLongPress))
        deleteButton.addGestureRecognizer(longGesture)
        
        deleteButton.contentEdgeInsets = UIEdgeInsets(top: 10,
                                                      left: 0,
                                                      bottom: 10,
                                                      right: 0)
        
        deleteButtonStack.addArrangedSubview(deleteButton)
        
        constrain(deleteButton) {
            deleteButton in
            deleteButton.width == config.keyboardButtonsWidth
        }
        
        let spaces = addSpacer(for: deleteButtonStack)
        deleteTopGuide = spaces.first.addLayoutGuide()
        deleteBottomGuide = spaces.second.addLayoutGuide()
        
        keyboardMainStack.addArrangedSubview(deleteButtonStack)
    }
    
    @objc private func deleteButtonLongPress(){
        delegate.deleteLongPress()
        cachedString = ""
    }
    
    private func setUpSpaceButton() {
        
        let spaceButtonStack = UIStackView()
        spaceButtonStack.distribution = .fill
        spaceButtonStack.axis = .vertical
        spaceButtonStack.alignment = .fill
        spaceButtonStack.spacing = config.keyboardButtonsStackSpacing
        
        var spaceButtonTitle: String
        switch currentKeyboardDescription.type {
        case .letters:
            spaceButtonTitle = currentKeyboardDescription.spaceName!
        default:
            spaceButtonTitle = prevKeyboardDescription.spaceName!
        }
        
        spaceButton = getKeyboardButton(
            withTitle: spaceButtonTitle,
            isExtraTitle: true)
        spaceButton.tag = 0
        spaceButton.accessibilityIdentifier = "Keyboard.Button.Space"
        spaceButton.accessibilityLabel = "Space"
        spaceButton.titleFont = config.spaceButtonFont
        spaceButton.normalSpaceTitleColor = config.normalSpaceTitleColor
        spaceButton.focusedSpaceTitleColor = config.focusedSpaceTitleColor
        spaceButton.normalSpaceBackgroundColor = config.normalSpaceBackgroundColor
        spaceButton.focusedSpaceBackgroundColor = config.focusedSpaceBackgroundColor
        
        spaceButton.sizeToFit()
        spaceButton.addTarget(self, action: #selector(spaceButtonWasPressed), for: .primaryActionTriggered)
        
        spaceButton.contentEdgeInsets = UIEdgeInsets(top: 5,
                                                      left: 10,
                                                      bottom: 5,
                                                      right: 10)
        
        
        
        spaceButtonStack.addArrangedSubview(spaceButton)
        
        let spaces = addSpacer(for: spaceButtonStack)
        spaceTopGuide = spaces.first.addLayoutGuide()
        spaceBottomGuide = spaces.second.addLayoutGuide()
        
        keyboardMainStack.insertArrangedSubview(spaceButtonStack, at: 0)
        
    }
    
    private func getKeyboardButton(withTitle title: String? = nil, image: UIImage? = nil, isExtraTitle: Bool = false) -> KeyboardButton {
        let keyboardButton = KeyboardButton()
        
        if image != nil{
            keyboardButton.setImage(image, for: .normal)
        }else if isExtraTitle{
            keyboardButton.extraTitle = title
        }else if image == nil && title != nil{
            keyboardButton.setTitle(title, for: .normal)
        }
        
        keyboardButton.accessibilityIdentifier = "Keyboard.Button.\(title ?? "")"
        keyboardButton.sizeToFit()
        
        keyboardButton.normalTitleColor = config.keyboardNormalTitleColor
        keyboardButton.focusedTitleColor = config.keyboardFocusedTitleColor
        keyboardButton.focusedBackgroundColor = config.keyboardFocusedBackgroundColor
        keyboardButton.focusedBackgroundEndColor = config.keyboardFocusedBackgroundEndColor
        keyboardButton.normalBackgroundColor = config.keyboardNormalBackgroundColor
        keyboardButton.normalBackgroundEndColor = config.keyboardNormalBackgroundEndColor
    
        return keyboardButton
    }
    
    
    
    private func updateTitleOptionalsButtons(){
        
        guard !config.hideOptionalPanel else { return }
        
        smallCaseButton.setTitle(prevKeyboardDescription.label.lowercased(), for: .normal)
        largeCaseButton.setTitle(prevKeyboardDescription.label.uppercased(), for: .normal)
        
    }
    
    private func colorizeOptionButtons(){
        
        guard !config.hideOptionalPanel else { return }
        
        if isLangSwitchEnable{
            langButton.normalTitleColor = config.keyboardNormalTitleColor
        }
        
        largeCaseButton.normalTitleColor = config.keyboardNormalTitleColor
        smallCaseButton.normalTitleColor = config.keyboardNormalTitleColor
        if config.allowNumeric{
            numberButton.normalTitleColor = config.keyboardNormalTitleColor
        }
        if config.allowSimbolic{
            simbolsButton.normalTitleColor = config.keyboardNormalTitleColor
        }
        switch currentKeyboardDescription.type {
        case .letters:
            if isUppercased{
                largeCaseButton.normalTitleColor = .white
            }else{
                smallCaseButton.normalTitleColor = .white
            }
        case .numeric:
            numberButton.normalTitleColor = .white
        case .symbolic:
            simbolsButton.normalTitleColor = .white

        }
        
    }
    
    private func setUpContrainsts() {
        
        constrain(keyboardStack, self) {
            keyboardMainStack, view in
            keyboardMainStack.centerY == view.centerY
            keyboardMainStack.centerX == view.centerX
        }
        
        
    }
    
    private func startFastTransitionTimer(){
        
        fastTransitionTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(deleteFastTransitionTimer), userInfo: nil, repeats: false)
    }
    
    @objc private func deleteFastTransitionTimer(){
        
        if fastTransitionTimer != nil{
            fastTransitionTimer?.invalidate()
            fastTransitionTimer = nil
        }
        
    }
    
    public override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        super.shouldUpdateFocus(in: context)
        
        return fastTransitionTimer == nil
    }
    
    public override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if let keyboardButton = context.nextFocusedView as? KeyboardButton{
            currentFocusedElement = keyboardButton
            delegate.performFocus(element: keyboardButton)
        }
        
        
        if let button = context.nextFocusedView as? KeyboardButton,
            let nextState = KeyboardState(rawValue: button.tag){

            if nextState == .buttons &&
                keyboardButtons.count > 1 &&
            keyboardButtons.last!.contains(button){
                focusState = .lastButtonsRow
            }else{
                focusState = nextState
            }
            
            
        }
        
    }
    
    
    @objc
    private func KeyboardButtonWasPressed(sender: KeyboardButton) {
        
        guard
            let delegate = delegate,
            let keyboardValue = sender.titleLabel?.text else { return }
        delegate.addSimbol(keyboardValue)
        cachedString = cachedString + keyboardValue
    }
    
    @objc
    private func langButtonWasPressed(sender: KeyboardButton) {
        
        if let currentIndex = config.keyboardDescriptions.firstIndex(where: { (keyboardDescription) -> Bool in
            return currentKeyboardDescription.code == keyboardDescription.code
        }){
            if currentIndex == config.keyboardDescriptions.count - 1{
                currentKeyboardDescription = config.keyboardDescriptions.first
            }else{
                currentKeyboardDescription = config.keyboardDescriptions[currentIndex + 1]
            }
        }else if let firstKeyboardDescription = config.keyboardDescriptions.first{
            currentKeyboardDescription = firstKeyboardDescription
        }
        
    }
    
    
    @objc
    private func numberButtonWasPressed(sender: KeyboardButton) {
        
        currentKeyboardDescription = Presets.numbers
        
    }
    
    @objc
    private func deleteButtonWasPressed(sender: KeyboardButton) {
        
        guard let delegate = delegate else { return }
        delegate.deleteSimbol()
        if cachedString.count > 0{
            cachedString = String(cachedString.dropLast())
        }
    }
    
    @objc
    private func spaceButtonWasPressed(sender: KeyboardButton) {
        
        guard let delegate = delegate else { return }
        delegate.addSimbol(" ")
        cachedString = cachedString + " "
    }
    
    
    @objc
    private func simbolsButtonWasPressed(sender: KeyboardButton) {
        
        currentKeyboardDescription = Presets.simbols
    }
    
    @objc
    private func caseLargeButtonWasPressed(sender: KeyboardButton) {
        
        isUppercased = true
        currentKeyboardDescription = prevKeyboardDescription
    }
    
    @objc
    private func caseSmallButtonWasPressed(sender: KeyboardButton) {
        
        isUppercased = false
        currentKeyboardDescription = prevKeyboardDescription
    }
}

