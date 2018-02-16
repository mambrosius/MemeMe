//
//  KeyboardListener.swift
//  MemeMe
//
//  Created by Morten Ambrosius Andreasen on 16/02/2018.
//  Copyright © 2018 Morten Ambrosius Andreasen. All rights reserved.
//

import Foundation
import UIKit

class KeyboardListener: NotificationCenter {
    
    var notificationCenter = NotificationCenter.default
    var textField: UITextField
    var view: UIView
    
    init(view: UIView, textField: UITextField) {
        self.view = view
        self.textField = textField
    }
    
    func subscribe() {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribe() {
        notificationCenter.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // Moves the view up when the bottom text field is selected
    @objc func keyboardWillShow(_ notification: Notification) {
        if textField.isFirstResponder {
            let hightOfStatusBar = UIApplication.shared.statusBarFrame.height
            let hightOfNavigationBar = UINavigationController().navigationBar.frame.height
            view.frame.origin.y = hightOfStatusBar + hightOfNavigationBar - getKeyboardHeight(notification)
        }
    }
    
    // Moves the view back when the bottom text field is deselected
    @objc func keyboardWillHide(_ notification: Notification) {
        if textField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
