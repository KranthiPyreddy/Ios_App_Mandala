//  UIImage+Mandala.swift
//  Mandala
//  Created by Kranthi Pyreddy on 2/21/21.
import UIKit
//Implementing the ImageResource enumeration
enum ImageResource: String {
    case angry
    case confused
    case crying
    case goofy
    case happy
    case meh
    case sad
    case sleepy
}
extension UIImage {
    //a new convenience initializer that accepts an ImageResource instance
    //Implementing a new UIImage initializer
    convenience init(resource: ImageResource) {
            self.init(named: resource.rawValue)!
        }
}
