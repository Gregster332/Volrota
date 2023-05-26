//
//  ProfileRoute.swift
//  ProfileModule
//
//  Created by Greg Zenkov on 5/7/23.
//

import XCoordinator
import PhotosUI
import Utils

public enum ProfileRoute: Route {
    case profile
    case dismiss
    case alert(Alert)
    case photoPicker(PHPickerViewController)
    case auth
}
