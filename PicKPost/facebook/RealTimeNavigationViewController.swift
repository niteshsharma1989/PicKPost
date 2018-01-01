//
//  RealTimeNavigationViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 14/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//https://github.com/rshankras/MapViewDemo

import UIKit
import MapKit
import CoreLocation

class RealTimeNavigationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    let locationManager = CLLocationManager()
    var myLocations : [CLLocation] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        initActionBar()
        
        
  
    }
    
 
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        // UILabel.text = "\(locations[0])"
        myLocations.append(locations[0] as! CLLocation)
        
        print("Location : \(locations[0])")
        
        showAlert("Location : \(locations.count)")
        
        
        
        //drawing path or route covered
       
        
      
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        
        
        if (myLocations.count > 1)
        {
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.add(polyline)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
       /* if overlay is MKPolyline
        {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        } */
        
        if overlay is MKCircle
        {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
            
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
        }
        
        return MKOverlayRenderer()
     
    }
    
    
    
    func initActionBar()
    {
        
        self.title = "Navigation"
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
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        switch status
        {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
     
    }

   
    
    func showAlert(_ title: String)
    {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }

}
