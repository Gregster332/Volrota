// 
//  ActualsPresenter.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/9/23.
//

import Foundation
import XCoordinator

protocol ActualsPresenterProtocol: AnyObject {
    func initialize()
}

final class ActualsPresenter: ActualsPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: ActualsViewControllerProtocol?
    private let router: WeakRouter<MainRoute>
    private let databaseService: FirebaseDatabse
    private var actuals: [GlobalModel.ActualModel] = []

    // MARK: - Initialize
    init(
        view: ActualsViewControllerProtocol,
        router: WeakRouter<MainRoute>,
        databaseService: FirebaseDatabse
    ) {
        self.view = view
        self.router = router
        self.databaseService = databaseService
    }
    
    func initialize() {
        Task {
            do {
                let actuals = try await databaseService.getActuals(nil)
                self.actuals = actuals
                let cells = actuals.map {
                    return ActualsViewControllerProps.ActualProps(
                        title: $0.title,
                        imageUrl: $0.imageUrl,
                        cityName: $0.cityName
                    )
                }
                
                let props = ActualsViewControllerProps(
                    actuals: cells,
                    didTapOnCellCompletion: didTapOnCell
                )
                
                DispatchQueue.main.async {
                    self.view?.render(with: props)
                }
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Private Methods

private extension ActualsPresenter {
    
    func didTapOnCell(with indexPath: IndexPath) {
        let item = actuals[indexPath.item]
        router.trigger(.actualDetail(item))
    }
}
