//
//  FacebookLoginViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 01/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit
import CoreData
import FacebookCore
import FacebookLogin
import FBSDKLoginKit





class FacebookLoginViewController: UIViewController
{

    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var inerIndicatorView: UIView!
    
    
    var managedObjectContext : NSManagedObjectContext?
    @IBOutlet weak var facebookLoginButton: UIButton!
    var facebookUserProfile:FacebookUserProfile?
    
    var userProfileInfo : [String : AnyObject]!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
     
        
        initIndicator()
        initManageObjectContext()
        
       if AccessToken.current != nil
       {
           (UIApplication.shared.delegate as! AppDelegate).launchHomeController()
        }
    }
    
    

    
    
    
    
    
    fileprivate func initManageObjectContext()
    {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        facebookUserProfile = NSEntityDescription.insertNewObject(forEntityName: "FacebookUserProfile", into: self.managedObjectContext!) as! FacebookUserProfile
    }
    
    fileprivate func initIndicator()
    {
        inerIndicatorView.layer.cornerRadius = 10.0
        inerIndicatorView.layer.borderWidth = 0.5
        inerIndicatorView.clipsToBounds = true
        progressView.isHidden = true
        facebookLoginButton.layer.cornerRadius = 10.0
        facebookLoginButton.layer.borderWidth = 1
        facebookLoginButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doFacebookLogin(_ sender: Any)
    {//"publish_actions",
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: [ "user_photos", "user_friends"], from: self) { (result, error) in
            if (error == nil)
            {
                self.progressView.isHidden = false
                print("No Error while Facebok login");
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if fbloginresult.grantedPermissions != nil
                {
                    print(fbloginresult.grantedPermissions)
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        print("EMAIL PERMISSION GRANTED ")
                        self.getFBUserData()
                        print("Access Token : \(FBSDKAccessToken.current().tokenString!)")
                        //fbLoginManager.logOut()
                    }
                }
                else
                {
                    print("Facebook Login result is nil ")
                }
            }
            else
            {
                self.progressView.isHidden = true
                print("Error while facebook login")
            }
        }
    }
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), gender, cover, email, education, work, birthday" ]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    
                    
                    self.userProfileInfo = result as! [String : AnyObject]
                    
                    print("\(result)")
                    
                    let picutreData = self.userProfileInfo[Keys.PICTURE] as! [String : AnyObject]
                    let data = picutreData[Keys.DATA] as! [String : AnyObject]
                    let picURL = data[Keys.URL] as! String
                    let coverData = self.userProfileInfo[Keys.COVER] as! [String : AnyObject]
                    let source = coverData[Keys.SOURCE] as! String
                    
                    self.facebookUserProfile?.name = self.userProfileInfo[Keys.NAME] as? String
                    self.facebookUserProfile?.first_name = self.userProfileInfo[Keys.FIRST_NAME] as? String
                    self.facebookUserProfile?.last_name = self.userProfileInfo[Keys.LAST_NAME] as? String
                    self.facebookUserProfile?.email = self.userProfileInfo[Keys.EMAIL] as? String
                    self.facebookUserProfile?.facebook_id = self.userProfileInfo[Keys.ID] as? String
                    self.facebookUserProfile?.gender = self.userProfileInfo[Keys.GENDER] as? String
                    self.facebookUserProfile?.profilePicUrl = picURL
                    self.facebookUserProfile?.coverPicURL = source
                    self.facebookUserProfile?.access_token = FBSDKAccessToken.current().tokenString!
                   
                    do
                    {
                        try self.facebookUserProfile!.managedObjectContext?.save()
                        print("Facebook Profile Saved")
                    }
                    catch
                    {
                        print("Error while saving Facebook USer Profile in Core Data")
                        print(error)
                    }
                    
                   let workInfo = self.userProfileInfo[Keys.WORK] as! [ AnyObject]
                    
                    for workTemp in workInfo
                    {
                        let workTemp2 = workTemp as! [String : AnyObject]
                       // print("\(workTemp2)")
                        
                        let  workInfoData = NSEntityDescription.insertNewObject(forEntityName: "WorkInfo", into: self.managedObjectContext!) as! WorkInfo
                        if workTemp2.index(forKey: Keys.POSITION) != nil
                        {
                            let positionNode = workTemp2[Keys.POSITION] as! [String : String]
                            let positionName = positionNode[Keys.NAME]
                           // print("Position : \(String(describing: positionName!))")
                            workInfoData.position = positionName
                        }
                        
                        if workTemp2.index(forKey: Keys.EMPLOYER) != nil
                        {
                            let employerNode = workTemp2[Keys.EMPLOYER] as! [String : String]
                            let employerName = employerNode[Keys.NAME]
                            //print("Employer Name : \(String(describing: employerName!))")
                            workInfoData.employer = employerName
                        }
                        
                        if workTemp2.index(forKey: Keys.LOCATION) != nil
                        {
                            let locationNode_ = workTemp2[Keys.LOCATION] as! [String : String]
                            let locationName = locationNode_[Keys.NAME]
                            workInfoData.location = locationName
                          //  print("Location Name : \(String(describing: locationName!))")
                        }
                       
                        do
                        {
                            try workInfoData.managedObjectContext?.save()
                            print("Work Info Saved : \(String(describing: workInfoData.employer))")
                        }
                        catch
                        {
                            print("Error while saving Facebook USer Profile in Core Data")
                            print(error)
                        }
                       
                        
                    }
                    
                    self.progressView.isHidden = true
                     (UIApplication.shared.delegate as! AppDelegate).launchHomeController()
           
               
                }
            })
        }
    }
    


}
