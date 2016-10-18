//
//  GeolocationViewController.swift
//  LetoToggliOS
//
//  Created by Ismael Gobernado Alonso on 9/5/16.
//  Copyright © 2016 Leto. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

let kSavedItemsKey = "savedItems"

class GeolocationViewController: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate{

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet weak var helpLabel: UILabel!
    
    var parentAddressTF: UITextField!
    
    var alert : UIAlertController!
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 100
    var anotation = MKPointAnnotation()
    var userlocation = MKUserLocation()
    var centerOnDetection = true
    
    var currentGeotification: Geotification?
    
    var changeAddressText = true
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Location Manager
        
        initLocationManager()
        
        loadGeotifications()
        
        //Set Gesture Recognicer
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0.7
        longPressGestureRecognizer.delegate = self
        self.mapView.addGestureRecognizer(longPressGestureRecognizer)
    
        registerForDistanceNotifications()
        setupUI()
        self.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 0,longitude: 0), animated: false)
    }
    
    func initLocationManager(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        AnswersTracking.trackEventScreen("GeolocationViewController Will Appear")
    }
    
    func registerForDistanceNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleDistanceNotif(_:)), name: AppPreferences.DISTANCE_NOTIF, object: nil)
    }
    
    func handleDistanceNotif(notif: NSNotification) {
        if let info = notif.userInfo as! Dictionary<String,AnyObject>!{
            if let distanceInMeters:Double = info["distance"]! as? Double{
                updateDistanceLabel(distanceInMeters)
            }
        }
    }
    
    func updateDistanceLabel (distanceInMeters: Double) {
        if distanceInMeters > 1000 {
            let distanceinKM = distanceInMeters/1000
            distanceLabel.text = "Distance: \(distanceinKM.roundedTwoDigit) km"
        }else{
            distanceLabel.text = "Distance: \(distanceInMeters) m"
        }
    }
    
    func getClocationIntersection (location1:CLLocationCoordinate2D , location2:CLLocationCoordinate2D)->CLLocation{
        
        return CLLocation(latitude: (location1.latitude + location2.latitude )/2, longitude:( location1.longitude + location2.longitude )/2)

    
    }
    
//MARK: location manager 
  
//MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            if centerOnDetection {
                self.centerMapOnLocation(CLLocation(latitude: annotation.coordinate.latitude,longitude: annotation.coordinate.longitude), distance: 75)
                centerOnDetection = false
            }
           
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.image = UIImage(named:"location")
            anView!.contentMode = UIViewContentMode.ScaleAspectFit
            anView!.canShowCallout = true
            
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView!.annotation = annotation
        }
        
        return anView
    }
    
  
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor.redColor()
        circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
        circle.lineWidth = 1
        return circle
    }
        
//MARK: UIGestureRecognizerDelegate
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let touchPoint = gestureReconizer.locationInView(self.mapView)
        let touchMapCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
//         mapView.overlays
        addNewGeotification(touchMapCoordinate);
    }
    
//MARK: Helpers

    func centerMapOnLocation(location: CLLocation ,distance:Double) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius * distance/10, regionRadius * distance/10)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: Map overlay functions
    
    func addRadiusOverlayForGeotification(geotification: Geotification) {
        mapView?.addOverlay(MKCircle(centerCoordinate: geotification.coordinate, radius: geotification.radius))
    }
    
    func removeAllRadiusOverlay() {
        // Find exactly one overlay which has the same coordinates & radius to remove
        if let overlays = mapView?.overlays {
            for overlay in overlays {
                if let circleOverlay = overlay as? MKCircle {
                        mapView?.removeOverlay(circleOverlay)
                        break
                    }
                }
            }
     }
    
    func loadGeotifications() {
        if let geotification = AppPreferences.getGeotification() as Geotification?{
            addGeotification(geotification)
            currentGeotification = geotification
        }
    }
    
    func addNewGeotification (locationCoordinate2D: CLLocationCoordinate2D ){
        helpLabel.hidden=true
         mapView.removeAnnotations(mapView.annotations)
         removeAllRadiusOverlay()
        let geotification = Geotification(coordinate: locationCoordinate2D, radius: regionRadius, identifier: "Leto", note: "Your Workplace")
        self.mapView.addAnnotation(geotification)
        addRadiusOverlayForGeotification(geotification)
       currentGeotification = geotification
        updateAddressStringFromCoordinates(geotification.coordinate)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        userLocation.title = ""
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if currentGeotification != nil {
            let officeCoordinates  = CLLocation (latitude: currentGeotification!.coordinate.latitude, longitude: currentGeotification!.coordinate.longitude)
            let userCoordinates  = CLLocation (latitude: locValue.latitude, longitude: locValue.longitude)
            let distance = AppUtils.calculateDistanceBetweenTwoLocationsInMeters(userCoordinates, destination: officeCoordinates)
            distanceLabel.hidden=false
            updateDistanceLabel(distance)
        }else{
            distanceLabel.hidden=true
        }
    }
    
    func addGeotification (geotification : Geotification ){
        helpLabel.hidden=true
        self.mapView.addAnnotation(geotification)
        addRadiusOverlayForGeotification(geotification)
        updateAddressStringFromCoordinates(geotification.coordinate)
    }
    
    func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        region.notifyOnEntry = true
        region.notifyOnExit =  true
        return region
    }
    
    func startMonitoringGeotification(geotification: Geotification) {
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            print("Geofencing is not supported on this device!")
            return
        }
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            print("Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        let region = regionWithGeotification(geotification)
        locationManager.startMonitoringForRegion(region)
    }
    
    func stopMonitoringGeotification(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == geotification.identifier {
                    locationManager.stopMonitoringForRegion(circularRegion)
                }
            }
        }
    }

    func setupUI (){
        distanceLabel.layer.masksToBounds = true
        distanceLabel.layer.cornerRadius = 3
        helpLabel.layer.masksToBounds = true
        helpLabel.layer.cornerRadius = 3
    }
    
    
    func updateAddressStringFromCoordinates (coordinates:CLLocationCoordinate2D){
        if changeAddressText {
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                print(location)
                self.parentAddressTF.text=""
                
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks!.count > 0 {
                    let placeMark = placemarks![0]
                    
                    var address:String=""
                    
                    // Location name
                    if let locationName = placeMark.addressDictionary?["Name"] as? String
                    {
                        address+=locationName+", "
                    }
                    
                    // City
                    if let city = placeMark.addressDictionary?["City"] as? String
                    {
                        address+=city+", "
                    }
                    
                    // Zip code
                    if let zip = placeMark.addressDictionary?["ZIP"] as? String
                    {
                        address+=zip+", "
                    }
                    
                    // Country
                    if let country = placeMark.addressDictionary?["Country"] as? String
                    {
                        address+=country
                    }
                    self.parentAddressTF.text=address
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })

        }
    }
    
    func addGeofenceUsingAddress(address:String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemark = placemarks?[0]{
                self.changeAddressText = false
                self.addNewGeotification((placemark.location?.coordinate)!)
                self.changeAddressText = true
            }else{
                let alertController = UIAlertController(title: NSLocalizedString("localized_error", comment: ""), message:
                    NSLocalizedString("localized_address_error", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("localized_ok", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
}//End Class

//MARK: Extensions
    extension Double{
    
    var roundedTwoDigit:Double{
        
        return Double(round(100*self)/100)
        
    }
}
