//
//  TopTextFieldDelegate.swift
//  MemeMe
//
//  Created by Morten Ambrosius Andreasen on 07/02/2018.
//  Copyright © 2018 Morten Ambrosius Andreasen. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    let memeTextAttributes: [String : Any] = [
        NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
        NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue : -3.0
    ]
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == textField.restorationIdentifier {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
