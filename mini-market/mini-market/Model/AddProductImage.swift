//
//  AddProductImage.swift
//  mini-market
//
//  Created by Sunwoo on 2022/07/08.
//

import Foundation
import UIKit

struct AddProductImage {
    let name: String
    let type: ImageType
    let image: UIImage
    
    var fileName: String {
        return name + type.description
    }
    
    var data: Data? {
        switch type {
        case .jpeg:
            return image.jpegData(compressionQuality: 1)
        case .png:
            return image.pngData()
        }
    }
    
    enum ImageType {
        case jpeg
        case png
        
        var description: String {
            switch self {
            case .jpeg:
                return ".jpeg"
            case .png:
                return ".png"
            }
        }
    }
}
