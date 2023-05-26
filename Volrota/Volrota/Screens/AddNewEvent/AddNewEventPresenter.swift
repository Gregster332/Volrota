// 
//  AddNewEventPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/25/23.
//

import PhotosUI
import XCoordinator
import GeneralServices
import Utils

protocol AddNewEventPresenterProtocol: AnyObject {
    var newEventTitle: String? { get set }
    var selectedImage: UIImage? { get set }
    var startDate: Date { get set }
    var endDate: Date { get set }
    var selectedLocation: LocationModel { get set }
    
    func handleTapOnSetImage(photoPicker: PHPickerViewController)
    func findLocations(by query: String?)
}

final class AddNewEventPresenter: AddNewEventPresenterProtocol {
    
    // MARK: - Properties
    var newEventTitle: String? = nil
    var startDate: Date = Date()
    var endDate: Date = Date()
    var selectedImage: UIImage? = nil {
        didSet {
            view?.didChangeImage()
        }
    }
    var selectedLocation: LocationModel = LocationModel(title: "", coordinates: nil)
    
    private weak var view: AddNewEventViewControllerProtocol?
    private let router: WeakRouter<EventsRoute>
    private let storage: FirebaseStorage
    private let database: FirebaseDatabse
    private let locationService: LocationService
    
    // MARK: - Initialize
    init(
        view: AddNewEventViewControllerProtocol,
        router: WeakRouter<EventsRoute>,
        storage: FirebaseStorage,
        database: FirebaseDatabse,
        locationService: LocationService
    ) {
        self.view = view
        self.router = router
        self.storage = storage
        self.database = database
        self.locationService = locationService
        
        initilize()
    }
    
    func initilize() {
        let props = AddNewEventViewControllerProps(
            sections: AddNewEventViewControllerProps.Section.allCases,
            didTapOnSaveButtonCompletion: saveNewEvent
        )
        view?.render(with: props)
    }
    
    func handleTapOnSetImage(photoPicker: PHPickerViewController) {
        router.trigger(.photoPicker(photoPicker))
    }
    
    func findLocations(by query: String?) {
        guard let query = query else {
            return
        }
        locationService.findLocation(by: query) { locations in
            self.view?.makeLocationsList(locations: locations)
        }
    }
}

// MARK: - Private Methods
private extension AddNewEventPresenter {
    func validate() -> Bool {
        if let newEventTitle = newEventTitle {
            if newEventTitle.isEmpty {
                presentWarningAlert(with: Strings.AddNewEvent.titleWarning)
                return false
            }
            
            if selectedImage == nil {
                presentWarningAlert(with: Strings.AddNewEvent.imageWarning)
                return false
            }
            
            if startDate <= Date() {
                presentWarningAlert(with: Strings.AddNewEvent.startDateWarning)
                return false
            }
            
            if endDate <= Date() {
                presentWarningAlert(with: Strings.AddNewEvent.endDateWarning)
                return false
            }
            
            return true
        } else {
            presentWarningAlert(with: Strings.AddNewEvent.titleWarning)
            return false
        }
    }
    
    func saveNewEvent() {
        let photoUUID = UUID().uuidString
        Task {
            do {
                if validate() {
                    if let selectedImage = selectedImage,
                       let title = newEventTitle,
                       let coordinates = selectedLocation.coordinates {
                        
                        let imageUrl = try await storage.uploadPhoto(
                            with: photoUUID,
                            name: "",
                            image: selectedImage)
                        try await database.addNewEvent(
                            EventsModel.EventModel(
                                eventTitle: title,
                                eventImageURL: imageUrl,
                                startDate: startDate,
                                endDate: endDate,
                                lat: coordinates.latitude,
                                long: coordinates.longitude,
                                eventId: photoUUID
                            ),
                            with: photoUUID
                        )
                    } else {
                        return
                    }
                } else {
                    return
                }
            } catch {
                print(error)
            }
        }
    }
    
    func presentWarningAlert(with title: String) {
        let cancelAction = Alert.Action(title: "Ok", style: .cancel, action: nil)
        let alert = Alert(title: title, message: nil, style: .alert, actions: [cancelAction])
        DispatchQueue.main.async {
            self.router.trigger(.alert(alert))
        }
    }
}
