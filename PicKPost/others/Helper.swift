//
//  File.swift
//  PicKPost
//
//  Created by IBAdmin on 27/10/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import Foundation
import UIKit

class Constants
{
    public static let MAIN = "Main"
}

class Keys
{
    public static let URL = "url"
    public static let FIRST_NAME = "first_name"
    public static let NAME = "name"
    public static let LAST_NAME = "last_name"
    public static let PICTURE = "picture"
    public static let DATA = "data"
    public static let EMAIL = "email"
    public static let GENDER = "gender"
    public static let COVER = "cover"
    public static let SOURCE = "source"
    public static let ID = "id"
    public static let WORK = "work"
    public static let EMPLOYER = "employer"
    public static let POSITION = "position"
    public static let LOCATION  = "location"
    public static let FULL_PICTURE = "full_picture"
    public static let STATUS_TYPE = "status_type"
    public static let MESSAGE = "message"
    public static let CREATED_TIME = "created_time"
    public static let TYPE = "type"
    public static let LINK = "link"
    public static let STORY = "story"
   // public static let SOURCE = "source"
}

class NetworkRequestHelper
{
    
    static let imageCache = NSCache<NSString, AnyObject>()
    
    
    public static func downloadImage(url: String, imageView:UIImageView)
    {
        //print("Download Started")
        let imageURL = URL(string: url)
        if let cachedImage = imageCache.object(forKey: imageURL?.absoluteString as! NSString) as? UIImage
        {
            imageView.image = cachedImage
        }
        else
        {
            let imageURL = URL(string: url)
            getDataFromUrl(url: imageURL!) { (data, response, error)  in
                guard let data = data, error == nil else { return }
               // print(response?.suggestedFilename ?? imageURL!.lastPathComponent )
                // print("Download Finished")
                DispatchQueue.main.async() { () -> Void in
                   
                    imageView.image = UIImage(data: data)
                    imageCache.setObject(UIImage(data: data)!, forKey: imageURL?.absoluteString as! NSString)
                }
            }
        }
        
    }
    
    public static func downloadFacebookProfile(url: String, imageView:UIImageView)
    {
       
        let encodedStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let imageURL = URL(string: encodedStr!)
            getDataFromUrl(url: imageURL!) { (data, response, error)  in
                guard let data = data, error == nil else { return }
               // print(response?.suggestedFilename ?? imageURL!.lastPathComponent )
                // print("Download Finished")
                DispatchQueue.main.async() { () -> Void in
                    
                    imageView.image = UIImage(data: data)
                    imageCache.setObject(UIImage(data: data)!, forKey: imageURL?.absoluteString as! NSString)
                }
            }
    
        
    }
    
    static func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    public static func doGetDataRequest(_ url:String, _ completetion :@escaping (Data?, URLResponse?, Error?) -> Void )
    {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask:URLSessionDataTask?
        
      //  let encodedStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //let encodedStr = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.controlCharacters)
        let searchURL = URL(string: url)
        let urlRequest = URLRequest(url: searchURL!)
        dataTask = defaultSession.dataTask(with: urlRequest, completionHandler: completetion)
        dataTask?.resume()
    }
    
}

class SegueIdenitifiers
{
    public static let POST_IMAGE_ID  = "open_image"
    public static let OPEN_POST_LINK = "open_post_link"
    public static let PHOTO_EDITOR = "photo_editor"
    public static let FB_PHOTO_EDITOR = "fb_photo_editor"
}

class DataModelKeys
{
    public static let WORK_INFO = "WorkInfo"
    public static let FACEBOOK_USER_PROFILE = "FacebookUserProfile"
    
}


class StoryBoardIDs
{
    public static let DRAWER_CONTROLLER_ID = "drawer_controller"
    public static let HOME_CONTROLLER_ID = "home_controller"
    public static let ALL_PHOTOS_CONTROLLER_ID = "all_photos_controller"
    public static let FACEBOOK_LOGIN_CONTROLLER_ID = "facebook_login_controller"
    public static let POST_PHOTO_ON_FACEBOOK_CONTROLLER_ID  = "post_photo_on_fb"
    public static let ALL_FACEBOOK_PHOTOS_CONTROLLER_ID = "all_facebook_photos"
    public static let ALL_FACEBOOK_FRIENDS_CONROLLER_ID = "facebook_friend_view_controller"
    public static let FACEBOOK_FEEDS_CONTROLLER_ID  = "facebook_feeds"
    public static let NAVIGATION_CONTROLLER_ID = "rtm_controller"
}
