//
//  UIExtension.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 17/05/24.
//

import Foundation
import UIKit

extension UIViewController {
    var topMostVC: UIViewController? {
        return UIApplication.topViewController()
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        return base
    }
}
