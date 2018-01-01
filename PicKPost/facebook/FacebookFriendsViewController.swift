//
//  FacebookFriendsViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 08/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//
//https://www.innofied.com/implement-location-tracking-using-mapkit-in-swift/
import UIKit
import FBSDKCoreKit

class FacebookFriendsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return friendsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fb_friend_cell", for: indexPath as IndexPath) as? FacebookFriendCellCollectionViewCell
        
        let friend = friendsList[indexPath.row]
        cell?.friendNameLabel.text = friend.name
        let id = friend.facebookID
        
        let pic = "https://graph.facebook.com/\(id!)/picture?type=large&w‌​idth=720&height=720"
        cell!.profileImageView.image = UIImage(named: "user_profile")
        NetworkRequestHelper.downloadFacebookProfile(url: (pic), imageView: (cell!.profileImageView)!)
        return cell!
    }
    

    
    @IBOutlet weak var noneFriendsView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var innerProgressView: UIView!
    @IBOutlet weak var facebookFriendsCollectionView: UICollectionView!
    
    var friendsList : [FBFriend] = []
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        noneFriendsView.isHidden = true
        initActionBar()
        initIndicator()
        registerAllNibsInCollectionView()
        getFacebokFriendList()
        initPhotoCell()
        print(FBSDKSettings.sdkVersion())
        

        // Do any additional setup after loading the view.
    }
    func initActionBar()
    {
        
        self.title = "Facebook Friends"
       // self.navigationController?.navigationBar.barTintColor = UIColor.white// UIColor(red: 134/255, green: 230/255, blue: 255/255, alpha: 1.00)
       
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 255/255, green: 163/255, blue: 60/255, alpha: 1.00)
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "drawer_sms"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(toggelDrawer))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
    }
    
    
    
    @objc fileprivate func toggelDrawer()
    {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    func initPhotoCell()
    {
       // let viewWidth = view.bounds.size.width
        
        let desiredItemWidth: CGFloat = facebookFriendsCollectionView.bounds.width/2
        let itemHeightx = facebookFriendsCollectionView.bounds.height/4
        
        // let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
        let itemSize = CGSize(width: desiredItemWidth - 0.5, height: itemHeightx)
        
        
        // thumbnailSize = itemSize
        
        if let layout = facebookFriendsCollectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = 1
            
            layout.minimumLineSpacing = 1
        }
    }
    fileprivate func initIndicator()
    {
        progressView.layer.cornerRadius = 10.0
        progressView.layer.borderWidth = 0.5
        progressView.clipsToBounds = true
        
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func getFacebokFriendList()
    {
        let params = ["fields": "id, name, picture"]
        
        let graphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: params)
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) in
            if error == nil {
                if let userData = result as? [String:Any]
                {
                     let dataResponse = userData["data"] as! [Any]
                    
                    if dataResponse.count > 0
                    {
                        self.noneFriendsView.isHidden = true
                        
                        for datax in dataResponse
                        {
                            print(datax)
                            let data = datax as! [String : Any]
                            let name = data[Keys.NAME] as! String
                            let id  = data[Keys.ID] as! String
                            print("Name : \(String(describing: name))")
                            print(" ID : \(String(describing: id))")
                            
                            let friend = FBFriend()
                            friend.name = name
                            friend.facebookID  = id
                            
                            self.friendsList.append(friend)
                        }
                        
                    }
                    else
                    {
                        self.noneFriendsView.isHidden = false
                    }
                    self.progressView.isHidden = true
                    self.facebookFriendsCollectionView.reloadData()
                    
                    print(dataResponse)
                }
            } else {
                print("Error Getting Friends \(String(describing: error))");
            }
            
        })
        
        connection.start()
    }
    
    
    class FBFriend
    {
        var facebookID : String?
        var name : String?
    }
    
    func registerAllNibsInCollectionView()
    {
        let nibName = UINib(nibName: "FacebookFriendCellCollectionViewCell", bundle:nil)
        self.facebookFriendsCollectionView.register(nibName, forCellWithReuseIdentifier: "fb_friend_cell")
    }
    
}
