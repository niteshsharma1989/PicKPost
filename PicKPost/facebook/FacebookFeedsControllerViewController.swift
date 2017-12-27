//
//  FacebookFeedsControllerViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 08/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//https://stackoverflow.com/questions/32804655/changing-constraints-at-runtime-in-swift

import UIKit
import FBSDKCoreKit



class FacebookFeedsControllerViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate /// UICollectionViewDataSource, UICollectionViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.facebokPostList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let facebookPost = self.facebokPostList[indexPath.row]
        
        let maxCount  = self.facebokPostList.count - 1
        
        if indexPath.row == maxCount
        {
            
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: "loading_tc") as! LoadingTableViewCell
            self.requestForMoreFeeds()
            return loadingCell
        }
        else
        {
             let statusCell = tableView.dequeueReusableCell(withIdentifier: "status1") as! PostCellTableViewCell
            
             statusCell.uploadedImageView.image = UIImage(named: "facebook_photos")
             return self.renderPostCell(statusCell, facebookPost, indexPath)
        }
    }
    
    
    @objc func openPostLink( _ sender : UITapGestureRecognizer)
    {
        performSegue(withIdentifier: SegueIdenitifiers.OPEN_POST_LINK, sender: sender.view as!  PostCellTableViewCell)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SegueIdenitifiers.OPEN_POST_LINK
        {
            let destination = segue.destination as? OpenFacebookPostViewController
            //destination.currentPhassets
            guard let cell = sender as? PostCellTableViewCell else { fatalError("unexpected sender") }
            
            if let indexPath = tabelView?.indexPath(for: cell) {
                destination?.currentLink = facebokPostList[indexPath.row].link
            }
            
        }
    }
    
    fileprivate func renderPostCell( _ statusCell : PostCellTableViewCell, _ facebookPost : FacebookPosts, _ indexPath : IndexPath) -> PostCellTableViewCell
    {
        let openStatus = UITapGestureRecognizer(target: self, action: #selector(self.openPostLink(_:)))
        statusCell.addGestureRecognizer(openStatus)
        
        
        if facebookPost.creatdTime != nil
        {
            statusCell.timeOfPostTv.text = getFormattedDate(facebookPost.creatdTime)
        }
        
        if facebookPost.message != nil
        {
            statusCell.messageLabel.text = facebookPost.message
        }
        else
        {
            statusCell.messageLabel.text = ""
        }
        
        
        if facebookPost.story != nil
        {
            statusCell.storyLabel.text = facebookPost.story
        }
        else
        {
            statusCell.storyLabel.text = ""
        }
        
        statusCell.uploadedImageView?.contentMode = UIViewContentMode.scaleAspectFill
        statusCell.uploadedImageView?.clipsToBounds = true
        
        if facebookPost.full_picture != nil
        {
            statusCell.imageViewHeight.constant = 180
            NetworkRequestHelper.downloadImage(url: (facebookPost.full_picture)!, imageView: (statusCell.uploadedImageView)!)
        }
        else
        {
            statusCell.imageViewHeight.constant = 0
        }
        return statusCell
        
    }
    
    
    
    func getFormattedDate(_ dateToFormate : String) -> String
    {
        let deFormatter = DateFormatter()
        deFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let startTime = deFormatter.date(from: dateToFormate)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd YYYY HH:mm:ss"
        let timeString = formatter.string(from: startTime!)
        
        return timeString
    }
    
    
    var nextPageToken : String!
    
    @IBOutlet weak var tabelView: UITableView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.facebokPostList.count
    }
    
   
    @IBOutlet weak var no_feeds_view: UIView!
    @IBOutlet weak var innerProgressViewIndicator: UIView!
    @IBOutlet weak var progressView: UIView!
  //  @IBOutlet weak var feedsCollectionView: UICollectionView!
    
    var facebokPostList : [FacebookPosts] = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.progressView.isHidden = false
        self.no_feeds_view.isHidden = true
        initActionBar()
        registerAllNibsInTableView()
        self.tabelView.estimatedRowHeight = 250
        tabelView.rowHeight = UITableViewAutomaticDimension
        getFacebokFeeds()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       // self.tabelView.estimatedRowHeight = 44
      //  self.tabelView.rowHeight = UITableViewAutomaticDimension
    }
    
    func registerAllNibsInTableView()
    {
        let nibName = UINib(nibName: "LoadingTableViewCell", bundle:nil)
        self.tabelView.register(nibName, forCellReuseIdentifier:"loading_tc")
        
    }
    
    
    func initActionBar()
    {
        
        self.title = "Facebook Feeds"
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
    
    override func viewDidAppear(_ animated: Bool) {
     
        self.tabelView.reloadData()
        print(facebokPostList.count)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func getFacebokFeeds()
    {
        let params = ["fields": "story,message,id,link,full_picture,status_type,type,created_time"]
        
        let graphRequest = FBSDKGraphRequest(graphPath: "/me/feed", parameters: params)
        
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) in
            if error == nil {
                if let userData = result as? [String:Any]
                {
                    let dataResponse = userData["data"] as! [Any]
                    
                    if dataResponse.count > 0
                    {
                        self.no_feeds_view.isHidden = true
                        
                        for datax in dataResponse
                        {
                            print(datax)
                            
                            let data = datax as! [String: String]
                            
                            let facebookFeeds = FacebookPosts()
                            facebookFeeds.id = data[Keys.ID]
                            
                            if data.index(forKey: Keys.FULL_PICTURE) != nil
                            {
                                facebookFeeds.full_picture = data[Keys.FULL_PICTURE]
                            }
                            if data.index(forKey: Keys.STATUS_TYPE) != nil
                            {
                                facebookFeeds.status_type = data[Keys.STATUS_TYPE]
                            }
                            if data.index(forKey: Keys.CREATED_TIME) != nil
                            {
                                facebookFeeds.creatdTime = data[Keys.CREATED_TIME]
                            }
                            if data.index(forKey: Keys.MESSAGE) != nil
                            {
                                facebookFeeds.message = data[Keys.MESSAGE]
                            }
                            if data.index(forKey: Keys.TYPE) != nil
                            {
                                facebookFeeds.type = data[Keys.TYPE]
                            }
                            if data.index(forKey: Keys.LINK) != nil
                            {
                                facebookFeeds.link = data[Keys.LINK]
                            }
                            if data.index(forKey: Keys.STORY) != nil
                            {
                                facebookFeeds.story = data[Keys.STORY]
                            }
                            self.facebokPostList.append(facebookFeeds)
                            
                          
                        }
                    }
                    else
                    {
                        self.no_feeds_view.isHidden = true
                    }
                    let pagingResponse = userData["paging"] as! [String  : Any]
                    if pagingResponse.index(forKey: "next") != nil
                    {
                        self.nextPageToken = pagingResponse["next"] as! String
                        self.facebokPostList.append(FacebookPosts())
                    }
                    self.progressView.isHidden = true
                    
                    self.tabelView.reloadData()
                    //self.facebookFriendsCollectionView.reloadData()
                    
                  
                }
            } else {
                print("Error Getting Friends \(String(describing: error))");
            }
            
        })
        
        connection.start()
    }
    
    
    func requestForMoreFeeds()
    {
        
        if nextPageToken != nil
        {
            NetworkRequestHelper.doGetDataRequest( nextPageToken, { ( data : Data?,  urlResponse  : URLResponse?, error  : Error?) -> Void in
                
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    print(json)
                    let dataResponse = json!["data"] as! [Any]
                    self.facebokPostList.remove(at: self.facebokPostList.count - 1)
                    
                    if dataResponse.count > 0
                    {
                        self.no_feeds_view.isHidden = true
                        
                        for datax in dataResponse
                        {
                            print(datax)
                            
                            let data = datax as! [String: String]
                            
                            let facebookFeeds = FacebookPosts()
                            facebookFeeds.id = data[Keys.ID]
                            
                            if data.index(forKey: Keys.FULL_PICTURE) != nil
                            {
                                facebookFeeds.full_picture = data[Keys.FULL_PICTURE]
                            }
                            if data.index(forKey: Keys.STATUS_TYPE) != nil
                            {
                                facebookFeeds.status_type = data[Keys.STATUS_TYPE]
                            }
                            if data.index(forKey: Keys.CREATED_TIME) != nil
                            {
                                facebookFeeds.creatdTime = data[Keys.CREATED_TIME]
                            }
                            if data.index(forKey: Keys.MESSAGE) != nil
                            {
                                facebookFeeds.message = data[Keys.MESSAGE]
                            }
                            if data.index(forKey: Keys.TYPE) != nil
                            {
                                facebookFeeds.type = data[Keys.TYPE]
                            }
                            if data.index(forKey: Keys.LINK) != nil
                            {
                                facebookFeeds.link = data[Keys.LINK]
                            }
                            
                            if data.index(forKey: Keys.STORY) != nil
                            {
                                facebookFeeds.story = data[Keys.STORY]
                            }
                            
                            self.facebokPostList.append(facebookFeeds)
                            
                            
                        }
                    }
                    let pagingResponse = json!["paging"] as! [String  : Any]
                    if pagingResponse.index(forKey: "next") != nil
                    {
                        self.nextPageToken = pagingResponse["next"] as! String
                        self.facebokPostList.append(FacebookPosts())
                    }
                    else
                    {
                        self.nextPageToken = nil
                    }
                    
                    
                    
                    //
                    //
                    DispatchQueue.main.async() { () -> Void in
                        
                        self.tabelView.reloadData()
                    }
                    
                    
                }
                catch
                {
                    print("Error while fetching next page photos")
                    print(error)
                }
                
                
                
                
                
            })
        }
        
    }
    
    
    
    class FacebookPosts
    {
        var id : String!
        var status_type : String!
        var full_picture : String!
        var type : String!
        var message : String!
        var creatdTime : String!
        var link : String!
        var story : String!
    }
    
    


}
