//
//  SearchSourceDestinationViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 03/01/18.
//  Copyright © 2018 Infobeans. All rights reserved.
//

import UIKit
import MapKit

class SearchSourceDestinationViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.matchingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cellIdentifier = "map_item_cell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MapSearchItemCollectionViewCell;
        
        let mkMapIem = matchingItems[indexPath.row]
        cell.mapItemLabel.text = "\(mkMapIem.name!), \(mkMapIem.placemark.region!)"
        
        
        
      
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLocation(
            sender :)))
        
        cell.contentView.tag = indexPath.row
        cell.contentView.addGestureRecognizer(tap)
        
        return cell;
    }
    @objc func selectLocation(sender : UITapGestureRecognizer)
    {
        dismissKeyboards()
        let view  = sender.view
        let selectedLocation = matchingItems[(view?.tag)!]
        if currentSearchBar != nil
        {
            currentSearchBar?.text = selectedLocation.name
        }
        else
        {
            print("CUrrent Search Bar is null")
        }
        
        if currentSearchBar != nil && currentSearchBar == sourceLovationSearchBar
        {
            fromMKMapItem = selectedLocation
        }
        if currentSearchBar != nil && currentSearchBar == destinationLocationSearchBar
        {
            toMKMapItem = selectedLocation
        }
        
        
        
    }

    @IBOutlet weak var sourceContainerView: UIView!
    @IBOutlet weak var destinationContainerView: UIView!
    var matchingItems:[MKMapItem] = []
    
    let left = CGAffineTransform(translationX: -300, y: 0)
    let right = CGAffineTransform(translationX: 300, y: 0)
    let top = CGAffineTransform(translationX: 0, y: 300)
    let bottom = CGAffineTransform(translationX: 0, y: 0300)
    
    var fromMKMapItem : MKMapItem?
    var toMKMapItem : MKMapItem?
    
    
    var selectedPin:MKPlacemark? = nil
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    //    @IBOutlet var mapView: UIMapView!
    //    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var sourceLovationSearchBar: UISearchBar!
    @IBOutlet weak var destinationLocationSearchBar: UISearchBar!
    
    var currentSearchBar : UISearchBar?
    
    @IBOutlet weak var cancelButon: UIView!
    @IBOutlet weak var okayButton: UIView!
    
    var realTimeNavigationController : RealTimeNavigationViewController?
    
    
    @IBAction func onPressCancel(_ sender: Any)
    {
         removeAnimate()
    }
    
    @IBAction func onPressOkay(_ sender: Any)
    {
        realTimeNavigationController?.onSelectDirection( fromMKMapItem!, toMKMapItem!)
      removeAnimate()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate()
    {
        self.view.transform = top///CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations:
            {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.3, animations:
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        showAnimate()
        makeButtonRounded()
        let cellIdentifier = "map_item_cell"
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView.register(UINib(nibName:"MapSearchItemCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.sourceLovationSearchBar.delegate = self
         self.destinationLocationSearchBar.delegate = self
        intCell()
        mapView.delegate = self
        
      //  let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
      //  locationSearchTable.handleMapSearchDelegate = self
        
     //   resultSearchController = UISearchController(searchResultsController: locationSearchTable)
     //   resultSearchController?.searchResultsUpdater = locationSearchTable
        
     //   let searchBar = resultSearchController!.searchBar
     //   searchBar.sizeToFit()
     //   searchBar.placeholder = "Search for Destnation Location"
     //   self.sourceContainerView.addSubview((resultSearchController?.searchBar)!)
        
   //     resultSearchController?.hidesNavigationBarDuringPresentation = false
      //  resultSearchController?.dimsBackgroundDuringPresentation = true
     //   definesPresentationContext = true
        
     //   locationSearchTable.mapView = mapView

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboards))
        view.addGestureRecognizer(tap)
     //   self.collectionView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboards() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    fileprivate func makeButtonRounded()
    {
        okayButton.layer.cornerRadius = 10.0
        okayButton.layer.borderWidth = 1
        okayButton.clipsToBounds = true
        
        cancelButon.layer.cornerRadius = 10.0
        cancelButon.layer.borderWidth = 1
        cancelButon.clipsToBounds = true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        if (searchBar.text?.isEmpty)!
        {
            self.matchingItems = []
            self.collectionView.reloadData()
            
            
        }
        
        
        self.currentSearchBar = searchBar
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
     //   self.currentSearchBar = nil
       }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        //guard let mapView = mapView,
          //  var searchBarText = searchText else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            
            
            
            
            for mapItems in self.matchingItems
            {
               // print("======\(mapItems.name)")
            }
            self.collectionView.reloadData()
            
           // self.tableView.reloadData()
        }
       
    }

    
    func intCell()
    {
        let viewWidth = view.bounds.size.width
        
        
        let itemHeightx = view.bounds.size.height / 11
        
        let itemSize = CGSize(width: viewWidth, height: itemHeightx)
        
        
        if let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = 0
            
            layout.minimumLineSpacing = 1
        }
        
        
        
    }
    
    
    @objc func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}

extension SearchSourceDestinationViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

extension SearchSourceDestinationViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension LocationSearchTable {
    //    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}





