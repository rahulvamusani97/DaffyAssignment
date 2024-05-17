//
//  UIUtility.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 17/05/24.
//

import Foundation
import UIKit

func showAlert(title: String = "You Seems Offline",
                          message: String = "Make sure to connect to Wi-Fi or mobile data is On and try again") {
    let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel))
    DispatchQueue.main.async {
        alertVC.topMostVC?.present(alertVC, animated: true)
    }
}
