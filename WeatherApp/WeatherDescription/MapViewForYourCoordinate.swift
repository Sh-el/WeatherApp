import Foundation
import SwiftUI
import MapKit

class Coordinator: NSObject, MKMapViewDelegate {
    var control: MapViewForYourCoordinate
    
    init(_ control: MapViewForYourCoordinate) {
        self.control = control
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let annotationView = views.first {
            if let annotation = annotationView.annotation {
                if annotation is MKUserLocation {
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 25000, longitudinalMeters: 25000)
                    mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    
}

struct MapViewForYourCoordinate: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        return map
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewForYourCoordinate>) {
        //
    }
}


