// 
//  MapPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/15/23.
//

import CoreLocation
import XCoordinator
import MapKit

protocol MapPresenterProtocol: AnyObject {
}

final class MapPresenter: MapPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: MapViewControllerProtocol?
    private let router: WeakRouter<EventsRoute>
    private let locationService: LocationService
    private let latitude: Double
    private let longitude: Double
    
    private var lastUsedProps: MapViewControllerProps?
    private var startMapItem: MKMapItem?
    private var destinationMapItem: MKMapItem?

    // MARK: - Initialize
    init(view: MapViewControllerProtocol,
         router: WeakRouter<EventsRoute>,
         locationService: LocationService,
         latitude: Double,
         longitude: Double
    ) {
        self.view = view
        self.router = router
        self.locationService = locationService
        self.latitude = latitude
        self.longitude = longitude
        
        initialize()
    }
    
    func initialize() {
        Task {
            let currentUserLocation = await locationService.getUserLocation()
            let startPoint = CLLocationCoordinate2D(
                latitude: currentUserLocation?.coordinate.latitude ?? 0,
                longitude: currentUserLocation?.coordinate.longitude ?? 0
            )
            let destinationPoint = CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            )
            
            let startPlacemark = MKPlacemark(coordinate: startPoint, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destinationPoint, addressDictionary: nil)
            
            startMapItem = MKMapItem(placemark: startPlacemark)
            destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            let startAnnotation = await generateAnnotation(with: startPoint)
            let destinationAnnotation = await generateAnnotation(with: destinationPoint)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = startMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            
            let response = try? await directions.calculate()
            
            let props = MapViewControllerProps(
                annotations: [startAnnotation, destinationAnnotation],
                route: response?.routes[0],
                handleTapOnCloseCompletion: dismiss
            )
            
            DispatchQueue.main.async {
                self.view?.render(with: props)
            }
        }
    }
}

// MARK: - Private Methods
private extension MapPresenter {
    
    func generateAnnotation(with coordinates: CLLocationCoordinate2D) async -> MKPointAnnotation {
        let convertedCoordinates = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let startAnnotation = MKPointAnnotation()
        let startAnnotationName = await locationService.getFullPlacemark(location: convertedCoordinates)
        startAnnotation.title = startAnnotationName?.name ?? ""
        startAnnotation.coordinate = coordinates
        return startAnnotation
    }
    
    func dismiss() {
        router.trigger(.dismiss)
    }
}
