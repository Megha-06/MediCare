//
//  UIViewExtension + shadow.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import Foundation
import UIKit
extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 2
    }
}
extension UIViewController{
    
    private struct AssociatedKeys {
            static var activityIndicator = "activityIndicator"
        }
        
        private var activityIndicator: UIActivityIndicatorView? {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? UIActivityIndicatorView
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        
        func setupActivityIndicator() {
            if activityIndicator == nil {
                let indicator = UIActivityIndicatorView(style: .large)
                indicator.center = self.view.center
                indicator.hidesWhenStopped = true
                self.view.addSubview(indicator)
                self.activityIndicator = indicator
            }
        }
        
        func showActivityIndicator() {
            DispatchQueue.main.async {
                self.setupActivityIndicator()
                self.activityIndicator?.startAnimating()
            }
        }
        
        func hideActivityIndicator() {
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
            }
        }
}
