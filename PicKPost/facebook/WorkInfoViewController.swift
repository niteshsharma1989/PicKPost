//
//  WorkInfoViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 07/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit

class WorkInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    let left = CGAffineTransform(translationX: -300, y: 0)
    let right = CGAffineTransform(translationX: 300, y: 0)
    let top = CGAffineTransform(translationX: 0, y: 300)
    let bottom = CGAffineTransform(translationX: 0, y: 0300)
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.workInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "work_info_cell", for: indexPath as IndexPath) as? WorkInfoCollectionViewCell
        
        let workInfo = self.workInfoList[indexPath.row]
        
        
        if workInfo.position != nil
        {
            cell?.companyNameLabel.text = "\(String(describing: workInfo.employer!)), \(String(describing: workInfo.position!))"
            cell?.countryLabel.text = "\(String(describing: workInfo.location!))"
        }
        else
        {
            cell?.companyNameLabel.text = "\(String(describing: workInfo.employer!)))"
            cell?.countryLabel.text = "\(String(describing: workInfo.location!))"
        }
        
       
        
        return cell!
    }
    
    
    func initWorkCell()
    {
        let viewWidth = view.bounds.size.width
        
       
        let itemHeightx = view.bounds.size.height / 9
      
        let itemSize = CGSize(width: viewWidth, height: itemHeightx)
        
        
        if let layout = workCollectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = 0
            
            layout.minimumLineSpacing = 0
        }
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var workCollectionView: UICollectionView!
    var workInfoList : [WorkInfo] = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        showAnimate()
        registerAllNibsInCollectionView()
        initWorkCell()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var dismissController: UIButton!
    
    @IBAction func dismisControllerDialog(_ sender: Any)
    {
        removeAnimate()
    }
    
    
    func registerAllNibsInCollectionView()
    {
        
        let nibName = UINib(nibName: "WorkInfoCollectionViewCell", bundle:nil)
        
        workCollectionView.register(nibName, forCellWithReuseIdentifier: "work_info_cell")
        
        
    }
    
    

    func showAnimate()
    {
        self.view.transform = top///CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.4, animations:
            {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.4, animations:
            {
                self.view.transform =  self.bottom //  CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        })
    }

}
