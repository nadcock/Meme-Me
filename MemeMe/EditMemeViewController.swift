//
//  ViewController.swift
//  Image Picker
//
//  Created by Nick on 5/4/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import UIKit


class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var EditMode = true
    var meme: Meme?
    //var memeIndex: Int!

    @IBOutlet weak var imageViewImage: UIImageView?
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : NSNumber(value: -3.0 as Float)
        ]
        
        
        //memesLocal = appDelegate.memes
        
        //Sets the look of the text fields
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.borderStyle = UITextBorderStyle.none
        topTextField.textAlignment = NSTextAlignment.center
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.borderStyle = UITextBorderStyle.none
        bottomTextField.textAlignment = NSTextAlignment.center
        bottomTextField.delegate = self
        
        // Sets requirements for Edit Mode vs New Meme Mode
        if let meme = meme {
            topTextField.text = meme.topString
            bottomTextField.text = meme.bottomString
            imageViewImage?.image = UIImage(data: meme.originalImage as Data)
            
        } else {
            shareButton.isEnabled = false
            saveButton.isEnabled = false
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            imageViewImage?.image = nil
        }
        self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        subscribeToKeyboardNotifications()
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func pickAImageFromAlbum(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Share button
    @IBAction func share (_ sender: UIBarButtonItem) {
        view.endEditing(true)
        self.save()
        
        let activityController = UIActivityViewController(activityItems: [meme!.memeImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {activity, completed, items, error in
            if !completed {
                return
            } else {
                self.cancelButton.isEnabled = true
                self.performSegue(withIdentifier: "SegueToMemeList", sender: self)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    // Cancel button
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //performSegue(withIdentifier: "SegueToMemeList", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    // Save button
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        save()
        cancelButton.isEnabled = true
        //performSegue(withIdentifier: "SegueToMemeList", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageViewImage!.image = image
        }
        shareButton.isEnabled = true
        saveButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if (bottomTextField.isFirstResponder){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if (bottomTextField.isFirstResponder){
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(EditMemeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditMemeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    
    
    // Saves the meme to array of memes in app delegate
    func save() {
        //Create the meme
        if let meme = meme {
            meme.lastModified = Date()
            meme.bottomString = bottomTextField.text
            meme.topString = topTextField.text
            meme.originalImage = UIImagePNGRepresentation(imageViewImage!.image!)!
            meme.memeImage = MemeGenerator().generateMeme(top: topTextField.text!, bottom: bottomTextField.text!, image: imageViewImage!.image!)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            meme = Meme(context: context)
            meme!.dateCreated = Date()
            meme!.lastModified = meme!.dateCreated
            meme!.bottomString = bottomTextField.text
            meme!.topString = topTextField.text
            meme!.originalImage = UIImagePNGRepresentation(imageViewImage!.image!)!
            meme!.memeImage = MemeGenerator().generateMeme(top: topTextField.text!, bottom: bottomTextField.text!, image: imageViewImage!.image!)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
}

