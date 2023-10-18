//
//  Validation.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/18/23.
//

import Foundation
import UIKit

struct Validation {
    static func isValidName(_ name: String?) -> Bool {
        guard let name = name, !name.isEmpty else {
            return false
        }
        return true
    }
    
    static func isValidEmail(_ email: String?) -> Bool {
        guard let email = email, !email.isEmpty else {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidDateOfBirth(_ date: Date) -> Bool {
        return date <= Date() // Checks if the date is not in the future
    }
    
    static func isValidCountry(_ country: String?) -> Bool {
        guard let country = country, !country.isEmpty else {
            return false
        }
        return true
    }
    
    static func isValidState(_ state: String?) -> Bool {
        guard let state = state, !state.isEmpty else {
            return false
        }
        return true
    }
    
    static func isValidCity(_ city: String?) -> Bool {
        guard let city = city, !city.isEmpty else {
            return false
        }
        return true
    }
    
    static func isValidNumber(_ number: Int?) -> Bool {
        if let number = number, number > 0 {
            return true
        } else {
            return false
        }
    }
    
    static func isValidDepartureDate(_ date: Date) -> Bool {
        return date >= Date() // Checks if the date is not in the past
    }
    
    static func isValidReturnDate(_ returnDate: Date, departureDate: Date) -> Bool {
        return returnDate > departureDate
    }
    
    static func showAlert(on viewController: UIViewController, with title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
}
