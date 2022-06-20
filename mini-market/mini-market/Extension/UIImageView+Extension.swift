//
//  UIImageView+Extension.swift
//  mini-market
//
//  Created by Sunwoo on 2022/06/20.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(url: String) {
        let cacheKey = NSString(string: url)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: url), let imageData = try? Data(contentsOf: imageURL), let loadedImage = UIImage(data: imageData) else {
                return
            }
            
            ImageCacheManager.shared.setObject(loadedImage, forKey: cacheKey)
            DispatchQueue.main.async {
                self.image = loadedImage
            }
            
        }
    }
}
