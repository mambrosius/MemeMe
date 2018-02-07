//
//  ViewController.swift
//  MemeMe
//
//  Created by Morten Ambrosius Andreasen on 06/02/2018.
//  Copyright © 2018 Morten Ambrosius Andreasen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // Setting the color of the status bar items to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let topTextFieldDelegate = TopTextFieldDelegate()
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextField(textField: topTextField, delegate: topTextFieldDelegate, text: "TOP")
        initializeTextField(textField: bottomTextField, delegate: bottomTextFieldDelegate, text: "BOTTOM")
    }
    
    // MARK: App life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imageView.image != nil
        
        subscribeNotification(name: .UIKeyboardWillShow, #selector(keyboardWillShow(_:)))
        subscribeNotification(name: .UIKeyboardWillHide, #selector(keyboardWillHide(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeNotification(name: .UIKeyboardWillShow)
        unsubscribeNotification(name: .UIKeyboardWillHide)
    }
    
    // MARK: Meme functions
    
    func save(_ image: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: image)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolBar and navBar
        toolBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolBar and navBar
        toolBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        return memedImage
    }
    
    // MARK: IBActions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromCamara(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) -> () in
            if completed {
                self.save(memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Helper functions
    
    func initializeTextField(textField: UITextField, delegate: UITextFieldDelegate, text: String) {
        
        // Text attributes
        let memeTextAttributes: [String : Any] = [
            NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
            NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue : -3.0
        ]
        
        textField.delegate = delegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeNotification(name: NSNotification.Name, _ selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribeNotification(name: NSNotification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

