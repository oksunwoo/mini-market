//
//  ImageCacheManager.swift
//  mini-market
//
//  Created by Sunwoo on 2022/06/20.
//

import Foundation
import UIKit

struct ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() { }
}
