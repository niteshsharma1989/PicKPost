//
//  HomeViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 27/10/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController
{

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var containerFrameView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var workInfoCell: UIView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var work_info: UILabel!
    var managedObjectContext:NSManagedObjectContext?
    var currentFacebookProfile : FacebookUserProfile?
    
    var workInfoList : [WorkInfo] = []
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initActionBar()
        initImageView()
       initCurrentFacebookUserProfile()
        
        let logoutGesture = UITapGestureRecognizer(target: self, action: #selector(self.openWorkInfo(_:)))
        workInfoCell.addGestureRecognizer(logoutGesture)
        
    }
    
    
    @objc func openWorkInfo( _ sender : UITapGestureRecognizer)
    {
        let popvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "work_info_controller") as! WorkInfoViewController
        popvc.workInfoList = self.workInfoList
        
        self.addChildViewController(popvc)
        
        popvc.view.frame = self.view.frame
        
        self.view.addSubview(popvc.view)
        
        popvc.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func shadowView( _ uiView : UIView)
    {
        uiView.layer.masksToBounds = false
        uiView.layer.shadowColor = UIColor.black.cgColor
        uiView.layer.shadowOpacity = 0.5
        uiView.layer.shadowOffset = CGSize(width: -1, height: 1)
        uiView.layer.shadowRadius = 1
        
        uiView.layer.shadowPath = UIBezierPath(rect: uiView.bounds).cgPath
        uiView.layer.shouldRasterize = true
    }
    
    
    fileprivate func initCurrentFacebookUserProfile()
    {
        initManageObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: DataModelKeys.FACEBOOK_USER_PROFILE, in: self.managedObjectContext!)
        fetchRequest.entity = entityDescription
        
        do
        {
            let result = try self.managedObjectContext?.fetch(fetchRequest)
         //   print(result)
            
            if (result!.count > 0)
            {
                self.currentFacebookProfile = result![0] as? FacebookUserProfile
                
               
                self.userName.text = self.currentFacebookProfile?.name
                self.emailLabel.text = self.currentFacebookProfile?.email
                self.genderLabel.text = self.currentFacebookProfile?.gender
                
                NetworkRequestHelper.downloadImage(url: (self.currentFacebookProfile?.profilePicUrl)!, imageView: self.profileImage)
                
                 NetworkRequestHelper.downloadImage(url: (self.currentFacebookProfile?.coverPicURL)!, imageView: self.coverImageView)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
         let worketchRequest = NSFetchRequest<NSFetchRequestResult>()
         let workEntityDescription = NSEntityDescription.entity(forEntityName: DataModelKeys.WORK_INFO, in: self.managedObjectContext!)
         worketchRequest.entity = workEntityDescription
        
        do
        {
            let result = try self.managedObjectContext?.fetch(worketchRequest)
               print(result)
            if (result!.count > 0)
            {
                
                for  res in result!
                {
                    let workInfo = res as? WorkInfo
             
                    
                    workInfoList.append(workInfo!)
                }
               
                
            }
            if workInfoList.count > 0
            {
                let currentWorkInfo = workInfoList[0]
                self.work_info.text = "\(currentWorkInfo.employer!), \(currentWorkInfo.location!)"
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    fileprivate func initManageObjectContext()
    {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
    }
    
    fileprivate func initImageView()
    {
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.cornerRadius = profileImage.frame.width/2.0
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor  = UIColor.white.cgColor
        profileImage.layer.masksToBounds = true
        
    }
    
    func initActionBar()
    {
      //  UINavigationBar.appearance().backgroundColor = UIColor.red
     //   UIBarButtonItem.appearance().tintColor = UIColor.black
       self.navigationController?.navigationBar.topItem?.title = "My Profile"
       // navigationController?.navigationBar.backgroundColor = UIColor.red
       // navigationController?.navigationBar.barTintColor = UIColor.white// UIColor(red: 134/255, green: 230/255, blue: 255/255, alpha: 1.00)
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 255/255, green: 163/255, blue: 60/255, alpha: 1.00)
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "drawer_sms"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(toggelDrawer))
        
        // Adding button to navigation bar (rightBarButtonItem or leftBarButtonItem)
        self.navigationItem.leftBarButtonItem = barButtonItem

    }
    
    @objc fileprivate func toggelDrawer()
    {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

}
