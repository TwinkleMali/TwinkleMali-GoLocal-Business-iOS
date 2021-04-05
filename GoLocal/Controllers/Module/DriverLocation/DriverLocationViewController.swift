//
//  DriverLocationViewController.swift
//  GoLocal
//
//  Created by C100-104 on 03/03/21.
//

import UIKit
import GoogleMaps
import KRProgressHUD
class DriverLocationViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewDriverDetails: CardView!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverTripDetails: UILabel!

    var driverDetails : Drivers? = nil
    var orderId = 0
    var driverId : Int {
        get{
            driverDetails?.id ?? 0
        }
    }
    var oldLocation : CLLocationCoordinate2D?
    var newLocation : CLLocationCoordinate2D?
    var driverLat = ""
    var driverLong = ""
    var shopLat = ""
    var shopLong = ""
    var deliveryLatitude = ""
    var deliveryLongitude = ""
    var deliveryLatitude2 = ""
    var deliveryLongitude2 = ""
    var isPathDrawwn : Bool = false
    // Map Variables
    var isMergedOrder = false
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var orderNotPickedUp = false
    var zoomLevel: Float = 15.0
    var driverMarker = GMSMarker()
    var shopMarker = GMSMarker()
    var deliveryMarker = GMSMarker()
    var deliveryMarker2 = GMSMarker()
    var tmproutedist = ""
    var tmproutetime = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    @IBAction func actionBack(_ sender: Any) {
        
        self.back(withAnimation: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        let d = ["driver_id" : driverId] as [String : Any]
        APP_DELEGATE?.socketIOHandler?.StartDriverLocationUpdate(dic: d)
    }
    override func viewDidDisappear(_ animated: Bool) {
        let d = ["driver_id" : driverId] as [String : Any]
        APP_DELEGATE?.socketIOHandler?.StopDriverLocationUpdate(dic: d)
    }
    
    //MARK:- Functions
    func setUpView(){
        self.lblDriverName.text = ((self.driverDetails?.name ?? "").capitalizingFirstLetter() + " " + (self.driverDetails?.lname ??  "").capitalizingFirstLetter())
        let routeDistance = distance(lat1: Double(deliveryLatitude) ?? 0, lon1: Double(deliveryLongitude) ?? 0, lat2: Double(driverLat) ?? 0, lon2: Double(driverLong) ?? 0)
        lblDriverTripDetails.text = "Running Trip : \(tmproutetime)(\(routeDistance))"
        nc.addObserver(self, selector: #selector(handleUpdateDriverLocation(notification:)), name: Notification.Name(notificationCenterKeys.updateDriverLocation.rawValue), object: nil)
        newLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(driverLat) ?? 0)!, longitude: CLLocationDegrees(exactly: Double(driverLong) ?? 0)!)
        oldLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(driverLat) ?? 0)!, longitude: CLLocationDegrees(exactly: Double(driverLong) ?? 0)!)
        self.locationManager.delegate = self
       self.locationManager.startUpdatingLocation()
       self.locationManager.requestWhenInUseAuthorization()
        KRProgressHUD.show()
        setUpMarker()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
            
             self.drawRouteOnMap(lat: self.driverLat, long: self.driverLong)
        })
    }
    
    
    //MARK:- Handle PostNotification
     @objc func handleUpdateDriverLocation(notification:Notification){
         if let d = notification.userInfo
         {
             if d["driver_id"] as? Int == driverId {
                 if let latitude = d["latitude"] as? String, let longitude = d["longitude"] as? String
                 {
                     print("Current latitude :: ",latitude)
                     print("Current longitude :: ",longitude)
                     let pos = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(latitude) ?? 0)!, longitude: CLLocationDegrees(exactly: Double(longitude) ?? 0)!)
                     if newLocation != nil
                     {   oldLocation = newLocation   }
                     newLocation = pos
                     if !isPathDrawwn {
                    drawRouteOnMap(lat: latitude, long: longitude)
                     }
                 }
             }
         }
         refreshMapWithNewLocation()
     }
    
    //Update Driver Location On Map
    func refreshMapWithNewLocation()
    {
        refreshLocation()
    }
    
    
    //MARK:- Manage Map
    func setUpMarker()
    {
        self.mapView.isMyLocationEnabled = true
        let bounds = GMSCoordinateBounds()
        
        //Driver Location
        let camera = GMSCameraPosition.camera(withLatitude: newLocation?.latitude ?? CLLocationDegrees(exactly: 0)!,
                                              longitude: newLocation?.longitude ?? CLLocationDegrees(exactly: 0)!,
                                              zoom:  15.0,
                                              bearing: 0,
                                              viewingAngle:  0)
        mapView.camera = camera
        bounds.includingCoordinate(newLocation!)
        driverMarker.position = newLocation!
        driverMarker.icon = #imageLiteral(resourceName: "motorcycle_delivery_man_icon")
        driverMarker.appearAnimation = .pop
        driverMarker.isDraggable = false
        mapView.delegate = self
        
        //Shop Location
        let shop_lat = CLLocationDegrees(exactly: Float(shopLat) ?? 0.0)!
        let shop_long = CLLocationDegrees(exactly: Float(shopLong) ?? 0.0)!
        let shop_camera = GMSCameraPosition.camera(withLatitude: newLocation?.latitude ?? CLLocationDegrees(exactly: 0)!,
                                              longitude: newLocation?.longitude ?? CLLocationDegrees(exactly: 0)!,
                                              zoom:  15.0,
                                              bearing: 0,
                                              viewingAngle:  0)
        mapView.camera = shop_camera
        shopMarker.position = CLLocationCoordinate2D(latitude: shop_lat, longitude: shop_long)
        bounds.includingCoordinate(shopMarker.position)
        shopMarker.icon = #imageLiteral(resourceName: "icon_shop_pin")
        shopMarker.appearAnimation = .pop
        shopMarker.isDraggable = false
        
        //Delivery 1
        let del_lat = CLLocationDegrees(exactly: Float(deliveryLatitude) ?? 0.0)!
        let del_long = CLLocationDegrees(exactly: Float(deliveryLongitude) ?? 0.0)!
        let camera1 = GMSCameraPosition.camera(withLatitude: del_lat,
                                              longitude: del_long,
                                              zoom:  15.0,
                                              bearing: 0,
                                              viewingAngle:  0)
        mapView.camera = camera1
        deliveryMarker.position = CLLocationCoordinate2D(latitude: del_lat, longitude: del_long)
        deliveryMarker.icon = #imageLiteral(resourceName: "icon_order1_pin")
        deliveryMarker.appearAnimation = .pop
        deliveryMarker.isDraggable = false
        bounds.includingCoordinate(deliveryMarker.position)
        if isMergedOrder { //Delivery 2
            let del_lat2 = CLLocationDegrees(exactly: Float(deliveryLatitude2) ?? 0.0)!
            let del_long2 = CLLocationDegrees(exactly: Float(deliveryLongitude2) ?? 0.0)!
            let camera2 = GMSCameraPosition.camera(withLatitude: del_lat2,
                                                   longitude: del_long2,
                                                   zoom:  15.0,
                                                   bearing: 0,
                                                   viewingAngle:  0)
            mapView.camera = camera2
            deliveryMarker2.position = CLLocationCoordinate2D(latitude: del_lat2, longitude: del_long2)
            deliveryMarker2.icon = #imageLiteral(resourceName: "icon_order2_pin")
            deliveryMarker2.appearAnimation = .pop
            deliveryMarker2.isDraggable = false
            bounds.includingCoordinate(deliveryMarker2.position)
            DispatchQueue.main.async
            {
                self.driverMarker.map = self.mapView
                self.deliveryMarker.map = self.mapView
                self.shopMarker.map = self.mapView
                self.deliveryMarker2.map = self.mapView
            }
        } else {
            DispatchQueue.main.async
            {
                self.shopMarker.map = self.mapView
                self.driverMarker.map = self.mapView
                self.deliveryMarker.map = self.mapView
            }
        }
        
        let updates = GMSCameraUpdate.fit(bounds, withPadding: 20.0)
        self.mapView?.moveCamera(updates)
    }
    func refreshLocation()
    {
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        
        driverMarker.position = newLocation! //CLLocationCoordinate2DMake([[d valueForKey:@"currentLat"] doubleValue], [[d valueForKey:@"currentLong"] doubleValue]);
        /*
        let getAngle = angle(fromCoordinate: oldLocation!, toCoordinate: newLocation!)
        let startLocation = CLLocation(latitude: oldLocation?.latitude  ?? CLLocationDegrees(), longitude: oldLocation?.longitude ?? CLLocationDegrees())
        let endLocation = CLLocation(latitude: newLocation?.latitude ?? CLLocationDegrees(), longitude: newLocation?.longitude ?? CLLocationDegrees())
        let distance = startLocation.distance(from: endLocation)
        if distance > 2
        {
            marker.rotation = CLLocationDegrees(getAngle * (180.0 / .pi)) //[[d valueForKey:@"degree"] doubleValue];
        }
        */
        CATransaction.commit()

        mapView.animate(toLocation: driverMarker.position)
        
    }
    func angle(fromCoordinate first: CLLocationCoordinate2D, toCoordinate second: CLLocationCoordinate2D) -> Float {

        let deltaLongitude = Float(second.longitude - first.longitude)
        let deltaLatitude = Float(second.latitude - first.latitude)
        let angle: Float = (.pi * 0.5) - atan(deltaLatitude / deltaLongitude)

        if deltaLongitude > 0 {
            return angle
        } else if deltaLongitude < 0 {
            return angle + .pi
        } else if deltaLatitude < 0 {
            return .pi
        }

        return 0.0
    }
    //MARK:- Fetch Path PoliString
    func fetchRoute() {

        let session = URLSession.shared
        var urlStr = ""
        if self.orderNotPickedUp {
            urlStr = "https://maps.googleapis.com/maps/api/directions/json?origin=\(driverLat),\(driverLong)&destination=\(shopLat),\(shopLong)&waypoints=\(deliveryLatitude),\(deliveryLongitude)&sensor=false&mode=driving&key=\(GOOGLE_KEY)"
            
        } else if isMergedOrder {
            urlStr = "https://maps.googleapis.com/maps/api/directions/json?origin=\(driverLat),\(driverLong)&destination=\(deliveryLatitude2),\(deliveryLongitude2)&waypoints=\(deliveryLatitude),\(deliveryLongitude)&sensor=false&mode=driving&key=\(GOOGLE_KEY)"
            
        } else {
          urlStr = "https://maps.googleapis.com/maps/api/directions/json?origin=\(driverLat),\(driverLong)&destination=\(deliveryLatitude),\(deliveryLongitude)&sensor=false&mode=driving&key=\(GOOGLE_KEY)"
        }
        let url = URL(string: urlStr)!

        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in

            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            let jsonResponse : [String:Any]?
            if let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            {
                jsonResponse = jsonResult
            }
            else
            {
                print("error in JSONSerialization")
                return
            }

            guard let routes = jsonResponse!["routes"] as? [Any] else {
                return
            }

            guard let route = routes[0] as? [String: Any] else {
                return
            }

            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }

            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }

            //Call this method to draw path on map
            
            self.drawPath(from: polyLineString)
        })
        task.resume()
    }
    
    func fetchRoute(to_lat : String , to_long : String, from_lat:String, from_long : String) {

        let session = URLSession.shared
        var urlStr = ""
        if self.orderNotPickedUp {
            urlStr = "https://maps.googleapis.com/maps/api/directions/json?origin=\(driverLat),\(driverLong)&destination=\(shopLat),\(shopLong)&waypoints=\(deliveryLatitude),\(deliveryLongitude)&sensor=false&mode=driving&key=\(GOOGLE_KEY)"
            
        } else if isMergedOrder {
            urlStr = "https://maps.googleapis.com/maps/api/directions/json?origin=\(driverLat),\(driverLong)&destination=\(deliveryLatitude2),\(deliveryLongitude2)&waypoints=\(deliveryLatitude),\(deliveryLongitude)&sensor=false&mode=driving&key=\(GOOGLE_KEY)"
            
        } else {
          urlStr = "https://maps.googleapis.com/maps/api/directions/json?origin=\(driverLat),\(driverLong)&destination=\(deliveryLatitude),\(deliveryLongitude)&sensor=false&mode=driving&key=\(GOOGLE_KEY)"
        }
        //let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(from_lat ),\(from_long)&destination=\(to_lat),\(to_long)&sensor=false&mode=driving&key=\(GOOGLE_KEY)")!
        let url = URL(string: urlStr)!
        print("URL :: ",url)
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in

            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            let jsonResponse : [String:Any]?
            if let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            {
                jsonResponse = jsonResult
            }
            else
            {
                print("error in JSONSerialization")
                return
            }

            guard let routes = jsonResponse!["routes"] as? [Any] else {
                return
            }
            if routes.count == 0
            {
                return
            }
            guard let route = routes[0] as? [String: Any] else {
                return
            }

            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }

            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }

            //Call this method to draw path on map
            
            self.drawPath(from: polyLineString)
        })
        task.resume()
    }
    //Draw line on map
        func drawPath(from polyStr: String){
           
            KRProgressHUD.dismiss()
            //self.oldPolyline = polyline
            DispatchQueue.main.async
            {

                 let path = GMSPath(fromEncodedPath: polyStr)
                 let polyline = GMSPolyline(path: path)
                 polyline.strokeWidth = 5.0
                polyline.map = self.mapView // Google MapView
                 polyline.strokeColor = strokeColor
                
             if self.mapView != nil
             {
              let bounds = GMSCoordinateBounds(path: path!)
              self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
             }
            }
    }
    
    func drawRouteOnMap( lat : String, long : String) {
        self.fetchRoute(to_lat: "\(lat)" , to_long: "\(long)", from_lat: deliveryLatitude, from_long: deliveryLongitude)
      /*  var arrSortedStores = [[String:Any]]()
        for objStore in orderDetails!.stores! {
            var d = [String : Any]()
            d["store"] = objStore
            let dist = distance(lat1: Double(objStore.latitude ?? "") ?? 0.0, lon1: Double(objStore.longitude ?? "") ?? 0.0, lat2: Double(lat) as! Double, lon2: Double(long) as! Double)
            if dist.count > 0{
                let a = dist.components(separatedBy: " ")
                if a.count > 0 {
                    d["distance"] = Double(a[0] )
                } else {
                    d["distance"] = 0.0
                }
            }else {
                d["distance"] = 0.0
            }
            arrSortedStores.append(d)
        }
        arrSortedStores = arrSortedStores.sorted { $0["distance"] as? Double ?? .zero < $1["distance"] as? Double ?? .zero }
        
        for i in 0..<arrSortedStores.count {
            let obj = arrSortedStores[i]
            let objStore = obj["store"] as! CurrentOrderStores
            
            if i == 0 {
                DispatchQueue.main.async {
                    self.fetchRoute(to_lat: objStore.latitude ?? "", to_long: objStore.longitude ?? "", from_lat: "\(lat)", from_long: "\(long)")
                }
            } else {
                let prevObj = arrSortedStores[i - 1]
                let prevObjStore = prevObj["store"] as! CurrentOrderStores
                var toLat = ""
                var toLong = ""
                toLat =  objStore.latitude ?? ""
                toLong =  objStore.longitude ?? ""
                DispatchQueue.main.async {
                    self.fetchRoute(to_lat: toLat, to_long: toLong, from_lat: prevObjStore.latitude ?? "", from_long: prevObjStore.longitude ?? "")
                }
            }
            
            let lastObj = arrSortedStores.last
            let lastObjStore = lastObj!["store"] as! CurrentOrderStores
            DispatchQueue.main.async {
                self.fetchRoute(to_lat: self.orderDetails!.deliveryLatitude ?? "", to_long: self.orderDetails!.deliveryLongitude ?? "", from_lat: lastObjStore.latitude ?? "", from_long: lastObjStore.longitude ?? "")
            }
            
            //ADD STORE MARKER
            DispatchQueue.main.async {
               let storeWindow = StoreNumberInfoWindow(nibName: "StoreNumberInfoWindow", bundle: nil)
                let point =  CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(objStore.latitude ?? "")! )!, longitude: CLLocationDegrees(exactly: Double(objStore.longitude ?? "")! )!)
                storeWindow.setValues(number: "\(i + 1)")
                let  m = GMSMarker(position: point)
                m.iconView = storeWindow.view
                m.infoWindowAnchor = CGPoint(x: 1, y: 1)
                m.isTappable = false
                self.mapView.selectedMarker = m
                m.map = self.mapView
            }
        }*/
        KRProgressHUD.dismiss()
    }
    
    //Calculate Distance Between two location
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> String {
        let coordinate₀ = CLLocation(latitude: lat1, longitude: lon1)
        let coordinate₁ = CLLocation(latitude: lat2, longitude: lon2)

        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        
        let time = distanceInMeters / 400

            if time > 50 && time < 60
            {
                print("around 1 hour(\(time.rounded(toPlaces: 0))minits)")
            }
            else if time >= 60
            {
                print("Hours : ",(Double(time/60).rounded(toPlaces: 1).rounded(toPlaces: 0)))
                tmproutetime = "\(Int(Double(time/60).rounded(toPlaces: 1).rounded(toPlaces: 0))) Hrs"
            }
            else
            {
                print("Minit : ",time.rounded(toPlaces: 0))
                tmproutetime = "\(Int(time.rounded(toPlaces: 0))) min"
            }
            
            
            let distanceInKM = distanceInMeters / 1000
            if distanceInMeters >= 1000
            {
                tmproutedist = "\(distanceInKM.rounded(toPlaces: 2)) KM"
                return "\(distanceInKM.rounded(toPlaces: 2)) km"
                
            }
            else
            {
                tmproutedist = "\(distanceInMeters.rounded(toPlaces: 2)) MTR"
                return "\(distanceInMeters.rounded(toPlaces: 2)) meters"
            }
          //  return "\(distanceInKM)"
        
//
//
//        return
//        let coordinate₀ = CLLocation(latitude: lat1, longitude: lon1)
//        let coordinate₁ = CLLocation(latitude: lat2, longitude: lon2)
//
//        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
//
//        let time = distanceInMeters / 400
//        if time > 50 && time < 60
//        {
//            print("around 1 hour(\(time.rounded(toPlaces: 0))minits)")
//        }
//        else if time >= 60
//        {
//            print("Hours : ",(Double(time/60).rounded(toPlaces: 1).rounded(toPlaces: 0)))
//            //tmproutetime = "\(Int(Double(time/60).rounded(toPlaces: 1).rounded(toPlaces: 0))) Hrs"
//        }
//        else
//        {
//            print("Minit : ",time.rounded(toPlaces: 0))
//           //// tmproutetime = "\(Int(time.rounded(toPlaces: 0))) min"
//        }
//
//
//        let distanceInKM = distanceInMeters / 1000
//        if distanceInMeters >= 1000
//        {
//            //tmproutedist = "\(distanceInKM.rounded(toPlaces: 2)) KM"
//            return "\(distanceInKM.rounded(toPlaces: 2)) km"
//        }
//        else
//        {
//            //tmproutedist = "\(distanceInMeters.rounded(toPlaces: 2)) MTR"
//            return "\(distanceInMeters.rounded(toPlaces: 2)) meters"
//        }
//        return "\(distanceInKM)"
//        ////
        
    }
}

//MARK:- GSM Location Delegate
extension DriverLocationViewController : CLLocationManagerDelegate
{
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

        //let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 5.0)
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0, bearing: 270, viewingAngle: 45)
        self.mapView?.animate(to: camera)

        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()

    }
    
    func moveToLocation(toLocation: CLLocationCoordinate2D?)
    {
        
    }
}
//MARK:- Google Map Delegate
extension DriverLocationViewController : GMSMapViewDelegate {
 /*
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //self.locationManager.startUpdatingLocation()
            
                if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == .authorizedAlways) {
                   var currentLoc = locationManager.location
                    if currentLoc == nil
                    {
                        currentLoc = locationManager.location
                        
                    }
                    let camera = GMSCameraPosition.camera(withLatitude: (currentLoc?.coordinate.latitude)!,
                                                          longitude: (currentLoc?.coordinate.longitude)!,
                                                          zoom:  15.0,
                                        bearing: 0,
                                        viewingAngle:  0)
                    mapView.camera = camera
                    self.mapView?.animate(to: camera)
                }
               
                
    }*/
}
