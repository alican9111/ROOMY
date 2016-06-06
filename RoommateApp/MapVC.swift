//
//  MapVC.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 18/04/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController,MKMapViewDelegate {

    var backendless = Backendless.sharedInstance()
    @IBOutlet weak var mapview: MKMapView!
    
    var housenumberofadarray = [String]()
    var housepricearray = [String]()
    var latitudearray = [String]()
    var longitudearray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            self.mapview.delegate = self
            showHouseAsync()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*        func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            if (annotation is MKUserLocation) {
                return nil
            }
            
            if (annotation.isKindOfClass(CustomAnnotation)) {
                let customAnnotation = annotation as? CustomAnnotation
                mapView.translatesAutoresizingMaskIntoConstraints = true
                var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotation") as MKAnnotationView!
                
                if (annotationView == nil) {
                    
                    annotationView = customAnnotation?.annotationView()
                    annotationView.canShowCallout = true
                     annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                } else {
                    
                    annotationView.annotation = annotation;
    
                }
                
               // self.addBounceAnimationToView(annotationView)
                return annotationView
            } else {
                return nil
            }
        }*/
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotation") as MKAnnotationView!

        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
            view?.canShowCallout = true
            view?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            view?.annotation = annotation
        }
        self.addBounceAnimationToView(view)
        return view
    }
    
    var selectedannotation : MKPointAnnotation!
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            selectedannotation = view.annotation as! MKPointAnnotation
            performSegueWithIdentifier("NextScene", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? DetailHouseVC
        {
            destination.selectedid = String(selectedannotation.accessibilityHint!)
            destination.map = true
        }
    }
    
    func addBounceAnimationToView(view: UIView) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale") as CAKeyframeAnimation
        bounceAnimation.values = [ 0.05, 1.1, 0.9, 1]
        
        let timingFunctions = NSMutableArray(capacity: bounceAnimation.values!.count)
        
        for var i = 0; i < bounceAnimation.values!.count; i++ {
            timingFunctions.addObject(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        bounceAnimation.timingFunctions = timingFunctions as NSArray as? [CAMediaTimingFunction]
        bounceAnimation.removedOnCompletion = false
        
        view.layer.addAnimation(bounceAnimation, forKey: "bounce")
    }
    
    
    
    func showHouseAsync()
    {
        let query = BackendlessDataQuery()
        
        
        backendless.persistenceService.of(House.ofClass()).find(
            query,
            response: { ( houses : BackendlessCollection!) -> () in
                let currentPage = houses.getCurrentPage()
                
                for selector in currentPage as! [House] {
                    
                    if (selector.latitude.isBlank==false && selector.longitude.isBlank==false && selector.isactive==true)
                    {
                    
                    let newhouseLocation = CLLocationCoordinate2DMake(Double(selector.latitude)!, Double(selector.longitude)!)
                    // Drop a pin
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = newhouseLocation
                    dropPin.title = "İlan No: "+selector.numberofad
                    dropPin.subtitle = "Kira:"+String(selector.price)+"TL"
                    dropPin.accessibilityHint = selector.objectId
                    self.mapview.addAnnotation(dropPin)
                    
                    }
                    
                }
                
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }

}
