//
//  UIImage+Extension.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/26/23.
//

import UIKit

extension UIImage {
    func applyFilterForImage(filter: FilterType, completion: @escaping (UIImage?) -> Void) {
        let context = CIContext()
        let currentFilter = filter.filter
        let ciImage = CIImage(image: self)
        currentFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        switch filter {
        case .vignette:
            currentFilter?.setValue(0.9, forKey: kCIInputIntensityKey)
        default:
            break
        }
        
        guard let outputImage = currentFilter?.outputImage else {
            completion(nil)
            return
        }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            completion(uiImage)
        } else {
            completion(nil)
        }
    }
}
