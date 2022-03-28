//
//  TackDistanceVCViewController.swift
//  Joker
//
//  Created by cst on 05/09/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AFNetworking
import SwiftyJSON

import SwiftyShadow
import QuartzCore
import Crashlytics

class TackDistanceVCViewController: UIViewController {

    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var lblHeader: UILabel!
   
   
    //MARK: - VARIABLES
    var locationManager = CLLocationManager()
    var latM = CLLocationDegrees()
    var langM = CLLocationDegrees()
    var currentLocationMarker: GMSMarker?
    
    let addressWindow = Bundle.main.loadNibNamed("MarkerForSource", owner: self, options: nil)!.first! as! MarkerForSource
     var locationMarker : GMSMarker? = GMSMarker()
    
     let addressWindowDrop = Bundle.main.loadNibNamed("MarkerForDestination", owner: self, options: nil)!.first! as! MarkerForDestination
    
    
    var userLatitude = Double()
    var userLongitude = Double()
    
   
    var browserKey = "AIzaSyBm6eN8n8A3tzhp-RYKwDZhHw3IfJ36BNA"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblHeader.text = "Track Distance".localized()
      //  initializeTheLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        mapview.isMyLocationEnabled = false
        
        var latK = Double()
        var longK = Double()
       
        print("###### latK:\(self.latM) longK:\(self.langM)")
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 3)
       // {
        self.userLongitude = CommonClass.sharedInstance.locationLongCordinate
        self.userLatitude =  CommonClass.sharedInstance.locationLatCordinate
        
            print("@@@ latK:\(self.latM) longK:\(self.langM) userLatitude:\(self.userLatitude) userLongitude:\(self.userLongitude)")
             
            let LocationSource: CLLocation = CLLocation(latitude: CommonClass.sharedInstance.locationLatCordinate , longitude: CommonClass.sharedInstance.locationLongCordinate )
            let LocationDestination: CLLocation = CLLocation(latitude: langM , longitude:latM )
            self.drawPath(startLocation: LocationSource, endLocation: LocationDestination)
      //  }
        
        //  }
        
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK: - Extension Method Access Current Location
extension TackDistanceVCViewController
{
    //TODO: Method Access Current Location
    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
    }
}

extension TackDistanceVCViewController:GMSMapViewDelegate,CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        locationManager.startUpdatingHeading()
        
        var location = locationManager.location?.coordinate
        //cameraMoveToLocation(toLocation: location)
        latM = CLLocationDegrees(location?.latitude ?? 0.0)
        langM = CLLocationDegrees(location?.longitude ?? 0.0)
        
        print("lat and long home \(latM) \(langM)")
        
        let mapInsets = UIEdgeInsets(top: 200.0, left: 30.0, bottom: 300.0, right: 10.0)
        mapview.padding = mapInsets
        
        if let nav_height = self.navigationController?.navigationBar.frame.height
        {
            let status_height = UIApplication.shared.statusBarFrame.size.height
            mapview.padding = UIEdgeInsets (top: nav_height+status_height,left: 0,bottom: 0,right: 0);
        }
        
        self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: latM, longitude: langM))
    }
    
//    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
//        if toLocation != nil {
//            currentLocationMarker?.map = nil
//            currentLocationMarker = nil
//            mapview.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 10.0)
//            if let location = locationManager.location {
//                currentLocationMarker = GMSMarker(position: location.coordinate)
//                currentLocationMarker?.icon = #imageLiteral(resourceName: "pinLogo")
//                currentLocationMarker?.map = mapview
//                currentLocationMarker?.rotation = locationManager.location?.course ?? 0
          //  }
     //  }
   // }

    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        
        
    }
    
}

class CustomMarker: GMSMarker {

    var label: UILabel!

    init(labelText: String) {
        super.init()

        let iconView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height:     12)))
        iconView.backgroundColor = .white

        label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width:     iconView.bounds.width, height: 12)))
        label.text = labelText
        iconView.addSubview(label)

        self.iconView = iconView
    }
}


//MARK: - Extension Draw Path
extension TackDistanceVCViewController{
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
       
        marker.map = mapview
        mapview.selectedMarker = marker
    }
    
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        print("\(startLocation.coordinate.latitude) &&&& \(startLocation.coordinate.longitude)")
        print("\(endLocation.coordinate.latitude) #### \(endLocation.coordinate.longitude)")
        let destinationLat = Double(startLocation.coordinate.latitude)
        let destinationLong = Double(startLocation.coordinate.longitude)
        print("\(destinationLat) \(destinationLong)")
        
        //////// commented code in 21- MAy i remove commented from 22 May
        let origin = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let destination = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        
        let manager = AFHTTPSessionManager()

       // manager.responseSerializer = AFJSONResponseSerializer(readingOptions: JSONSerialization.ReadingOptions.allowFragments) as AFJSONResponseSerializer

        manager.requestSerializer = AFJSONRequestSerializer()

       // manager.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav") as Set<NSObject>


        
        print("origin \(origin) destination \(destination)")
        var directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?&key=\(browserKey)"
        var directionsUrlString = "\(directionsAPI)&origin=\(origin)&destination=\(destination)&mode=driving"
        var directionsUrl = URL(string: directionsUrlString)
        print(directionsUrl)
        
        

        manager.post(directionsUrlString, parameters: nil, headers: nil,progress: nil , success: { (operation, response) in


            if(response != nil)
            {
                let parsedData = JSON(response!)

                print("parsedData12554 : \(parsedData)")

                  print("parsed : \(parsedData["status"])")

                if(parsedData["status"] == "OK")
                {

                    let routes = parsedData["routes"][0]

                    print("Routesss260 \(routes)")

                    let legs = routes["legs"][0]

                    let distance = legs["distance"]

                    let duration = legs["duration"]

                    let disValue = distance["value"].double!

                    let durValue = duration["value"].double! / 3600.0

                    print("disValue250 \(disValue)")

                    print("durValue250 \(durValue)")


                    if(durValue != 0.0)
                    {
                        // self.speed = disValue / durValue
                    }

                    for route in routes
                    {
                        let routeOverviewPolyline = routes["overview_polyline"].dictionary
                        let points = routeOverviewPolyline?["points"]?.stringValue
                        let path = GMSPath.init(fromEncodedPath: points!)
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeWidth = 2
                       // polyline.strokeColor =  UIColor(red: 214/255, green: 14/255, blue: 16/255, alpha: 1.0)
                        polyline.strokeColor = UIColor.blue
                        polyline.map = self.mapview
                    }
                }
            }
        }) { (operation, error) in
              print("eeee2566\(error)")
        }

        let LocationSource: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: startLocation.coordinate.latitude , longitude: startLocation.coordinate.longitude)
        
        let LocationDestination: CLLocationCoordinate2D  = CLLocationCoordinate2D(latitude: endLocation.coordinate.latitude , longitude:endLocation.coordinate.longitude )
        
        let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: LocationSource, coordinate: LocationDestination))
        mapview.moveCamera(cameraUpdate)
        let currentZoom = mapview.camera.zoom
        mapview.animate(toZoom: currentZoom - 1.4)
        
          let marker = GMSMarker()
          
          let position = CLLocationCoordinate2D(latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude)
          marker.position = position
         
          marker.iconView = addressWindow
          addressWindow.lblAddress.text = "Professional".localized()
          marker.map = mapview
        
        let markerDrop = GMSMarker()
         
         let positionDrop = CLLocationCoordinate2D(latitude: endLocation.coordinate.latitude, longitude: endLocation.coordinate.longitude)
         markerDrop.position = positionDrop
        
         markerDrop.iconView = addressWindowDrop
         addressWindowDrop.lblAddress.text = "Dropoff".localized()
         markerDrop.map = mapview
        
        
        
        print("destinationLat as! CLLocationDegrees",destinationLat)
    }
}
