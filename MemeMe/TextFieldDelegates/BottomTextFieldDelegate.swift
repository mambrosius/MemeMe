//
//  BottomTextFieldDelegate.swift
//  MemeMe
//
//  Created by Morten Ambrosius Andreasen on 07/02/2018.
//  Copyright © 2018 Morten Ambrosius Andreasen. All rights reserved.
//

import Foundation
import UIKit

class BottomTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
