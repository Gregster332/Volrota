// 
//  MapViewController.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/15/23.
//

import MapKit

struct MapViewControllerProps {
    let annotations: [MKPointAnnotation]
    var route: MKRoute?
    let handleTapOnCloseCompletion: (() -> Void)?
}

protocol MapViewControllerProtocol: AnyObject {
    func render(with props: MapViewControllerProps)
}

final class MapViewController: UIViewController, MapViewControllerProtocol {
    
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: MapPresenterProtocol!
    // swiftlint:enable implicitly_unwrapped_optional
    private var annotations: [MKPointAnnotation] = []
    private var handleTapOnCloseCompletion: (() -> Void)?
    
    // MARK: - Views
    private let mapView = MKMapView()
    private let closeButton = UIButton(type: .close)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Methods
    func render(with props: MapViewControllerProps) {
        handleTapOnCloseCompletion = props.handleTapOnCloseCompletion
        mapView.showAnnotations(props.annotations, animated: true)
        
        if let route = props.route {
            mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}

// MARK: - Private Methods

private extension MapViewController {
    
    func setupView() {
        
        view.do {
            $0.backgroundColor = .white
        }
        
        mapView.do {
            $0.delegate = self
            $0.showsCompass = false
            $0.showsScale = true
            $0.showsUserLocation = true
        }
        
        closeButton.do {
            $0.setImage(Images.close.image, for: .normal)
            $0.addTarget(
                self,
                action: #selector(handleTapOnClose),
                for: .touchUpInside
            )
        }
    }
    
    func setupConstraints() {
        view.addSubview(mapView)
        view.addSubview(closeButton)
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.trailing.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - UI Actions
    @objc func handleTapOnClose() {
        handleTapOnCloseCompletion?()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
