//
//  ActiveOrderTrackingVC.swift
//  Joker
//
//  Created by Callsoft on 01/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import QuartzCore
import GooglePlaces
import SwiftyJSON
import SocketIO


class ActiveOrderTrackingVC: UIViewController {

    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var btnDoneRef: UIButton!
    @IBOutlet weak var btnArrivedRef: UIButton!
    @IBOutlet weak var btnPickUpRef: UIButton!
    @IBOutlet weak var btnStartRef: UIButton!
    
    @IBOutlet weak var lblStart: UILabel!
    
    @IBOutlet weak var lblPickup: UILabel!
    
    @IBOutlet weak var lblDropoff: UILabel!
    
    @IBOutlet weak var lblDelivered: UILabel!
    
    @IBOutlet weak var lblOrderId: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var lblStartToPickupLocation: UILabel!
    
    @IBOutlet weak var lblPickupToDropOffLocation: UILabel!
    
    @IBOutlet weak var lblDropOffToDeliveredLocation: UILabel!
    
    @IBOutlet weak var lblNav: UILabel!
    
    
    //MARK: - Variable
    var isComing = String()
    
    var dict = NSDictionary()
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    var locationMarker : GMSMarker? = GMSMarker()
    
    var locationManager : CLLocationManager = CLLocationManager()
    var AddressLat:Double = 0.0
    var AddressLong:Double = 0.0
    var initialLat:Double = Double()
    var initialLong:Double = Double()
    var strAddress = ""
    var count = 0
    
    let socketManager = SocketManager(socketURL: URL(string: "http://3.129.47.202:3000")!, config: ["log": true])
    
    var socket: SocketIOClient!
    
    let addressWindow = Bundle.main.loadNibNamed("Address", owner: self, options: nil)!.first! as! AddressWindow
    
    let destinationAddressWindow = Bundle.main.loadNibNamed("DestinationAddress", owner: self, options: nil)!.first! as! DestinationAddress
    
    let addressWindowNew = Bundle.main.loadNibNamed("DeliveryAddress", owner: self, options: nil)!.first! as! DeliveryAddress
    
    let pickupWindow = Bundle.main.loadNibNamed("DeliveryAddress", owner: self, options: nil)!.first! as! DeliveryAddress
    
    let dropoffWindow = Bundle.main.loadNibNamed("DeliveryAddress", owner: self, options: nil)!.first! as! DeliveryAddress
    
    var path = GMSMutablePath()
    
    let connection = webservices()
    
    var globalOrderId = ""
    var trackingDict = NSDictionary()
    
    var roomIdForTrack = ""
    
    var forFirstTime = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNav.text = "Active Order Tracking".localized()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        if #available(iOS 9.0, *) {
            
            locationManager.requestLocation()
            locationManager.requestWhenInUseAuthorization()
            self.locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
            
        } else {
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        configureMap()
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        
        self.lblOrderId.text = "Order ID".localized()+" : \(orderId)"
        
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        
        self.lblDateAndTime.text = self.fetchData(dateToConvert: createdDate)
        
        let userId = dict.object(forKey: "userId") as? String ?? ""
        let orderUniqueId = dict.object(forKey: "_id") as? String ?? ""
        
        self.roomIdForTrack = "\(userId)\(orderUniqueId)"
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isComing == "NormalDelivery"{
            
            let currentToPickupLocation = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
            let pickupToDropLocation = dict.object(forKey: "pickupToDropLocation") as? String ?? ""
            
            lblStartToPickupLocation.text = "\(currentToPickupLocation)KM"
            lblPickupToDropOffLocation.text = "\(pickupToDropLocation)KM"
            lblDropOffToDeliveredLocation.text = "0.0KM"
            
            self.normalUserDoingTrackForDeliveryNewEnhancement()
            
            self.socketHandling()
        }
        else if isComing == "NormalProfessional"{
            
            self.normalUserIsDoingTrackWithNewRequirement()
            
            lblPickup.text = "DropOff".localized()
            lblDropoff.text = "Professional Working".localized()
            
            //*** Measuring distance
            
            let currentToPickupLocation = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
            
            lblStartToPickupLocation.text = "\(currentToPickupLocation)KM"
            
            lblPickupToDropOffLocation.text = "0.0KM"
            lblDropOffToDeliveredLocation.text = "0.0KM"
            
            self.socketHandling()
        }
        else{
            
        }
        
    }
    
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendTime = self.dateFormatterForTime.string(from: pendingDate)
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        return "\(sendDate) \(sendTime)"
    }
    
    
    func socketHandling() {
        
        socket = socketManager.defaultSocket
        
        let socketConnectionStatus = socket.status
        
        switch socketConnectionStatus {
        case SocketIOStatus.connected:
            print("socket connected")
        case SocketIOStatus.connecting:
            print("socket connecting")
        case SocketIOStatus.disconnected:
            socket.connect()
            print("socket disconnected")
        case SocketIOStatus.notConnected:
            socket.connect()
            print("socket not connected")
        }
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            
            if self.forFirstTime{
                
                self.forFirstTime = false
                
                self.socket.emit("room join", ["roomId": self.roomIdForTrack])
                
                //self.socket.emit("room join", ["roomId": "5d1a0e06d8a6bc109d07e9665e0346c5aad9456e62935224"])
                
                self.apiCallForTrackWorker(roomId: self.roomIdForTrack)
            }
            
        }
        
        socket.on("room join") { (data, ack) in
            
            print("Room Joined")
            print(data)
            
        }
        
        socket.on("tracking") { (data, ack) in
            
            print("Coordinate receiving from server")
            print(data)
            
            let cordinateArr = data as NSArray
                
            if cordinateArr.count != 0{
                    
                let dict = cordinateArr.object(at: 0) as? NSDictionary ?? [:]
                    
                var lat = dict.object(forKey: "lattitude") as? String ?? ""
                var long = dict.object(forKey: "longitude") as? String ?? ""
                    
                if lat != "" && long != ""{
                        
                    lat = lat.trim()
                    long = long.trim()
                        
                    let latDouble = Double(lat)!
                    let longDouble = Double(long)!
                    
                    if self.isComing == "NormalProfessional"{
                        
                        self.putMarkerWindowForNormalProfessional(currentPoslat: latDouble, currentPosLong: longDouble)
                    }
                    else{
                        
                        self.putMarkerWindowForNormalDelivery(currentPoslat: latDouble, currentPosLong: longDouble)
                    }
                    
                }
            }
           
            
        }
        
        
    }
    
    
    
    @IBAction func tap_goBtn(_ sender: Any) {
        
        if isComing == "NormalProfessional"{
            
            let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
            if invoiceStatus == "false"{
                
                
            }
            else{
                
                let invoicePdfUrl = dict.object(forKey: "invoicePdf") as? String ?? ""
                
                guard let url = URL(string: "\(invoicePdfUrl)") else {
                    return //be safe
                }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                
            }
            
        }
        else if self.isComing == "NormalDelivery"{
            
            //normal user can view invoice created by delivery person.
            
            let invoiceStatus = trackingDict.object(forKey: "invoiceStatus") as? String ?? ""
            if invoiceStatus == "false"{
                
            }
            else{
                
                //review invoice url get here
                
                let invoicePdfUrl = trackingDict.object(forKey: "invoicePdf") as? String ?? ""
                
                guard let url = URL(string: "\(invoicePdfUrl)") else {
                    return //be safe
                }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                
            }
            
        }
        else{
            
            
        }
        
    }
    
    @IBAction func tap_createInvoiceBtn(_ sender: Any) {
        
        if isComing == "NormalDelivery"{
            
            
        }
        else if isComing == "NormalProfessional"{
            
            
        }
       
        else{
            
          
        }
    }
    
    @IBAction func tap_arrivedBtn(_ sender: Any) {
        
     
    }
    
    
    
    @IBAction func tap_doneBtn(_ sender: Any) {
        
        
    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}



//MARK:- UI Setup
//MARK:-
extension ActiveOrderTrackingVC{
    
    func normalUserIsDoingTrackWithNewRequirement(){
        
        btnStartRef.setTitle("Start".localized(), for: .normal)
        btnPickUpRef.setTitle("Invoice Created".localized(), for: .normal)
        btnArrivedRef.setTitle("Arrived".localized(), for: .normal)
        btnDoneRef.setTitle("Done".localized(), for: .normal)
        
        btnPickUpRef.setTitleColor(UIColor.green, for: .normal)
        btnArrivedRef.setTitleColor(UIColor.green, for: .normal)
        btnDoneRef.setTitleColor(UIColor.green, for: .normal)
        
        btnPickUpRef.backgroundColor = UIColor.clear
        btnArrivedRef.backgroundColor = UIColor.clear
        btnDoneRef.backgroundColor = UIColor.clear
        
        
        let goStatus = trackingDict.object(forKey: "goStatus") as? String ?? ""
        if goStatus == "false"{
            
            btnStartRef.isHidden = true
            btnArrivedRef.isHidden = true
            btnPickUpRef.isHidden = true
            btnDoneRef.isHidden = true
            
        }
        else{
            
            let arrivedStatus = trackingDict.object(forKey: "arrivedStatus") as? String ?? ""
            
            if arrivedStatus == "false"{
                
                btnStartRef.isHidden = false
                btnArrivedRef.isHidden = true
                btnPickUpRef.isHidden = true
                btnDoneRef.isHidden = true
                
                btnStartRef.setTitle("Start", for: .normal)
                btnStartRef.setTitleColor(UIColor.green, for: .normal)
                
            }
            else{
                
                let invoiceStatus = trackingDict.object(forKey: "invoiceStatus") as? String ?? ""
                if invoiceStatus == "false"{
                    
                    btnStartRef.isHidden = true
                    btnArrivedRef.isHidden = false
                    btnPickUpRef.isHidden = true
                    btnDoneRef.isHidden = true
                    
                    btnArrivedRef.backgroundColor = UIColor.clear
                    btnArrivedRef.setTitleColor(UIColor.green, for: .normal)
                    btnArrivedRef.setTitle("Arrived".localized(), for: .normal)
                    
                }
                else{
                    
                    btnStartRef.isHidden = false
                    btnArrivedRef.isHidden = false
                    btnPickUpRef.isHidden = false
                    btnDoneRef.isHidden = true
                    
                    btnStartRef.setTitle("Review Invoice".localized(), for: .normal)
                    btnStartRef.setTitleColor(UIColor.purple, for: .normal)
                    btnArrivedRef.backgroundColor = UIColor.clear
                    btnArrivedRef.setTitleColor(UIColor.green, for: .normal)
                    btnArrivedRef.setTitle("Arrived".localized(), for: .normal)
                    
                }
                
            }
            
        }
        
    }
    
    
    func normalUserDoingTrackForDeliveryNewEnhancement(){
        
        btnStartRef.setTitle("Start".localized(), for: .normal)
        btnArrivedRef.setTitle("Invoice Created".localized(), for: .normal)
        btnPickUpRef.setTitle("Arrived".localized(), for: .normal)
        btnDoneRef.setTitle("Done".localized(), for: .normal)
        
        btnPickUpRef.setTitleColor(UIColor.green, for: .normal)
        btnArrivedRef.setTitleColor(UIColor.green, for: .normal)
        btnDoneRef.setTitleColor(UIColor.green, for: .normal)
        
        btnPickUpRef.backgroundColor = UIColor.clear
        btnArrivedRef.backgroundColor = UIColor.clear
        btnDoneRef.backgroundColor = UIColor.clear
        
        let goStatus = dict.object(forKey: "goStatus") as? String ?? ""
        if goStatus == "false"{
            
            btnStartRef.isHidden = true
            btnArrivedRef.isHidden = true
            btnPickUpRef.isHidden = true
            btnDoneRef.isHidden = true
            
        }
        else{
            
            let arrivedStatus = dict.object(forKey: "arrivedStatus") as? String ?? ""
            let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
            
            if arrivedStatus == "false" && invoiceStatus == "false"{
                
                btnStartRef.isHidden = false
                btnArrivedRef.isHidden = true
                btnPickUpRef.isHidden = true
                btnDoneRef.isHidden = true
                
                btnStartRef.setTitle("Start".localized(), for: .normal)
                btnStartRef.setTitleColor(UIColor.green, for: .normal)
            }
            else if arrivedStatus == "true" && invoiceStatus == "true"{
                
                btnStartRef.isHidden = false
                btnArrivedRef.isHidden = false
                btnPickUpRef.isHidden = false
                btnDoneRef.isHidden = true
                
                btnStartRef.setTitle("Review Invoice".localized(), for: .normal)
                btnStartRef.setTitleColor(UIColor.purple, for: .normal)
                
                btnArrivedRef.setTitle("Invoice Created".localized(), for: .normal)
                btnArrivedRef.backgroundColor = UIColor.clear
                btnArrivedRef.setTitleColor(UIColor.green, for: .normal)
                
                btnPickUpRef.setTitle("Arrived".localized(), for: .normal)
                btnPickUpRef.backgroundColor = UIColor.clear
                btnPickUpRef.setTitleColor(UIColor.green, for: .normal)
                
            }
            else if arrivedStatus == "true" && invoiceStatus == "false"{
                
                btnStartRef.isHidden = true
                btnPickUpRef.isHidden = false
                btnArrivedRef.isHidden = true
                btnDoneRef.isHidden = true
                
                btnPickUpRef.setTitle("Arrived".localized(), for: .normal)
                btnPickUpRef.backgroundColor = UIColor.clear
                btnPickUpRef.setTitleColor(UIColor.green, for: .normal)
                
            }
            else if arrivedStatus == "false" && invoiceStatus == "true"{
                
                btnStartRef.isHidden = false
                btnArrivedRef.isHidden = false
                btnPickUpRef.isHidden = true
                btnDoneRef.isHidden = true
                
                btnStartRef.setTitle("Review Invoice".localized(), for: .normal)
                btnStartRef.setTitleColor(UIColor.purple, for: .normal)
                btnArrivedRef.setTitle("Invoice Created".localized(), for: .normal)
                btnArrivedRef.backgroundColor = UIColor.clear
                btnArrivedRef.setTitleColor(UIColor.green, for: .normal)
            }
            
        }
        
    }
 
}


//MARK:- Custom Method
//MARK:-
extension ActiveOrderTrackingVC{
    
    func drawRouteForLocation(pickupLat:String,pickupLong:String,DropLat:String,DropLong:String,pickupAdress:String,dropAddress:String){
        
        if pickupLat != "" && pickupLong != "" && DropLat != "" && DropLong != ""{
            
            let pickLat = pickupLat.trim()
            let pickLong = pickupLong.trim()
            let dropLati = DropLat.trim()
            let dropLongi = DropLong.trim()
            
            self.mapview.clear()
            
            //doing place marker on start and end points on map
            
            for i in 0..<2{
                
                let marker = GMSMarker()
                var position = CLLocationCoordinate2D()
                
                if i == 0{
                    
                    position =  CLLocationCoordinate2D(latitude: Double(pickLat) ?? 0.0, longitude: Double(pickLong) ?? 0.0)
                    
                    marker.iconView = self.addressWindow
                    self.addressWindow.lblAddress.text = pickupAdress
                    
                    self.mapview.animate(toLocation: position)
                    
                }
                else{
                    
                    position = CLLocationCoordinate2D(latitude: Double(dropLati) ?? 0.0, longitude: Double(dropLongi) ?? 0.0)
                    
                    marker.iconView = self.destinationAddressWindow
                    self.destinationAddressWindow.lblAddress.text = dropAddress
                }
                
                marker.position = position
                marker.map = self.mapview
                
            }
            
            self.drawRoute(pickupLat: pickLat, pickupLong: pickLong, dropLat: dropLati, dropLong: dropLongi)
            
        }
        
    }
    
    
    
    func drawRoute(pickupLat:String,pickupLong:String,dropLat:String,dropLong:String) {
        
        //self.stopAnimating()
        
        let origin = "\(pickupLat),\(pickupLong)"
        let destination = "\((dropLat)),\((dropLong))"
        
        let key = "AIzaSyDOkmpLY8YyUA6v86lScjFiGk91qSH1DZg"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(key)"
        print(url)
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = URL(string: String(format: "%@", url))
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard error == nil else {
                
                print("error calling POST on HitServices is\(String(describing: error))")
                
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            //  let jsonResponse = JSON(data: responseData)
            
            var jsonResponse = JSON()
            
            do {
                
                jsonResponse = try JSON(data: responseData)
                
            } catch _ {
                // jsonResponse = nil
            }
            
            
            let routes = jsonResponse["routes"].arrayValue
            
            print(routes.count)
            if routes.count > 0{
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    self.showPath(pnts: points!)
                }
                
            }else{
                
            }
        }
        task.resume()
        
    }
    
    
    func showPath(pnts:String) {
        
        DispatchQueue.main.async {
            
            self.path = GMSMutablePath.init(fromEncodedPath: pnts)!
            let polyline = GMSPolyline(path: self.path)
            polyline.strokeColor = UIColor(red:0.28, green:0.56, blue:0.89, alpha:1.0)
            polyline.map = self.mapview
            polyline.strokeWidth = 4.0
            //self.view = self.mapView
            
            polyline.map?.isTrafficEnabled = true
            
            self.mapview.isMyLocationEnabled = true
            var bounds = GMSCoordinateBounds()
            
            for index in 1...self.path.count() {
                
                bounds = bounds.includingCoordinate(self.path.coordinate(at: index))
            }
            self.mapview.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 0))
            
        }
        
    }
 
}



extension ActiveOrderTrackingVC:GMSMapViewDelegate{
    
    func configureMap(){
        
        mapview.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom: 12.0)//:::
        
        mapview.camera = camera
        
        if self.isComing == "NormalDelivery"{
            
            putMarkerWindowForNormalDelivery(currentPoslat: 0.0, currentPosLong: 0.0)
        }
        else if self.isComing == "NormalProfessional"{
            
            putMarkerWindowForNormalProfessional(currentPoslat: 0.0, currentPosLong: 0.0)
            
        }
        
    }
    
    
    func putMarkerWindowForNormalDelivery(currentPoslat:Double,currentPosLong:Double){
        
        let pickupLat = dict.object(forKey: "pickupLat") as? Double ?? 00
        let pickupLong = dict.object(forKey: "pickupLong") as? Double ?? 00
        let pickupAddress = dict.object(forKey: "pickupLocation") as? String ?? ""
        
        let dropLat = dict.object(forKey: "dropOffLat") as? Double ?? 00
        let dropLong = dict.object(forKey: "dropOffLong") as? Double ?? 00
        let dropAddress = dict.object(forKey: "dropOffLocation") as? String ?? ""
        
        let pickupMarker = GMSMarker()
        let dropoffMarker = GMSMarker()
        
        let pickupPosition = CLLocationCoordinate2D(latitude: Double(pickupLat), longitude: Double(pickupLong))
        pickupMarker.position = pickupPosition
        
        pickupWindow.lblAddress.text = pickupAddress
        pickupWindow.lblAddressType.text = "Pickup".localized()
        
        pickupWindow.viewAddressType.backgroundColor = UIColor(red:0.99, green:0.69, blue:0.24, alpha:1.0)
        pickupWindow.imgMarker.image = UIImage(named: "pickupOrange")
        
        pickupMarker.iconView = pickupWindow
        pickupMarker.map = mapview
        
        let dropPosition = CLLocationCoordinate2D(latitude: Double(dropLat), longitude: Double(dropLong))
        dropoffMarker.position = dropPosition
        dropoffWindow.lblAddressType.text = "DropOff".localized()
        dropoffWindow.lblAddress.text = dropAddress
        
        dropoffWindow.viewAddressType.backgroundColor = UIColor(red:0.24, green:0.62, blue:0.14, alpha:1.0)
        dropoffWindow.imgMarker.image = UIImage(named: "dropoffGreen")
        
        dropoffMarker.iconView = dropoffWindow
        dropoffMarker.map = mapview
        
        
        if currentPoslat != 0.0 && currentPosLong != 0.0{
            
            //Draw current location of professional Worker here and draw a route.
            
            let marker = GMSMarker()
            
            let position = CLLocationCoordinate2D(latitude: Double(currentPoslat), longitude: Double(currentPosLong))
            marker.position = position
            
            addressWindowNew.lblAddressType.text = "Delivery".localized()
            
            addressWindowNew.lblAddress.text = self.reverseGeocodeCoordinateForProfessionalAddress(inLat: currentPoslat, inLong: currentPosLong)
            
            marker.iconView = addressWindowNew
            
            marker.map = mapview
            
            self.drawRoute(pickupLat: "\(currentPoslat)", pickupLong: "\(currentPosLong)", dropLat: "\(dropLat)", dropLong: "\(dropLong)")
            
        }
        
    }
    
    
    
    func putMarkerWindowForNormalProfessional(currentPoslat:Double,currentPosLong:Double){
        
        self.mapview.clear()
        
        let pickupLat = dict.object(forKey: "pickupLat") as? Double ?? 0.0
        let pickupLong = dict.object(forKey: "pickupLong") as? Double ?? 0.0
        let pickupLocation = dict.object(forKey: "pickupLocation") as? String ?? ""
        
        //* here pickup lat and long will use as a drop address bcz it is the service location..****//
        
       // let camera = GMSCameraPosition.camera(withLatitude: pickupLat, longitude: pickupLong, zoom: 12.0)//:::
        
       // mapview.camera = camera
        
        let dropoffMarker = GMSMarker()
        
        let dropPosition = CLLocationCoordinate2D(latitude: Double(pickupLat), longitude: Double(pickupLong))
        dropoffMarker.position = dropPosition
        
        dropoffWindow.lblAddressType.text = "DropOff".localized()
        dropoffWindow.viewAddressType.backgroundColor = UIColor(red:0.24, green:0.62, blue:0.14, alpha:1.0)
        dropoffWindow.imgMarker.image = UIImage(named: "dropoffGreen")
        dropoffWindow.lblAddress.text = pickupLocation
        
        dropoffMarker.iconView = dropoffWindow
        dropoffMarker.map = mapview
        
        if currentPoslat != 0.0 && currentPosLong != 0.0{
            
            //Draw current location of professional Worker here and draw a route.
            
            let marker = GMSMarker()
            
            let position = CLLocationCoordinate2D(latitude: Double(currentPoslat), longitude: Double(currentPosLong))
            marker.position = position
            
            addressWindowNew.lblAddressType.text = "Professional".localized()
            
            addressWindowNew.lblAddress.text = self.reverseGeocodeCoordinateForProfessionalAddress(inLat: currentPoslat, inLong: currentPosLong)
            
            marker.iconView = addressWindowNew
            
            marker.map = mapview
            
            self.drawRoute(pickupLat: "\(currentPoslat)", pickupLong: "\(currentPosLong)", dropLat: "\(pickupLat)", dropLong: "\(pickupLong)")
            
        }
        else{
            
            
        }
        
        
    }
    
    
    
    func makeAddressString(inArr:[String]) -> String {
        
        var fVal:String = ""
        for val in inArr {
            
            fVal =  fVal + val + " "
            
        }
        return fVal
        
    }
    
    
    func reverseGeocodeCoordinate(inLat:Double, inLong:Double) {
        
        let cordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: inLat, longitude: inLong)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(cordinate) { response, error in
            
            if let address = response?.results() {
                
                let lines = address.first
                
                if let addressNew = lines?.lines {
                    
                    self.strAddress = self.makeAddressString(inArr: addressNew)
                    
                    //self.configureMap()
                    
                }
            }
        }
    }
    
    
    func reverseGeocodeCoordinateForProfessionalAddress(inLat:Double, inLong:Double)-> String {
        
        let cordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: inLat, longitude: inLong)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(cordinate) { response, error in
            
            if let address = response?.results() {
                
                let lines = address.first
                
                if let addressNew = lines?.lines {
                    
                    self.strAddress = self.makeAddressString(inArr: addressNew)
                    
                }
            }
        }
        
        return self.strAddress
    }
    
    
}



//MARK:- Location manager delegate
//MARK:-
extension ActiveOrderTrackingVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation:CLLocation = locations.first!
            manager.stopUpdatingLocation()
            
            self.AddressLat = currentLocation.coordinate.latitude
            self.AddressLong = currentLocation.coordinate.longitude
            
            self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
            
           // configureMap()
            
            if count == 0{
                
                self.initialLat = self.AddressLat
                self.initialLong = self.AddressLong
                
                self.count = self.count + 1
                
                    
                self.reverseGeocodeCoordinate(inLat: self.AddressLat, inLong: self.AddressLong)
                
                
            }
            
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



extension ActiveOrderTrackingVC{
    
    func apiCallForTrackWorker(roomId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["roomId":roomId]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetTrackingCordinateOfCaptain as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                     
                        if let dataDict = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            var latCordinate = dataDict.object(forKey: "latitude") as? String ?? ""
                            var longCordinate = dataDict.object(forKey: "longitude") as? String ?? ""
                            
                            latCordinate = latCordinate.trim()
                            longCordinate = longCordinate.trim()
                            
                            let latiInDouble = Double(latCordinate) ?? 0.0
                            let longiInDouble = Double(longCordinate) ?? 0.0
                            
                            if self.isComing == "NormalDelivery"{
                                
                                self.putMarkerWindowForNormalDelivery(currentPoslat: latiInDouble, currentPosLong: longiInDouble)
                            }
                            else{
                                
                                self.putMarkerWindowForNormalProfessional(currentPoslat: latiInDouble, currentPosLong: longiInDouble)
                            }
                            
                        }
                    }
                    else{
                        
                       
                    }
                }
                else{
                    
                 
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
}




