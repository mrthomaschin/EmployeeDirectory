//
//  Extensions.swift
//  EmployeeDirectory
//
//  Created by Thomas Chin on 4/26/22.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("[Extensions] Error: invalid url")
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            print("[Extensions] Image found in cache")
            self.image = imageFromCache
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    print("[Extensions] Image not found in cache, adding to cache")
                    self?.image = loadedImage
                    imageCache.setObject(loadedImage, forKey: url as AnyObject)
                }
            }
        }
    }
}
