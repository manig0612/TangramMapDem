//
//  ViewController.swift
//  TangramMapDem
//
//  Created by ManiKandan on 16/03/24.
//


import UIKit
import TangramMap
 

class ViewController: UIViewController, TGMapViewDelegate, TGRecognizerDelegate {
    
    var mapView: TGMapView!
    var markers: [TGMarker] = []
    var polylines: [TGGeoPolyline] = []
    var polygons: [TGGeoPolygon] = []
    var polylinePoints: [CLLocationCoordinate2D] = []
    var polygonPoints: [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
           super.viewDidLoad()

        
           let containerView = UIView()
           containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .gray
           view.addSubview(containerView)

           
           NSLayoutConstraint.activate([
               containerView.topAnchor.constraint(equalTo: view.topAnchor),
               containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])

           mapView = TGMapView(frame: CGRect.zero)
           mapView.mapViewDelegate = self
           mapView.gestureDelegate = self
           mapView.translatesAutoresizingMaskIntoConstraints = false
        
           containerView.addSubview(mapView)

        
           let stackView = UIStackView()
           stackView.axis = .vertical
           stackView.alignment = .fill
           stackView.spacing = 10
           stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .yellow
        stackView.isHidden = false
        stackView.layer.cornerRadius = 25
           containerView.addSubview(stackView)

           // Add constraints for the stack view
           NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
               stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
               stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
           ])

        
           addButtonsToStackView(stackView)

           
           NSLayoutConstraint.activate([
               mapView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
               mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
               mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
               mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
           ])
       }

       func addButtonsToStackView(_ stackView: UIStackView) {
           var addMarkerButton = UIButton(type: .system)
           addMarkerButton = UIButton(frame: CGRect(x: 300, y: 700, width: 70, height: 70))
           addMarkerButton.layer.cornerRadius = addMarkerButton.frame.width / 2
           addMarkerButton.setTitle("Mark", for: .normal)
           let image = UIImage(named: "marker")
           addMarkerButton.setImage(image, for: .normal)

           addMarkerButton.backgroundColor = .blue
           addMarkerButton.addTarget(self, action: #selector(addMarker), for: .touchUpInside)
           view.addSubview(addMarkerButton)
           

           var removeMarkerButton = UIButton(type: .system)
           removeMarkerButton = UIButton(frame: CGRect(x: 300, y: 600, width: 70, height: 70))
           removeMarkerButton.layer.cornerRadius = removeMarkerButton.frame.width / 2
           removeMarkerButton.setTitle("Remove Marker", for: .normal)
           let imagemark = UIImage(named: "removemarker")
           removeMarkerButton.setImage(imagemark, for: .normal)
           removeMarkerButton.backgroundColor = .green
           removeMarkerButton.addTarget(self, action: #selector(removeMarker), for: .touchUpInside)
           view.addSubview(removeMarkerButton)
          
           let drawPolylineButton = UIButton(type: .system)
           drawPolylineButton.setTitle("Draw Polyline", for: .normal)
           drawPolylineButton.backgroundColor = .red
           drawPolylineButton.addTarget(self, action: #selector(startDrawingPolyline), for: .touchUpInside)
           stackView.addArrangedSubview(drawPolylineButton)

           let drawPolygonButton = UIButton(type: .system)
           drawPolygonButton.setTitle("Draw Polygon", for: .normal)
           drawPolygonButton.addTarget(self, action: #selector(startDrawingPolygon), for: .touchUpInside)
           stackView.addArrangedSubview(drawPolygonButton)
       }

    
    @objc func addMarker() {
        let marker = mapView.markerAdd()
        marker.stylingString = "{ style: 'points', color: 'white', size: [25px, 25px], order:500 }"
        marker.point = CLLocationCoordinate2D(latitude:  13.0827, longitude: 80.2707)
        marker.icon = UIImage(named: "mark")!
        markers.append(marker)
    }
    
    @objc func removeMarker() {
        if let marker = markers.popLast() {
            mapView.markerRemove(marker)
        }
    }
    
    @objc func startDrawingPolyline() {
        addPolyline()
    }
    
    func addPolyline() {
        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707),
            CLLocationCoordinate2D(latitude: 13.0067, longitude: 80.2206),
            CLLocationCoordinate2D(latitude: 12.9815, longitude: 80.2180)
        ]

        let polyline = TGGeoPolyline(coordinates: coordinates, count: 3)
        let b = mapView.markerAdd()
        b.stylingString = "{ style: 'lines', color: 'blue', width: 5, order: 500, cap: 'round', join: 'round' }";
        b.polyline = polyline
        markers.append(b)
    }
    
    @objc func startDrawingPolygon() {

        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707),
            CLLocationCoordinate2D(latitude: 13.0853, longitude: 80.2607),
            CLLocationCoordinate2D(latitude: 13.0969, longitude: 80.2865)
        ]

        let coordinates2: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 13.0633, longitude: 80.2812),
            CLLocationCoordinate2D(latitude: 13.0368, longitude: 80.2676),
            CLLocationCoordinate2D(latitude: 13.0279, longitude: 80.2605)
        ]

        let polyline1 = TGGeoPolyline(coordinates: coordinates, count: UInt(coordinates.count))
        let polyline2 = TGGeoPolyline(coordinates: coordinates2, count: UInt(coordinates2.count))

        let polygon = TGGeoPolygon(rings: [polyline1, polyline2])

        let marker = mapView.markerAdd()
        marker.polygon = polygon

        marker.stylingString = "{ style: 'polygons', color: 'blue', width: 5, order: 500, cap: 'round', join: 'round' }"


        markers.append(marker)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let apiKey = "iFjzWiMgR5GqLlJ51u_2YA"
        let sceneUpdates = [TGSceneUpdate(path: "global.sdk_api_key", value: apiKey)]
        let sceneUrl = URL(string: "https://www.nextzen.org/carto/bubble-wrap-style/9/bubble-wrap-style.zip")!
        mapView.loadSceneAsync(from: sceneUrl, with: sceneUpdates)
    }
    
    func mapView(_ mapView: TGMapView, didLoadScene sceneID: Int32, withError sceneError: Error?) {
        if let error = sceneError {
            print("Scene load error: \(error.localizedDescription)")
        } else {
            print("Scene loaded successfully.")
            let chenni = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
            mapView.cameraPosition = TGCameraPosition(center: chenni, zoom: 15, bearing: 0, pitch: 0)
        }
    }
    
    func mapView(_ view: TGMapView!, recognizer: UIGestureRecognizer!, didRecognizeSingleTapGesture location: CGPoint) {
        let coordinate = view.coordinate(fromViewPosition: location)
        print("Tapped location: \(coordinate.longitude), \(coordinate.latitude)")
    }
}


