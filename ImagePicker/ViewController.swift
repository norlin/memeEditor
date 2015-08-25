//
//  ViewController.swift
//  ImagePicker
//
//  Created by norlin on 10/08/15.
//  Copyright (c) 2015 norlin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    let topDefaultText = "TOP"
    let bottomDefaultText = "BOTTOM"
    
    var meme: Meme?
    var memesList: [Meme] = []

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var captureButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // set textfields attributes
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.Center
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // send image view to back since sometimes it goes to front by itself
        view.sendSubviewToBack(image)

        // check capture & share button states
        captureButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        updateShareButton()
        
        // Set defaul texts
        topText.text = topDefaultText
        bottomText.text = bottomDefaultText

        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickImage(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func captureImage(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.image = img
            makeMeme()
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textChange(notification: NSNotification){
        makeMeme()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func makeMeme(){
        // create meme only if we have an image
        if let image = self.image.image {
            navigationController?.navigationBar.hidden = true
            toolbar.hidden = true
            
            let top = topText.text
            let bottom = bottomText.text
            
            meme = Meme(top: top, bottom: bottom, image: image, view: view)
            updateShareButton()
            
            toolbar.hidden = false
            navigationController?.navigationBar.hidden = false
        }
    }
    
    func updateShareButton(){
        shareButton.enabled = meme != nil
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        if let image = meme?.memedImage {
            let sharing = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            sharing.completionWithItemsHandler = saveMeme
            presentViewController(sharing, animated: true, completion: nil)
        }
    }
    
    func saveMeme(s: String!, b: Bool, i: [AnyObject]!, e: NSError!) -> Void{
        if (!b){
            return
        }
        
        // if meme shared successfully save it to the list
        if let meme = self.meme {
            memesList.append(meme)
            self.meme = nil
        }
        updateShareButton()
        return
    }
    
    // handle keyboard events
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let info = notification.userInfo
        let size = info![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return size.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification){
        if bottomText.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChange:", name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if ((textField == bottomText && textField.text == bottomDefaultText) || (textField == topText && textField.text == topDefaultText)) {
            textField.text = ""
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.text.isEmpty) {
            if (textField == bottomText) {
                textField.text = bottomDefaultText
            }
            
            if (textField == topText) {
                textField.text = topDefaultText
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

