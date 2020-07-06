//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 05.07.2020.
//

import Foundation

public struct Presets {
    
    public static let rus = KeyboardDescription(code: "ru", type: .letters, simbols: "абвгдеёжзийклмнопрстуфхцчшщъыьэюя", label: "абв", spaceName: "пробел")
    public static let eng = KeyboardDescription(code: "en", type: .letters, simbols: "abcdefghijklmnopqrstuvwxyz", label: "abc", spaceName: "space")
    public static let numbers = KeyboardDescription(code: "numbers", type: .numeric, simbols: "0123456789", label: "123", spaceName: nil)
    public static let simbols = KeyboardDescription(code: "simbols", type: .symbolic, simbols: "`'\";:~=*+-_,.?!@#$%^&|/\\()", label: "#+-", spaceName: nil)
    
}
