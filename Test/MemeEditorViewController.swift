//
//  MemeEditorViewController.swift
//
//  Created by Yiling Zhang on 12/30/21.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {
// UITextFieldDelegate is added because UITextField editing is needed
    
    var keyboardHeight: CGFloat = 0
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var displayPickedImage: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

   
    override func viewDidLoad() {
        super.viewDidLoad()

        // defaultTextAttributes have to be set during loading stage, or they will cause errors
        setupTextField(tf: topTextField, text: "TOP")
        setupTextField(tf: bottomTextField, text: "BOTTOM")
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
   
        // disable shareButton initially
        self.shareButton.isEnabled = false
        
        //
        hideAndShowNaviTab(hidden: true)

    }
    
    // set style of top/bottom TextFields
    func setupTextField(tf: UITextField, text: String) {
        
        // Text style for topTextField & bottomTextField
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            // The leading dots below infer NSAttributedString.Key in the definition
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth:  -5.0 // strokeWidth has to be negative float to have the text filled with foregroundColor and the background transparent at the same time
        ]
        tf.defaultTextAttributes = memeTextAttributes
        tf.text = text
        tf.textAlignment = .center
        tf.delegate = self
        // Not sure why textColor needs to be set (instructed by reviewer)
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        // add keyboard notification when view appears
        subscribeToKeyboardNotifications()

    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        // remove keyboard notification when view disappears
        unsubscribeFromKeyboardNotifications()

    }

    // subscription notification
    func subscribeToKeyboardNotifications() {
        
        // both keyboardWillShow & keyboardWillHide need to be set
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // unsubscription notification
    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        // view.frame needs to move up only when bottomTextField is being edited to avoid blocked view
        // .isFirstResponder is effectively used
        if self.bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // get height of the keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        self.keyboardHeight = keyboardSize.cgRectValue.height
        return keyboardHeight
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        // resetting y to 0 is the easiest way
        // although view.frame needs to be reset only after bottomTextField is finished editing, it wouldn't hurt topTextField. So, no if statement to keep it simple
        view.frame.origin.y = 0
    }

    // touchesBegan ends editing in UITextFields when other parts are clicked/touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    // when return button is pressed, UITextField ends editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // this is triggered when an image is picked
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // pass the picked image to the UIImageView
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.displayPickedImage.image = image
            // enable shareButton once an image is chosen
            self.shareButton.isEnabled = true
        }
        // after passing the image, dismiss the imagePickerController
        self.dismiss(animated: true, completion: nil)
    }
    
    // when image picker is cancelled, dismiss it
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // chooseImageFromCameraOrPhoto() reduces code redundancy in pickAnImage(0 & takeAPhot()
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    // pick an image from album
    @IBAction func pickAnImage(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    
    // take a photo by camera
    @IBAction func takeAPhoto(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .camera)
    }

    // save both texts, original image and memed image in meme object
    func save() {
        
        // create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: displayPickedImage.image!, memedImage: generateMemedImage())
        // add meme to the memes array in AppDelegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        
    }
    
    // create memed image by capturing the screenshot excluding toolbar & navigationbar
    func generateMemedImage() -> UIImage {

        hideAndShowBars(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // need to bring toolbar & navigationbar back before return statement (or they won't be executed)
        hideAndShowBars(hidden: false)
        
        return memedImage
    }
    
    // hideAndShowBars is used when edited image is saved
    func hideAndShowBars(hidden: Bool) {
        toolbar.isHidden = hidden
        navigationBar.isHidden = hidden
    }
    
    // once shareButton is clicked...
    @IBAction func shareMemedImage(_ sender: Any) {
        
        // first, get the memed image
        let memedImage = generateMemedImage()
        // then, initialize an UIActivityViewController & pass the memed image to it
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        // present the UIActivityViewController
        self.present(activityViewController, animated: true, completion: nil)
        // once an action is done (e.g. save image), codes after "in" will be executed
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            // Only when completed == true, memedImage is saved
            if completed {
                // save both texts, original image & memed image in struct object "meme"
                self.save()
                // dismiss the UIActivityViewController
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func hideAndShowNaviTab(hidden: Bool) {
        navigationController?.navigationBar.isHidden = hidden
        tabBarController?.tabBar.isHidden = hidden
    }
    
    // cancel button
    @IBAction func cancel(_ sender: Any) {
        shareButton.isEnabled = false
        displayPickedImage.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        hideAndShowNaviTab(hidden: false)
        // go back to previous controller
        self.navigationController?.popViewController(animated: true)

    }

}

