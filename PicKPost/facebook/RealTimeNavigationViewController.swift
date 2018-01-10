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
    
    @IBOutlet weak var searchDirectionButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var myRoute : MKRoute!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        initActionBar()
        makeButtonRounded()
    
    }
    
    
    @IBAction func openSearchDirection(_ sender: Any)
    {
        let popvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "source_destination_controller") as! SearchSourceDestinationViewController
        popvc.mapView = mapView
        popvc.realTimeNavigationController = self
        self.addChildViewController(popvc)
        
        popvc.view.frame = self.view.frame
        
        self.view.addSubview(popvc.view)
        
        popvc.didMove(toParentViewController: self)
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
        
      /*  if overlay is MKCircle
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
        else
        {
            let myLineRenderer = MKPolylineRenderer(polyline: myRoute.polyline)
            myLineRenderer.strokeColor = UIColor.red
            myLineRenderer.lineWidth = 3
            return myLineRenderer
        }  */
        
        let myLineRenderer = MKPolylineRenderer(polyline: myRoute.polyline)
        myLineRenderer.strokeColor = UIColor.red
        myLineRenderer.lineWidth = 3
        return myLineRenderer
     
    }
    
    
    fileprivate func makeButtonRounded()
    {
        searchDirectionButton.layer.cornerRadius = 10.0
        searchDirectionButton.layer.borderWidth = 1
        searchDirectionButton.clipsToBounds = true
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
    
    func onSelectDirection(_ source : MKMapItem, _  destination : MKMapItem)
    {
        let point1 = MKPointAnnotation()
        let point2 = MKPointAnnotation()
        
        point1.coordinate = CLLocationCoordinate2DMake(source.placemark.coordinate.latitude,source.placemark.coordinate.longitude)
        point1.title = source.name
        point1.subtitle = source.name
        mapView.addAnnotation(point1)
        
        print(" \(String(describing: source.name))")
        
        point2.coordinate = CLLocationCoordinate2DMake(destination.placemark.coordinate.latitude,destination.placemark.coordinate.longitude)
        point2.title = destination.name
        point2.subtitle = destination.name
        mapView.addAnnotation(point2)
        mapView.centerCoordinate = point2.coordinate
        mapView.delegate = self
        
        //Span of the map
        mapView.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        let markTaipei = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        let markChungli = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: markChungli)
        directionsRequest.destination = MKMapItem(placemark: markTaipei)
        
        directionsRequest.transportType = MKDirectionsTransportType.automobile
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate(completionHandler: {
            response, error in
            
            if error == nil
            {
                print("Route found")
                self.myRoute = response!.routes[0] as MKRoute
                self.mapView.add(self.myRoute.polyline)
            }
            else
            {
                print("Error while fetching route : \(String(describing: error))")
            }
            
        })
    }
    
    
    
    func mapView(_: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(SearchSourceDestinationViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
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
