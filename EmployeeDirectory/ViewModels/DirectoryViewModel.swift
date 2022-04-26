//
//  DirectoryViewModel.swift
//  EmployeeDirectory
//
//  Created by Thomas Chin on 4/21/22.
//

import Foundation
import UIKit

class DirectoryViewModel: NSObject {
    
    private(set) var employees: [Employee]
    private var model: Employees = Employees.init(employees: [])
    
    // MARK: Init
        
    override init() {
        employees = model.employees
    }
    
    func addEmployee(newEmployee: Employee) {
        employees.append(newEmployee)
    }
    
    func clearEmployeeList() {
        employees.removeAll()
    }
    
    // MARK: Helper Methods

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
            let decodedData = try JSONDecoder().decode(Employees.self, from: jsonData)
                        
            completionHandler(decodedData.employees, nil)
        } catch let decodeError {
            completionHandler(nil, decodeError)
        }
    }
}
