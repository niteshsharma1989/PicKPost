//
//  SideDrawerViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 27/10/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore


class SideDrawerViewController: UIViewController
{
    
    let timer = Timer()

    @IBOutlet weak var navigationViewSelector: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var facebookFeedsView: UIView!
    @IBOutlet weak var imageGalleryView: UIView!
    @IBOutlet weak var myProfileView: UIView!
    @IBOutlet weak var profileSelector: UIView!
    @IBOutlet weak var gallerySelector: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var facebookPhotosView: UIView!
    @IBOutlet weak var facebookPhotosSelector: UIView!
    @IBOutlet weak var fabeookFriendsView: UIView!
    @IBOutlet weak var facebookFriendsViewSelector: UIView!
    @IBOutlet weak var facebookFeedsSelector: UIView!
    
    var managedObjectContext:NSManagedObjectContext?
    var currentFacebookProfile : FacebookUserProfile?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        profileSelector.isHidden = false
        gallerySelector.isHidden = true
        facebookPhotosSelector.isHidden = true
        facebookFeedsSelector.isHidden = true
        facebookFriendsViewSelector.isHidden = true
        navigationViewSelector.isHidden = true
        
        initCurrentFacebookUserProfile()
        initImageView()
        let galleryGesture = UITapGestureRecognizer(target: self, action: #selector(self.openAllPhotos(_:)))
        imageGalleryView.addGestureRecognizer(galleryGesture)
        let profileGesture = UITapGestureRecognizer(target: self, action: #selector(self.openProfile(_:)))
        myProfileView.addGestureRecognizer(profileGesture)
        
        let logoutGesture = UITapGestureRecognizer(target: self, action: #selector(self.doLogout(_:)))
        logoutView.addGestureRecognizer(logoutGesture)
        let allFacebookPhotosGesture = UITapGestureRecognizer(target: self, action: #selector(self.showAllFacebookPhotos(_:)))
        facebookPhotosView.addGestureRecognizer(allFacebookPhotosGesture)
        
        let allFacebookFriendsGesture = UITapGestureRecognizer(target: self, action: #selector(self.showFacebookFriendList(_:)))
        fabeookFriendsView.addGestureRecognizer(allFacebookFriendsGesture)
        
        
        let allFacebookFeedsGesture = UITapGestureRecognizer(target: self, action: #selector(self.showFacebookFeeds(_:)))
        facebookFeedsView.addGestureRecognizer(allFacebookFeedsGesture)
        
        let navigationGesture = UITapGestureRecognizer(target: self, action: #selector(self.showNavigation(_:)))
        navigationView.addGestureRecognizer(navigationGesture)
        
        let profileImageGesture = UITapGestureRecognizer(target: self, action: #selector(self.showProfilePhoto(_:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(profileImageGesture)
        
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 255/255, green: 163/255, blue: 60/255, alpha: 1.00)
    }
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    fileprivate func initCurrentFacebookUserProfile()
    {
        initManageObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: "FacebookUserProfile", in: self.managedObjectContext!)
        fetchRequest.entity = entityDescription
        
        do
        {
            let result = try self.managedObjectContext?.fetch(fetchRequest)
            //   print(result)
            
            if (result!.count > 0)
            {
                self.currentFacebookProfile = result![0] as? FacebookUserProfile
                
                
                self.userName.text = self.currentFacebookProfile?.name
             
                NetworkRequestHelper.downloadImage(url: (self.currentFacebookProfile?.profilePicUrl)!, imageView: self.profileImage)
                
                NetworkRequestHelper.downloadImage(url: (self.currentFacebookProfile?.coverPicURL)!, imageView: self.coverImageView)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    
    @objc func showProfilePhoto( _ sender : UITapGestureRecognizer)
    {
        
        let imageInfo   = GSImageInfo(image: profileImage.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: profileImage!)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        print("======== Showing images")
        imageViewer.dismissCompletion = {
            print("dismissCompletion")
        }
        
        present(imageViewer, animated: true, completion: nil)
    }
    
    
    fileprivate func initImageView()
    {
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.cornerRadius = profileImage.frame.width/2.0
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor  = UIColor.white.cgColor
        profileImage.layer.masksToBounds = true
        
    }
    
    fileprivate func initManageObjectContext()
    {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden =  true
        
        //Status bar style and visibility
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Change status bar color
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor(red: 255/255, green: 163/255, blue: 60/255, alpha: 1.00)
        //UIColor.red
       
        
    }

    @objc fileprivate func toggelDrawer()
    {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //showFacebookFeeds
    
    @objc func showNavigation( _ sender : UITapGestureRecognizer)
    {
        profileSelector.isHidden = true
        facebookFriendsViewSelector.isHidden = true
        gallerySelector.isHidden = true
        facebookPhotosSelector.isHidden = true
        facebookFeedsSelector.isHidden = true
        navigationViewSelector.isHidden = false
        (UIApplication.shared.delegate as! AppDelegate).setNavigationDrawerMainController()
        (UIApplication.shared.delegate as! AppDelegate).closeDrawer()
    }
    
    @objc func showFacebookFeeds( _ sender : UITapGestureRecognizer)
    {
        profileSelector.isHidden = true
        facebookFriendsViewSelector.isHidden = true
        gallerySelector.isHidden = true
        facebookPhotosSelector.isHidden = true
        facebookFeedsSelector.isHidden = false
         navigationViewSelector.isHidden = true
        (UIApplication.shared.delegate as! AppDelegate).setFacebookFeedsInDrawerMainController()
        (UIApplication.shared.delegate as! AppDelegate).closeDrawer()
    }
    
    
    @objc func openAllPhotos( _ sender : UITapGestureRecognizer)
    {
        profileSelector.isHidden = true
        facebookFriendsViewSelector.isHidden = true
         gallerySelector.isHidden = false
        facebookPhotosSelector.isHidden = true
         navigationViewSelector.isHidden = true
        facebookFeedsSelector.isHidden = true
        (UIApplication.shared.delegate as! AppDelegate).setAllPhotosViewControllerInDrawerMainController()
        (UIApplication.shared.delegate as! AppDelegate).closeDrawer()
    }
     @objc func openProfile(_ sender:UITapGestureRecognizer)
    {
        profileSelector.isHidden = false
        facebookFriendsViewSelector.isHidden = true
        gallerySelector.isHidden = true
        facebookPhotosSelector.isHidden = true
         navigationViewSelector.isHidden = true
        facebookFeedsSelector.isHidden = true
        (UIApplication.shared.delegate as! AppDelegate).setProfileViewControllerInDrawerMainController()
        (UIApplication.shared.delegate as! AppDelegate).closeDrawer()
    }
    
    @objc func showAllFacebookPhotos(_ sender:UITapGestureRecognizer)
    {
        profileSelector.isHidden = true
        gallerySelector.isHidden = true
        facebookFriendsViewSelector.isHidden = true
        facebookPhotosSelector.isHidden = false
         navigationViewSelector.isHidden = true
        facebookFeedsSelector.isHidden = true
        (UIApplication.shared.delegate as! AppDelegate).setAllFacebookInDrawerMainController()
        (UIApplication.shared.delegate as! AppDelegate).closeDrawer()
    }
    
    @objc func showFacebookFriendList(_ sender:UITapGestureRecognizer)
    {
        profileSelector.isHidden = true
        gallerySelector.isHidden = true
        facebookFriendsViewSelector.isHidden = false
        facebookPhotosSelector.isHidden = true
        facebookFeedsSelector.isHidden = true
         navigationViewSelector.isHidden = true
        (UIApplication.shared.delegate as! AppDelegate).setAllFacebookFriendsInDrawerMainController()
        (UIApplication.shared.delegate as! AppDelegate).closeDrawer()
    }
    
    
    @objc func doLogout(_ sender:UITapGestureRecognizer)
    {
        NetworkRequestHelper.imageCache.removeAllObjects()
         let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        deleteAllRecords()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.askForLoginWithFacebook()
    }
    
    
    
    
    func deleteAllRecords()
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FacebookUserProfile")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        
        let deleteWork = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkInfo")
        let deleteworkRequest = NSBatchDeleteRequest(fetchRequest: deleteWork)
        
        do {
            try context.execute(deleteRequest)
             try context.execute(deleteworkRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    

    
}
