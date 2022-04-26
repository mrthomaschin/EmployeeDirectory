//
//  DirectoryViewModel.swift
//  EmployeeDirectory
//
//  Created by Thomas Chin on 4/21/22.
//

import Foundation
import Combine
import UIKit

class DirectoryViewModel: NSObject {
    
    @Published private(set) var employees: [Employee]
    
    var model: Employees = Employees.init(employees: [])
        
    override init() {
        employees = model.employees
    }
    
    
    func addEmployee(newEmployee: Employee) {
        employees.append(newEmployee)
    }
    
    func clearEmployeeList() {
        employees.removeAll()
    }

    func fetchEmployeeData(url: String, completionHandler: @escaping ([Employee]?, Error?) -> Void) {
        loadJson(urlString: url) { (result) in
            switch result {
            case .success(let data):
                self.parseData(jsonData: data, completionHandler: completionHandler)
            case .failure(let error):
                print(error)
                completionHandler(nil, error)
            }
        }
    }
    
    func loadJson(urlString: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            }
            
            if let data = data {
                completionHandler(.success(data))
            }
        }
        
        urlSession.resume()
    }
    
    func parseData(jsonData: Data, completionHandler: @escaping ([Employee]?, Error?) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(Employees.self,
                                                       from: jsonData)
                        
            completionHandler(decodedData.employees, nil)
        } catch let decodeError {
            completionHandler(nil, decodeError)
        }
    }
}

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                    imageCache.setObject(loadedImage, forKey: url as AnyObject)
                }
            }
        }
    }
}

