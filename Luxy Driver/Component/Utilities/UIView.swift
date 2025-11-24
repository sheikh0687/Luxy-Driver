//
//  UIView.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 03/06/24.
//

import Foundation

public extension UIView {
    /**
     Captures view and subviews in an image
     */
    func snapshotViewHierarchy() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return copied
    }
}
