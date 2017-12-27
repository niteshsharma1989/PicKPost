//
//  AllPhotosViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 31/10/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit
import Photos

class AllPhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var allPhotosCollectionView: UICollectionView!
      fileprivate let imageManager = PHCachingImageManager()
    
    var thumbnailSize :CGSize? = nil
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosContants.PHOTOS_CELL, for: indexPath as IndexPath) as? PhotosCell
         let asset = allPhotos.object(at: indexPath.item)
        cell!.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize!, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell?.representedAssetIdentifier == asset.localIdentifier && image != nil
            {
                cell!.photoImageView.image = image
            }
            
        })
        
        let galleryGesture = UITapGestureRecognizer(target: self, action: #selector(self.openPhotoEditor(_:)))
        cell?.addGestureRecognizer(galleryGesture)
     
        let resources = PHAssetResource.assetResources(for: asset)
            if let resource = resources.first {
                cell?.imageNameLabel.text = resource.originalFilename
            }
        
        return cell!
    }
    
    
    @objc func shareOnFacebook( _ sender : UITapGestureRecognizer)
    {
        performSegue(withIdentifier: SegueIdenitifiers.POST_IMAGE_ID, sender: sender.view as! PhotosCell)
    }
    @objc func openPhotoEditor( _ sender : UITapGestureRecognizer)
    {
        performSegue(withIdentifier: SegueIdenitifiers.PHOTO_EDITOR, sender: sender.view as! PhotosCell)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SegueIdenitifiers.POST_IMAGE_ID
        {
             let destination = segue.destination as? PostPhotoOnFacebookViewController
            //destination.currentPhassets
            guard let cell = sender as? PhotosCell else { fatalError("unexpected sender") }
            
            if let indexPath = allPhotosCollectionView?.indexPath(for: cell) {
                destination?.currentPhassets = allPhotos.object(at: indexPath.item)
            }
          
        }
        else if segue.identifier == SegueIdenitifiers.PHOTO_EDITOR
        {
            let destination = segue.destination as? ImageEditorViewController
            //destination.currentPhassets
            guard let cell = sender as? PhotosCell else { fatalError("unexpected sender") }
            
            if let indexPath = allPhotosCollectionView?.indexPath(for: cell) {
                destination?.currentPhassets = allPhotos.object(at: indexPath.item)
            }
            
        }
    }
    
    
    
    
   
    var allPhotos: PHFetchResult<PHAsset>!
    
    
    func registerAllNibsInCollectionView()
    {
        
        let nibName = UINib(nibName: "PhotosCell", bundle:nil)
        
        allPhotosCollectionView.register(nibName, forCellWithReuseIdentifier: PhotosContants.PHOTOS_CELL)
        
        
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
    initActionBar()
       
        registerAllNibsInCollectionView()
        loadAllPhotos()
        initPhotoCell()
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //initActionBar()
    }
    
    
   
    func initPhotoCell()
    {
        let viewWidth = view.bounds.size.width
        
        let desiredItemWidth: CGFloat = allPhotosCollectionView.bounds.width/2
        let itemHeightx = allPhotosCollectionView.bounds.height/4
        let columns: CGFloat = max(floor(viewWidth / desiredItemWidth), 2)
        let padding: CGFloat = 1
        let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
        let itemSize = CGSize(width: desiredItemWidth - 0.5, height: itemHeightx)
        
        
        thumbnailSize = itemSize
        
        if let layout = allPhotosCollectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = 1
            
            layout.minimumLineSpacing = 1
        }
    }
    
    func loadAllPhotos()
    {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: PhotosContants.CREATION_DATE, ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        print("All Photos Count \(allPhotos.count)")
        if allPhotos.count > 0
        {
            allPhotosCollectionView.reloadData()
        }
        PHPhotoLibrary.shared().register(self)
    }
    
    
    func initActionBar()
    {
        
        self.title = "Gallery"
        //navigationController?.navigationBar.barTintColor = UIColor.green
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 255/255, green: 163/255, blue: 60/255, alpha: 1.00)
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "drawer_sms"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(toggelDrawer))
        
        // Adding button to navigation bar (rightBarButtonItem or leftBarButtonItem)
        self.navigationItem.leftBarButtonItem = barButtonItem
        
    }
    
    func initActionBarOld()
    {
        
        
        self.navigationController?.navigationBar.topItem?.title = "Gallery"
        navigationController?.navigationBar.barTintColor = UIColor.white// UIColor(red: 134/255, green: 230/255, blue: 255/255, alpha: 1.00)
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
    
    deinit
    {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
    extension AllPhotosViewController: PHPhotoLibraryChangeObserver
    {
        
        func photoLibraryDidChange(_ changeInstance: PHChange)
        {
            // Change notifications may be made on a background queue. Re-dispatch to the
            // main queue before acting on the change as we'll be updating the UI.
            DispatchQueue.main.sync
            {
                if let changeDetails = changeInstance.changeDetails(for: allPhotos)
                {
                    // Update the cached fetch result.
                    allPhotos = changeDetails.fetchResultAfterChanges
                     print("All Photos Count \(allPhotos.count)")
                    if allPhotos.count > 0
                    {
                        allPhotosCollectionView.reloadData()
                    }
                    // (The table row for this one doesn't need updating, it always says "All Photos".)
                }
            
            }
        }
}


