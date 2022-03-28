//
//  AddressPickerVC.swift
//  Joker
//
//  Created by Dacall soft on 04/04/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol GetAddressFromMapDelegate {
    func getAddress(address:String,lat:String,long:String)
}

class AddressPickerVC: UIViewController,GMSAutocompleteViewControllerDelegate {

    
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var searchHolderView: UIView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var txtBuildingApartmentNo: UITextField!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var lblNewAddressLocation: UILabel!
    
    @IBOutlet weak var btnSetLocation: UIButton!
    
    
    var locationManager : CLLocationManager = CLLocationManager()
    var strAddress:String? = ""
    var AddressLat:Double = 0
    var AddressLong:Double = 0
    var gmsPlace:GMSPlace?
    var arrPlaces = NSMutableArray(capacity: 100)
    
    var arrPlacesIDs = NSMutableArray(capacity: 100)
    
    var controllerName = ""
    
    var didNotPickAnything = true
    var selectedViaTable = false
    var selectedViaDrag = false
    
    var addressDictForEdit = NSDictionary()
    
    var selectionOnMapRotation = true

    var circle = GMSCircle()
    
    var iscomingFirstTime = true
    var isComing = Bool()
    
    var globalCountryName = "IN"
    
    var addressDelegate: GetAddressFromMapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        lblLocation.text = "New Address location".localized()
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            
            print(countryCode)
            self.globalCountryName = countryCode
        }
        
        searchbar.placeholder = "Search".localized()
        
        searchbar.backgroundImage = UIImage()
        
        searchHolderView.layer.cornerRadius = 22.5
        
        tableview.isHidden = true
        
        self.searchbar.delegate = self
        mapview.delegate = self
        
        if controllerName == ""{
            
            locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            
        }
        else if controllerName == "SaveAddress"{
            
            //saving pickup and drop address on this controller
            
//            self.searchbar.text = self.strAddress
//
//            self.lblLocation.text = self.strAddress
//
//            print(self.strAddress!)
//            self.configureMap()
//
//            self.dropMapPin()
            
            locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            
        }
        else{
            
            self.strAddress = addressDictForEdit.object(forKey: "address") as? String ?? ""
            
            self.txtBuildingApartmentNo.text = addressDictForEdit.object(forKey: "buildingAndApart") as? String ?? ""
            
            self.searchbar.text = self.strAddress

            self.lblLocation.text = self.strAddress
            
            self.AddressLat = addressDictForEdit.object(forKey: "lat") as? Double ?? 0.0
            self.AddressLong = addressDictForEdit.object(forKey: "long") as? Double ?? 0.0
            
            let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom: 17.0)
            mapview.camera = camera
            
            self.dropMapPin()
        }
    
        
        for subView in searchbar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    textField.layer.cornerRadius = 0.0
                    textField.backgroundColor = UIColor.clear
                    textField.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)
                }
                
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        lblNav.text = "Choose your location".localized()
        btnSetLocation.setTitle("Set Location".localized(), for: .normal)
        txtBuildingApartmentNo.placeholder = "Building/Apartment No. (Optional)".localized()
    }
    
    
    @IBAction func tap_crossBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_setLocationBtn(_ sender: Any) {
        
        print(self.AddressLat)
        print(self.AddressLong)
        
        if isComing{
            self.addressDelegate?.getAddress(address: self.lblLocation.text!,lat: self.AddressLat.description,long: self.AddressLong.description)
            GloblaLat = self.AddressLat.description
            GloblaLong = self.AddressLong.description
            self.navigationController?.popViewController(animated: false)
            return
        }
        
        if didNotPickAnything == true && selectedViaTable == false && selectedViaDrag == false{

            self.sendToLandmarkVC()
            
            print("Picked Via Location")
            
        }
        else if selectedViaTable == true{
            
              self.sendToLandmarkVC()
            
              print("Picked Via Tableview")
            
        }
        else if selectedViaDrag == true{
            
            self.sendToLandmarkVC()
            
            print("Picked Via Drag")
            
        }
        else{
            
            if searchbar.text == ""{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please fill your address.", controller: self)
            }
            else{
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select the valid address via suggestion address or drop the pin anywhere on map.", controller: self)
            }
        }
    }
    
    
    func sendToLandmarkVC(){
        
        let vc = ScreenManager.getLandmarkPopupVC()
        
        vc.delegate = self
        
        vc.addressStr = self.lblLocation.text!
        
        vc.buildingAndApartmentStr = self.txtBuildingApartmentNo.text!
        
        vc.latCordinate = self.AddressLat
        vc.longCordinate = self.AddressLong
        
        if controllerName == "Edit"{
            
            vc.editableAddressId = addressDictForEdit.object(forKey: "_id") as? String ?? ""
            
            vc.controllerPurpuse = "Edit"
            vc.landmarkTitle = addressDictForEdit.object(forKey: "landmark") as? String ?? ""
            
        }
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
}


extension AddressPickerVC:PopToMapDelegate{
    
    func redirectionStatus(status: String) {
        
        if status == "Yes"{
            
            self.navigationController?.popViewController(animated: true)
        }
    }

}



//MARK:- Custom Method
//MARK:-
extension AddressPickerVC:GMSMapViewDelegate{
    
    func configureMap(){
        
        let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom: 17.0)
        mapview.camera = camera
        locationManager.delegate = self
        mapview.isMyLocationEnabled = true
        
    }
    
    func dropMapPin(){
        
//        self.mapview.clear()
//        let marker = GMSMarker()
//        marker.icon = UIImage(named:"dropFilledImg")
//        marker.position = CLLocationCoordinate2D(latitude: Double(AddressLat), longitude: Double(AddressLong))
//
//        marker.isDraggable = true
//
//        marker.map = self.mapview
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if iscomingFirstTime == true{
            
            iscomingFirstTime = false
        }
        else{
            
            if selectionOnMapRotation == true{
                
                selectedViaDrag = true
                
                self.AddressLat = position.target.latitude
                self.AddressLong = position.target.longitude
                GloblaLat = position.target.latitude.description
                GloblaLong = position.target.longitude.description
                //reverseGeocodeCoordinate(inLat: position.target.latitude, inLong: position.target.longitude)
                
                similarReverseGeocodeCoordinate(inLat: position.target.latitude, inLong: position.target.longitude)
                
            }
            
            selectionOnMapRotation = true
            
        }
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        self.mapview.clear()
        print("marker dragged to location: \(marker.position.latitude),\(marker.position.longitude)")
        
        self.AddressLat = marker.position.latitude
        self.AddressLong = marker.position.longitude
        GloblaLat = marker.position.latitude.description
        GloblaLong = marker.position.longitude.description
        selectedViaDrag = true
        selectedViaTable = false
        
        self.reverseGeocodeCoordinate(inLat: AddressLat, inLong: AddressLong)
    }
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
        print("Begin Dragging")
        
    }
    
    
    func reverseGeocodeCoordinate(inLat:Double, inLong:Double) {
        
        let cordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: inLat, longitude: inLong)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(cordinate) { response, error in
            
            if let address = response?.results() {
                
                let lines = address.first
                
                if let addressNew = lines?.lines {
                    
                    self.strAddress = self.makeAddressString(inArr: addressNew)
                    self.searchbar.text = self.strAddress
                    
                    self.lblLocation.text = self.strAddress
                    
                    print(self.strAddress!)
                    self.configureMap()
                  
                    self.dropMapPin()
                   
                }
            }
        }
    }
    
    
    func similarReverseGeocodeCoordinate(inLat:Double, inLong:Double) {
        
        let cordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: inLat, longitude: inLong)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(cordinate) { response, error in
            
            if let address = response?.results() {
                
                let lines = address.first
                
                if let addressNew = lines?.lines {
                    
                    self.strAddress = self.makeAddressString(inArr: addressNew)
                    self.searchbar.text = self.strAddress
                    
                    self.lblLocation.text = self.strAddress
                   
                    self.dropMapPin()
                    
                }
            }
        }
    }
    
    
    func makeAddressString(inArr:[String]) -> String {
        
        var fVal:String = ""
        for val in inArr {
            
            fVal =  fVal + val + " "
            
        }
        return fVal
        
    }
    
    
}



extension AddressPickerVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation:CLLocation = locations.first!
            manager.stopUpdatingLocation()
            
            let lat:Double = currentLocation.coordinate.latitude
            let long:Double = currentLocation.coordinate.longitude
            
            self.AddressLat = currentLocation.coordinate.latitude
            self.AddressLong = currentLocation.coordinate.longitude
            
            GloblaLat = currentLocation.coordinate.latitude.description
            GloblaLong = currentLocation.coordinate.longitude.description
            
            self.reverseGeocodeCoordinate(inLat: lat, inLong: long)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        NSLog("error = %@", error.localizedDescription)
        
    }
    
    func locationAuthorizationStatus(status:CLAuthorizationStatus)
    {
        switch status
        {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location AuthorizedWhenInUse/AuthorizedAlways")
            self.mapview.isMyLocationEnabled = true
            
            self.locationManager.startUpdatingLocation()
            if CLLocationManager.headingAvailable() {
                self.locationManager.headingFilter = 100
            }
            
        case .denied, .notDetermined, .restricted:
            print("Location Denied/NotDetermined/Restricted")
            self.mapview.isMyLocationEnabled = false
            self.locationManager.stopUpdatingLocation()
            
        }
        
        func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
        {
        }
        
        func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
        {
        }
        
        func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion)
        {
            print("Now monitoring :  \(manager.location?.coordinate) for \(region.identifier) radius: \(region.identifier)")
        }
        
        func locationManager(_ manager: CLLocationManager,
                             monitoringDidFailFor region: CLRegion?, withError error: Error)
        {
            print("monitoringDidFailForRegion \(region!.identifier) \(error.localizedDescription) \(error.localizedDescription)")
        }
        
        func locationManager(_ manager: CLLocationManager,
                             didDetermineState state: CLRegionState, for region: CLRegion)
        {
            var stateName = ""
            switch state {
            case .inside:
                stateName = "Inside"
            case .outside:
                stateName = "Outside"
            case .unknown:
                stateName = "Unknown"
            }
            print("didDetermineState \(stateName) \(region.identifier)")
            
        }
    }
}



//MARK:- SearchBar delegate
//MARK:-
extension AddressPickerVC:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("call in text did change.......")
        self.didNotPickAnything = false
        self.selectedViaDrag = false
        
        if searchBar.text == ""{
            
            self.tableview.isHidden = true
        }
        
        let filter = GMSAutocompleteFilter()
       //filter.type = GMSPlacesAutocompleteTypeFilter.geocode
        
       filter.type = GMSPlacesAutocompleteTypeFilter.establishment
        filter.country = "IN"

//        if self.globalCountryName != ""{
//            
//            filter.country = self.globalCountryName
//        }
//        
        let placesClient = GMSPlacesClient()
        
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter, callback: { (result, error) -> Void in
           //print("error...........\(error)")
            self.arrPlaces.removeAllObjects()
            
            self.arrPlacesIDs.removeAllObjects()
            
            self.tableview.isHidden = true
            
            guard result != nil else {
                return
            }
            
            for item in result! {
                
                if let res: GMSAutocompletePrediction? = item {
                    
                   // print("Result.........\(res)")
                    
                   // print("Result \(res!.attributedFullText.string) with placeID \(res!.placeID)")
                    self.arrPlaces.add(res?.attributedFullText.string)
                    
                    self.arrPlacesIDs.add(res?.placeID)
                    
                }
            }
            
            if self.arrPlaces.count != 0{
                
                self.tableview.isHidden = false
            }
            
            if self.arrPlaces.count < 1 {
                
                self.tableview.isHidden = true
            }
            
            self.tableview.reloadData()
            
        })
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom:17.0)
        self.mapview.animate(to: camera)
        searchbar.resignFirstResponder()
        self.dropMapPin()
    }
    
}


extension AddressPickerVC{
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress as Any)
        print("Place attributions: ", place.attributions as Any)
        print("address coardinate",place.coordinate)
        
        gmsPlace = place
        
        guard place.formattedAddress != nil else {
            return
        }
        
        self.searchbar.text = place.formattedAddress!
        self.strAddress = place.formattedAddress!
        
        self.lblLocation.text = place.formattedAddress!
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func viewController(viewController: GMSAutocompleteViewController!, didAutocompleteWithError error: NSError!) {
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        
    }
    
    func geoCode(str1:String) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(str1, completionHandler: {(placemarks, error) -> Void in
            
            if((error) != nil){
                print("Error", error!)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.AddressLat = coordinates.latitude
                self.AddressLong = coordinates.longitude
                
                print(self.AddressLat)
                print(self.AddressLong)
                
                // self.configureMap()
                
                let camera = GMSCameraPosition.camera(withLatitude: self.AddressLat, longitude: self.AddressLong, zoom: 17.0)
                self.mapview.camera = camera
                
                self.tableview.isHidden = true
              
                self.dropMapPin()
               
            }
        })
    }
}



//MARK:- TableView DataSource and Delegate
//MARK:-
extension AddressPickerVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AddressPickerTableViewCell
        
        cell.lblAddress.text = arrPlaces[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedViaTable = true
        self.selectedViaDrag = false
        
        self.selectionOnMapRotation = false
        
        self.searchbar.text = arrPlaces[indexPath.row] as? String
        
        self.lblLocation.text = arrPlaces[indexPath.row] as? String
        
        /////************
        
        let id = self.arrPlacesIDs[indexPath.row] as? String ?? ""
        let placeID = id
        let placesClient = GMSPlacesClient()
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            
            if let error = error {
                
                self.tableview.isHidden = true
                
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                
                self.tableview.isHidden = true
                
                print("No place details for \(placeID)")
                return
            }
            
            self.AddressLat  = place.coordinate.latitude
            self.AddressLong = place.coordinate.longitude
            print("Place name \(place.name)")
            
            let camera = GMSCameraPosition.camera(withLatitude: self.AddressLat, longitude: self.AddressLong, zoom: 17.0)
            self.mapview.camera = camera
            
            self.tableview.isHidden = true
          
            self.dropMapPin()
            
            //
            
        })
        
        //***************
        
        //   geoCode(str1: (arrPlaces[indexPath.row] as? String)!)
        self.tableview.isHidden = true
        self.searchHolderView.layer.cornerRadius = 22.5
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
}
