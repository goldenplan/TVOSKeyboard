//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 05.07.2020.
//

import Foundation

public struct KeyboardDescription {
    
    public let code        : String
    public let type        : KeyboardDescriptionType
    public let simbols     : String
    public let label       : String
    public let spaceName   : String?
    public let simbolsArray: [String]?
    
    public init(
        code        : String,
        type        : KeyboardDescriptionType,
        simbols     : String,
        label       : String,
        spaceName   : String?) {
        
        self.code       = code
        self.type       = type
        self.simbols    = simbols
        self.label      = label
        self.spaceName  = spaceName
    }
    
    var count: Int{
        simbols.count
    }
    
    func getSimbols(isUppercased: Bool)->[String]{
        if let array = simbolsArray,
           !array.isEmpty {
            return array
        }
        return simbols.getArray().map { (item) -> String in
            isUppercased ? item.uppercased() : item.lowercased()
        }
    }
    
}




//enum KeyboardType {
//    static let numbers = "0123456789"
//    static let engLetters = "abcdefghijklmnopqrstuvwxyz"
//    static let rusLetters = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
//    static let simbols = "`'\";:~=*+-_,.?!@#$%^&|/\\()"
//
//    case Number(isUpperCased: Bool = false)
//    case RusLetter(isUpperCased: Bool = false)
//    case EngLetter(isUpperCased: Bool = false)
//    case Simbols(isUpperCased: Bool = false)
//
//    func getId() -> String{
//
//        switch self {
//        case .Number:
//            return "num"
//        case .RusLetter:
//            return "ru"
//        case .EngLetter:
//            return "en"
//        case .Simbols:
//            return "sim"
//        }
//
//    }
//
//    func getLabel() -> String{
//
//        switch self {
//        case .Number:
//            return "123"
//        case .RusLetter(let isUpperCased):
//            return isUpperCased ? "АБВ" : "абв"
//        case .EngLetter(let isUpperCased):
//            return isUpperCased ? "ABC" : "abc"
//        case .Simbols:
//            return "#+-"
//        }
//    }
//
//    func getSimbols()->[String]{
//
//        switch self {
//        case .Simbols:
//            return Self.simbols.getArray()
//        case .Number:
//            return Self.numbers.getArray()
//        case .RusLetter(let isUpperCased):
//            return isUpperCased ? Self.rusLetters.uppercased().getArray() : Self.rusLetters.getArray()
//        case .EngLetter(let isUpperCased):
//            return isUpperCased ? Self.engLetters.uppercased().getArray() : Self.engLetters.getArray()
//        }
//
//    }
//}
//

extension String{
    func getArray()->[String]{
        var arr = [String]()

        self.forEach { (item) in
            arr.append(String(item))
        }

        return arr
    }
}

