//
//  FinalBookingViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 08/06/22.
//

import UIKit
import GoogleMaps

class FinalBookingViewController: UIViewController,GMSMapViewDelegate,UITextFieldDelegate {
    
    var mapView :GMSMapView!
    var geoCoder :CLGeocoder!


    @IBOutlet weak var mainView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentLocationOnMap()
        addSubViews()
       // viewAnimation()
    }
    
    func addSubViews() {
        self.view.bringSubviewToFront(mainView)
    }
    
    
         
    func showCurrentLocationOnMap() {
           
        let camera = GMSCameraPosition.camera(withLatitude: -33.26, longitude: 151.20, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: self.view.frame , camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        self.view.addSubview(mapView)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.26, longitude: 151.20)
        marker.isDraggable = true
        marker.map = mapView
        self.mapView.delegate = self
        marker.isDraggable = true
        marker.tracksInfoWindowChanges = true
        marker.map = mapView
        self.mapView.delegate = self
        addSubViews()
    }
    
    @IBAction func textfield(_ sender: UITextField) {
        UIView.transition(with: mainView, duration: 0.33,
          options: [.curveEaseOut, .transitionFlipFromTop],
                          animations: { [self] in
            mainView.removeFromSuperview()
          },
          completion: nil
        )
       
  }
}
