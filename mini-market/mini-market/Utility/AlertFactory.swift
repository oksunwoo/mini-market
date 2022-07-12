//
//  AlertFactory.swift
//  mini-market
//
//  Created by Sunwoo on 2022/07/12.
//

import Foundation
import UIKit

struct AlertFactory {
    func createAlert(style: UIAlertController.Style = .actionSheet, title: String? = nil, message: String? = nil, actions: UIAlertAction...) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        actions.forEach { action in
            alert.addAction(action)
        }
        
        return alert
    }
}
