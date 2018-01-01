//
//  AllFacebookPhotosViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 07/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class AllFacebookPhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    
    var nextPageURL : String!
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return allFacebookPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let nextRow = indexPath.row + 1
        if nextRow == allFacebookPhotos.count && self.nextPageURL != nil
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loading_cell", for: indexPath as IndexPath) as? LoadingCollectionViewCell
            
            if nextPageURL != nil
            {
                NetworkRequestHelper.doGetDataRequest( nextPageURL, { ( data : Data?,  urlResponse  : URLResponse?, error  : Error?) -> Void in
                    
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                        print(json)
                        let items = json!["data"] as? [Any]
                        self.allFacebookPhotos.remove(at: self.allFacebookPhotos.count - 1)
                        for dataItemx in items!
                        {
                            let dataItem = dataItemx as! [String : String]
                            let source = dataItem[Keys.SOURCE]
                            let id = dataItem[Keys.ID]
                            let facebookPhoto = FacebookPhotos()
                            facebookPhoto.photoID = id
                            facebookPhoto.photoURL = source
                           
                            self.allFacebookPhotos.append(facebookPhoto)
                        }
                        let pagingResponse = json!["paging"] as! [String : Any]
                        
                        if pagingResponse.index(forKey: "next") != nil
                        {
                            self.nextPageURL = pagingResponse["next"] as! String
                            self.allFacebookPhotos.append(FacebookPhotos())
                             print("========> \(String(describing: pagingResponse["next"]))")
                            
                        }
                        else
                        {
                            self.nextPageURL = nil
                        }
                        
                      //
                     //
                        DispatchQueue.main.async() { () -> Void in
                            
                            self.facebokPhotosCollectionView.reloadData()
                        }
                       
                        
                    }
                    catch
                    {
                        print("Error while fetching next page photos")
                        print(error)
                    }
                    
                    
                    
                    
                    
                })
            }
            
            
            
            return cell!
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "facebook_photo_cell", for: indexPath as IndexPath) as? FacebookPhotoCellCollectionViewCell
            
            let fbPhoto = allFacebookPhotos[indexPath.row]
            cell!.facebookPhoto.image = UIImage(named: "facebook_photos")
            NetworkRequestHelper.downloadImage(url: (fbPhoto.photoURL)!, imageView: (cell!.facebookPhoto)!)
            let galleryGesture = UITapGestureRecognizer(target: self, action: #selector(self.openPhotoEditor(_:)))
            cell?.addGestureRecognizer(galleryGesture)
            return cell!
        }
        
        
    }
    @objc func openPhotoEditor( _ sender : UITapGestureRecognizer)
    {
        print("------1111")
        performSegue(withIdentifier: SegueIdenitifiers.FB_PHOTO_EDITOR, sender: sender.view as! FacebookPhotoCellCollectionViewCell)
        print("------2222")
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("------33333")
        
        if segue.identifier == SegueIdenitifiers.FB_PHOTO_EDITOR
        {
            print("------44444")
            
            let destination = segue.destination as? ImageEditorViewController
            //destination.currentPhassets
            guard let cell = sender as? FacebookPhotoCellCollectionViewCell else { fatalError("unexpected sender") }
            destination?.currentPhassets = nil
            destination?.currentUIImage = cell.facebookPhoto.image
        }
        print("-----555555")
    }
    
    
    func initPhotoCell()
    {
        //let viewWidth = view.bounds.size.width
        
        let desiredItemWidth: CGFloat = facebokPhotosCollectionView.bounds.width/2
        let itemHeightx = facebokPhotosCollectionView.bounds.height/4
        // let _: CGFloat = max(floor(viewWidth / desiredItemWidth), 2)
       // let padding: CGFloat = 1
       // let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
        let itemSize = CGSize(width: desiredItemWidth - 0.5, height: itemHeightx)
        
        
       // thumbnailSize = itemSize
        
        if let layout = facebokPhotosCollectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = 1
            
            layout.minimumLineSpacing = 1
        }
    }
    
    var allFacebookPhotos : [FacebookPhotos] = []
   
    @IBOutlet weak var innerProgressView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var facebokPhotosCollectionView: UICollectionView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        progressView.isHidden = false
        initActionBar()
        initPhotoCell()
        initIndicator()
        registerAllNibsInCollectionView()
        fetchFacebookUserPhotos()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func fetchFacebookUserPhotos()
    {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/photos", parameters: ["fields":"picture, source"] )
        
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(String(describing: error))")
            }
            else
            {
                print("fetched photos : \(String(describing: result))")
                
                let fbResult:[String:AnyObject] = result as! [String : AnyObject]
                
                let dataResponse = fbResult["data"] as! [Any]
                
                for datax in dataResponse
                {
                    let data = datax as! [String : String]
                    let id = data[Keys.ID]
                    print("Facebook Photo ID \(String(describing: id!))")
                    let picture = data[Keys.SOURCE]
                    print("Picture \(String(describing: picture!))")
                    
                    let facebookPhoto = FacebookPhotos()
                    facebookPhoto.photoID = id
                    facebookPhoto.photoURL = picture
                    
                    self.allFacebookPhotos.append(facebookPhoto)
                }
                
                let pagingResponse = fbResult["paging"] as! [String : Any]
               // print("========> \(String(describing: pagingResponse["next"]))")
                self.nextPageURL = pagingResponse["next"] as! String
                
                self.allFacebookPhotos.append(FacebookPhotos())
                self.facebokPhotosCollectionView.reloadData()
                self.progressView.isHidden = true
            }
        })
    }
    
    func initActionBar()
    {
        
        self.title = "Facebook Photos"
      //  self.navigationController?.navigationBar.barTintColor = UIColor.white// UIColor(red: 134/255, green: 230/255, blue: 255/255, alpha: 1.00)
       
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 255/255, green: 163/255, blue: 60/255, alpha: 1.00)
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "drawer_sms"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(toggelDrawer))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
    }
    
    fileprivate func initIndicator()
    {
        innerProgressView.layer.cornerRadius = 10.0
        innerProgressView.layer.borderWidth = 0.5
        innerProgressView.clipsToBounds = true
      
        
    }
    
    func registerAllNibsInCollectionView()
    {
        
        let nibName = UINib(nibName: "FacebookPhotoCellCollectionViewCell", bundle:nil)
        
        facebokPhotosCollectionView.register(nibName, forCellWithReuseIdentifier: "facebook_photo_cell")
        
        let nibName2 = UINib(nibName: "LoadingCollectionViewCell", bundle:nil)
        
        facebokPhotosCollectionView.register(nibName2, forCellWithReuseIdentifier: "loading_cell")
        
        
    }
    
    @objc fileprivate func toggelDrawer()
    {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    class FacebookPhotos
    {
        var photoID : String!
        var photoURL : String!
        
    }
}
