# TVOS Keyboard component

<p align="center">
<img src="https://github.com/goldenplan/TVOSKeyboard/blob/master/images/tvos_keyboard.jpg?raw=true" alt="Kingfisher" title="TVOSKeyboard" width="557"/>
</p>

A custom keyboard component for tvOS app development.

## Features

- [x] Can be used in any UIViewController.
- [x] You can enter text, numbers, and other characters using the touchpad.
- [x] Support for all input languages.
- [x] The keyboard style is almost identical to the native component, but can be changed if the developer wishes.
- [x] Ability to specify a focus element for switching from a component.

### Swift Package Manager Install

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Alamofire does support its use on supported platforms.

Once you have your Swift package set up, adding TVOSKeyboard as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/goldenplan/TVOSKeyboard", .upToNextMajor(from: "0.1.0"))
]
```

### Example

With the powerful options, you can do hard tasks with TVOSKeyboard in a simple way. For example, the code below:

1. Use Storyboard or code to create a keyboard component.

```swift
    import TVOSKeyboard
    @IBOutlet weak var keyboardView: KeyboardView!
```

2. Create your own set of characters to enter or use one of the preset ones.

```swift
    let eng = KeyboardDescription(code: "en", type: .letters, simbols: "abcdefghijklmnopqrstuvwxyz", label:     "abc", spaceName: "space")
```

3. Create a configuration object and change the default values if necessary.

```swift
    let config = KeyboardConfig()
    config.keyboardDescriptions = [
        eng,
        Presets.rus
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
```

4. Specify as a delegate your ViewController or other object that will be responsible for processing data from the keyboard. To do this the delegate must first be signed under the KeyboardViewProtocol.

```swift
public protocol KeyboardViewProtocol: class {
    func addSimbol(_ value: String)
    func deleteSimbol()
    func swipeFromDown()
    func deleteLongPress()
    func updateString(_ cachedString: String)
    func performFocus(element: UIView)
}
```

## Requirements

- tvOS 13.0+
- Swift 5.0+

### Contact

If you find an issue, just [open a ticket](https://github.com/goldenplan/TVOSKeyboard/issues). Pull requests are warmly welcome as well.

### License

TVOSKeyboard is released under the MIT license. See LICENSE for details.
