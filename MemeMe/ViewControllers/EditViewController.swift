//
//  ViewController.swift
//  MemeMe
//
//  Created by Morten Ambrosius Andreasen on 06/02/2018.
//  Copyright © 2018 Morten Ambrosius Andreasen. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: Properties
    
    var keyboardListener: KeyboardListener!
    let textFieldDelegate = TextFieldDelegate()
    
    // Setting the color of the status bar items to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: App life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize(topTextField, with: "TOP")
        initialize(bottomTextField, with: "BOTTOM")
        keyboardListener = KeyboardListener(view: view, textField: bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imageView.image != nil
        keyboardListener.subscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardListener.unsubscribe()
    }
    
    // MARK: TextField helper function
    
    func initialize(_ textField: UITextField, with text: String) {
        textField.delegate = textFieldDelegate
        textField.text = text
    }
    
    // MARK: Meme functions
    
    func save(_ image: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: image)
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide the toolBar
        toolBar.isHidden = true
        
        // Hide cursers of textfields if present
        if topTextField.isFirstResponder {
            topTextField.resignFirstResponder()
        } else if bottomTextField.isFirstResponder {
            bottomTextField.resignFirstResponder()
        }
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolBar
        toolBar.isHidden = false
        
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
    
    @IBAction func cancelEdit(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Cancel Editing?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: {(action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
