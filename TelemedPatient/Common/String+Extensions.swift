//
//  String+Extensions.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 09.12.2020.
//

import Foundation

extension String {
    
    static let shortDateFormat = "yyyy-MM-dd"
    
    static let longDateFormat = "dd MMMM yyyy"
    
    var isEmail: Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
   }
    
    var isPhone: Bool {
        let phoneRegEx = "\\+\\d\\s(?:\\(\\d{3}\\))\\s(?:\\d{3})\\-(?:\\d{2})\\-(?:\\d{2})"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return  phonePredicate.evaluate(with: self)
    }
    
    var isFullName: Bool {
        let fullNameRegEx = "([\\wА-я])+\\s([\\wА-я])+\\s([\\wА-я])+"
        let fullNamePredicate = NSPredicate(format: "SELF MATCHES %@", fullNameRegEx)
        return fullNamePredicate.evaluate(with: self)
    }
    
    static var currentDate: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = String.shortDateFormat
        return formatter.string(from: date)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
