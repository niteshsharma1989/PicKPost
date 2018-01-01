//
//  OpenFacebookPostViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 14/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit
import WebKit

class OpenFacebookPostViewController: UIViewController
{
    @IBOutlet weak var postLinkWebView: WKWebView!
    
    @IBOutlet weak var webView: UIWebView!
    var currentLink : String?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let url = URL(string:currentLink!)
        let request = URLRequest(url:url! as URL)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
