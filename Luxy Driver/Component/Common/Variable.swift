//
//  Variable.swift
//  Shif
//
//  Created by Techimmense Software Solutions on 07/10/23.
//

import Foundation
import UIKit

var globalUserName          =       k.userDefault.value(forKey: "user_name")
var globalUserImage         =       k.userDefault.value(forKey: "user_image")

var localTimeZoneIdentifier: String { return
    TimeZone.current.identifier }

var dictSignup:[String: AnyObject] = [:]

var dictSignImg:[String : UIImage] = [:]

var logout: Bool = true
