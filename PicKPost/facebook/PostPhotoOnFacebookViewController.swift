//
//  PostPhotoOnFacebookViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 03/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit
import Photos
import FBSDKShareKit

class PostPhotoOnFacebookViewController: UIViewController, FBSDKSharingDelegate, UITextFieldDelegate
{
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!)
    {
        print("Image Upload success")
        progressBarContainerView.isHidden = true
        self.messageTextField.text = ""
        showMessageDialog("Image Upload successfully on Facebook.")
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!)
    {
        print("Error while uploading iMage \(error)");
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!)
    {
            print("Image Uploading Cancel")
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool
    {
        
        view.endEditing(true)
        return true
    }
    
    @IBOutlet weak var paentBottomConstraints: NSLayoutConstraint!
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var messageTextFIeld: UITextField!
    var currentImage: UIImage?
    var currentPhassets : PHAsset?
    @IBOutlet weak var loaded_image_view: UIImageView!
    @IBOutlet weak var share_on_facebook_button: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var progressBarContainerView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        messageTextField.delegate = self
        initActionBar()
        handleView()
        progressBarContainerView.isHidden  = true
        updateStillImage()
        self.hideKeyboard()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        initActionBar()
        //super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    


    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }

    
    
    
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
           self.paentBottomConstraints.constant = -keyboardSize.height
        }
        else
        {
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        self.paentBottomConstraints.constant = 0
        
    }
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of shareawith: t can be recreated.
    }
    @IBAction func sharePhotoOnFacebook(_ sender: Any)
    {
         view.endEditing(true)
        progressBarContainerView.isHidden  = false
        let photo : FBSDKSharePhoto = FBSDKSharePhoto()
        photo.image = self.currentImage
        photo.isUserGenerated = false;
        
        let content = FBSDKSharePhotoContent()
        content.photos = [photo]
        photo.caption = messageTextField.text//"IOS : Testing Happy Holi...."
        FBSDKShareAPI.share(with: content, delegate: self)
    }
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: loaded_image_view.bounds.width * scale,
                      height: loaded_image_view.bounds.height * scale)
    }
    
    
    
    func updateStillImage()
    {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            
        }
        
        
        PHImageManager.default().requestImage(for: self.currentPhassets!,
            targetSize: targetSize,
            contentMode: .aspectFit,
            options: options,
            resultHandler: { image, _ in
              
                guard let image = image else { return }
                self.loaded_image_view.image = image
                self.currentImage = image
        })
    }
    
    func initActionBar()
    {
        
        self.navigationController?.navigationBar.isTranslucent = false;
        //self.navigationController?.navigationBar.topItem?.title = "Post on Facebook"
       // self.navigationController?.navigationBar.barTintColor = UIColor.white// UIColor(red: 134/255, green: 230/255, blue: 255/255, alpha: 1.00)
        
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 255/255, green: 163/255, blue: 60/255, alpha: 1.00)
        
        self.title = "Post on Facebook"
        
        // Adding button to navigation bar (rightBarButtonItem or leftBarButtonItem)
      
        
    }
    
    fileprivate func handleView()
    {
        
        share_on_facebook_button.layer.cornerRadius = 10.0
        share_on_facebook_button.layer.borderWidth = 1
        share_on_facebook_button.clipsToBounds = true
        
        messageTextField.layer.cornerRadius = 10.0
        messageTextField.layer.borderWidth = 1
        messageTextField.clipsToBounds = true
        
    }
    
   
}
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func showMessageDialog(_ message : String)
    {
        var alert = UIAlertController(title: "Pic'K Post", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
