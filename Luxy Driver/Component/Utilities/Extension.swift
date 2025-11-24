//
//  Extension.swift
//  Shif
//
//  Created by Techimmense Software Solutions on 05/10/23.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}


extension UIView {
  
  @IBInspectable
  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }
  
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable
  var borderColor: UIColor? {
    get {
      if let color = layer.borderColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.borderColor = color.cgColor
      } else {
        layer.borderColor = nil
      }
    }
  }
  
  @IBInspectable
  var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable
  var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }
  
  @IBInspectable
  var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable
  var shadowColor: UIColor? {
    get {
      if let color = layer.shadowColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.shadowColor = color.cgColor
      } else {
        layer.shadowColor = nil
      }
    }
  }
}

extension UITextView {
    
    func addHint(_ hint: String) {
        let hintLabel = UILabel()
        hintLabel.text = hint
        hintLabel.font = self.font
        hintLabel.textColor = UIColor.lightGray
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(hintLabel)
        
        NSLayoutConstraint.activate([
            hintLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            hintLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
            // Add additional constraints as needed
        ])
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: nil, queue: nil) { [weak self] _ in
            self?.updateHintVisibility(hintLabel)
        }
        
        updateHintVisibility(hintLabel)
    }
    
    private func updateHintVisibility(_ hintLabel: UILabel) {
        hintLabel.isHidden = !self.text.isEmpty
    }
}


extension UILabel {
    func setColor(_ label: UILabel) {
        let strNumber: NSString = "I have read the Terms & Conditions and accept them" as NSString
        let range = (strNumber).range(of: "Terms & Conditions")
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: hexStringToUIColor(hex: "#08A48C") , range: range)
        label.attributedText = attribute
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}

extension String {
    static func GetNoonTime() -> String {
        let date = Date()
        // Make Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh a"
        // hh for hour mm for minutes and a will show you AM or PM
        let str: String = dateFormatter.string(from: date)
        print("\(str)")
        // Sperate str by space i.e. you will get time and AM/PM at index 0 and 1 respectively
        var array: [Any] = str.components(separatedBy: " ")
        
        // Now you can check it by 12. If < 12 means Its morning > 12 means its evening or night
        
        var message: String = ""
        let timeInHour: String = array[0] as! String
        let am_pm: String = array[1] as! String
        
        if CInt(timeInHour)! < 12 && (am_pm == "AM") {
            message = "Good Morning"
        }
        else if CInt(timeInHour)! <= 4 && (am_pm == "PM") {
            message = "Good Afternoon"
        }
        else if CInt(timeInHour) == 12 && (am_pm == "PM") {
            message = "Good Afternoon"
        }
        else if CInt(timeInHour)! > 4 && (am_pm == "PM") {
            message = "Good Night"
        }
        print("\(message)")

        return message
    }
    
    var htmlAttributedString3 : NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do{
            return try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html,.characterEncoding : String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return nil
        }
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension UIView {
  func comingFromRight(containerView: UIView) {
    let offset = CGPoint(x: containerView.frame.maxX, y: 0)
    let x: CGFloat = 0, y: CGFloat = 0
    self.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
    self.isHidden = false
    UIView.animate(
        withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
        options: .curveEaseOut, animations: {
            self.transform = .identity
            self.alpha = 1
    })

} }
