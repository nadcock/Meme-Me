//
//  ViewController.swift
//  Image Picker
//
//  Created by Nick on 5/4/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import UIKit


class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var memesLocal: [Meme]!
    var EditMode = true
    var memeIndex: Int!

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
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : NSNumber(float: -3.0)
        ]
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memesLocal = appDelegate.memes
        
        //Sets the look of the text fields
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.borderStyle = UITextBorderStyle.None
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.delegate = self
        
        // Sets requirements for Edit Mode vs New Meme Mode
        if EditMode == true {
            topTextField.text = memesLocal[memeIndex].top
            bottomTextField.text = memesLocal[memeIndex].bottom
            imageViewImage?.image = memesLocal[memeIndex].image
            
        } else {
            shareButton.enabled = false
            saveButton.enabled = false
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            imageViewImage?.image = nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationController?.navigationBarHidden = true
    }

    @IBAction func pickAImageFromAlbum(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Share button
    @IBAction func share (sender: UIBarButtonItem) {
        view.endEditing(true)
        let meme = Meme(top: topTextField.text, bottom: bottomTextField.text, image: imageViewImage!.image)
        let memedImage = meme.generateMeme()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {activity, completed, items, error in
            if !completed {
                return
            } else {
                self.save()
                self.cancelButton.enabled = true
                self.performSegueWithIdentifier("SegueToMemeList", sender: self)
            }
        }
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // Cancel button
    @IBAction func cancel(sender: UIBarButtonItem) {
        performSegueWithIdentifier("SegueToMemeList", sender: self)
    }
    
    // Save button
    @IBAction func saveButton(sender: UIBarButtonItem) {
        save()
        cancelButton.enabled = true
        performSegueWithIdentifier("SegueToMemeList", sender: self)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageViewImage!.image = image
        }
        shareButton.enabled = true
        saveButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (bottomTextField.isFirstResponder()){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (bottomTextField.isFirstResponder()){
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Saves the meme to array of memes in app delegate
    func save() {
        //Create the meme
        let meme = Meme(top: topTextField.text, bottom: bottomTextField.text, image: imageViewImage!.image)
        if EditMode == true {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes[memeIndex] = (meme)
        } else {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        }
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memesLocal = appDelegate.memes
    }
}

