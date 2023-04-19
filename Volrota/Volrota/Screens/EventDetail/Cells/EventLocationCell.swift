//
//  EventLocationCell.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/14/23.
//

import MapKit

class EventLocationCell: UICollectionViewCell {
    
    private let mapView = MKMapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    func render(with props: EventDetailViewControllerProps.LocationSection) {
        DispatchQueue.main.async {
            let point = CLLocationCoordinate2D(
                latitude: props.lat,
                longitude: props.long
            )
            
            let placemark = MKPlacemark(coordinate: point, addressDictionary: nil)
            let annotation = MKPointAnnotation()
            annotation.coordinate = point
            self.mapView.showAnnotations([annotation], animated: true)
        }
    }
}

private extension EventLocationCell {
    
    func setupView() {
        
        contentView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
        }
        
        mapView.do {
            $0.isScrollEnabled = false
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
