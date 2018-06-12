//
//  ViewController.swift
//  LocationCompass
//
//  Created by TakahashiNobuhiro on 2018/06/10.
//  Copyright © 2018 feb19. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var compassImageView: UIImageView!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var altLabel: UILabel!
    @IBOutlet weak var diffNorthLabel: UILabel!
    @IBOutlet weak var northDirectionLabel: UILabel!
    @IBOutlet weak var northTypeSegmentedControl: UISegmentedControl!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        northTypeSegmentedControl.selectedSegmentIndex = 0
        locationManager.requestWhenInUseAuthorization()
        
//        locationManager.requestLocation()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        
        locationManager.headingOrientation = .portrait
        locationManager.headingFilter = 1
        locationManager.startUpdatingHeading()
    }
    
    func setupLocationService() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.stopUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationData = locations.last
        
        if var lat = locationData?.coordinate.latitude {
            lat = round((lat * 1000000) / 1000000)
            latLabel.text = "\(lat)"
        }
        if var lon = locationData?.coordinate.longitude {
            lon = round((lon * 1000000) / 1000000)
            lonLabel.text = "\(lon)"
        }
        if var alt = locationData?.altitude {
            alt = round(alt * 100) / 100
            altLabel.text = "\(alt)m"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let trueNorth = newHeading.trueHeading
        let compassNorth = newHeading.magneticHeading
        var diffNorth = compassNorth - trueNorth
        if diffNorth < 0 {
            diffNorth = diffNorth + 360
        }
        diffNorth = round(diffNorth * 100) / 100
        diffNorthLabel.text = "\(diffNorth)"
        
        let directionOfNorth: CLLocationDirection
        if northTypeSegmentedControl.selectedSegmentIndex == 0 {
            directionOfNorth = trueNorth
        } else {
            directionOfNorth = compassNorth
        }
        compassImageView.transform = CGAffineTransform(rotationAngle: CGFloat(directionOfNorth * Double.pi / 180) )
        
        let northDirection = round(directionOfNorth * 100) / 100
        northDirectionLabel.text = "\(northDirection)"
    }
}

