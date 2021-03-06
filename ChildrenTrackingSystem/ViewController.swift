//
//  ViewController.swift
//  ChildrenTrackingSystem
//
//  Created by Bubble on 10/26/18.
//  Copyright © 2018 Bubble. All rights reserved.
//

import UIKit
import MapKit

protocol Something: class {
    func updateLocationCoordinateLabel(_ coordinate: String)
}


class MapViewController: UIViewController, Something {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var satelliteViewBarButton: UIBarButtonItem!
    @IBOutlet weak var flyoverBarButton: UIBarButtonItem!
    @IBOutlet weak var locationCoordinateLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    let locationManger = LocationTracking()
    let annotation = MKPointAnnotation()
    let camera = MKMapCamera()
    
    func requestLocationPermission(){
        do{
            try locationManger.requestLocationAuthorization()
        }
        catch LocationError.disallowedByUser{
            //show alert to users
        }
        catch let error{
            print("Location Authoriaztion Error: \(error.localizedDescription)")
        }
 
        
    }
    
    
    
 
    func updateLocationCoordinateLabel(_ coordinate: String){
        print("here: \(coordinate)")
        locationCoordinateLabel.text = coordinate
    }
    
    
    let regionRadius: CLLocationDistance = 1000
  

    
    func centerMapLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
       
    }
    
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        locationManger.requestLocation()
        displayMap()
        
    }
    
    @IBAction func satelliteButtonAction(_ sender: Any) {
        if satelliteViewBarButton.title == "Standard"{
            mapView.mapType = .standard
            satelliteViewBarButton.title = "Satellite"
        }
        else {
            mapView.mapType = .satellite
            satelliteViewBarButton.title = "Standard"
        }
    }
    
    struct cameraInfo{
        var location = CLLocationCoordinate2D()
        var heading = CLLocationDirection()
        init(latitude:CLLocationDegrees,longitude:CLLocationDegrees,heading:CLLocationDirection){
            self.location = CLLocationCoordinate2D(latitude: latitude,longitude: longitude)
            self.heading = heading
        }
    }
    
    @IBAction func flyOverViewBarButtonAction(_ sender: Any) {
        let CPOGLocation = cameraInfo(
            latitude: Coordinate.latitude,
            longitude: Coordinate.longitude,
            heading: 338.0)
        
        let camera = MKMapCamera(
            lookingAtCenter: CPOGLocation.location,
            fromDistance: 0.01,
            pitch: 90,
            heading: CPOGLocation.heading)
        mapView.setCamera(camera, animated: true)
    }
    
    func displayMap(){
            updateLocationCoordinateLabel(Coordinate.description)
            centerMapLocation(location: Coordinate.location)
            annotation.coordinate = CLLocationCoordinate2D(latitude: Coordinate.latitude, longitude: Coordinate.longitude)
            mapView.addAnnotation(self.annotation)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
        requestLocationPermission()
        locationManger.requestLocation()
        DispatchQueue.main.async {
             self.displayMap()
        }
        
        
        

    }


}

