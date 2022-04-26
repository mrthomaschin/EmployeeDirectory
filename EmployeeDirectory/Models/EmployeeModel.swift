//
//  EmployeeModel.swift
//  EmployeeDirectory
//
//  Created by Thomas Chin on 4/21/22.
//

import Foundation

struct Employee: Codable {
    let uuid, fullName, phoneNumber, emailAddress, biography, smallPhotoUrl, largePhotoUrl, teamName, employeeType: String
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography = "biography"
        case smallPhotoUrl = "photo_url_small"
        case largePhotoUrl = "photo_url_large"
        case teamName = "team"
        case employeeType = "employee_type"
    }
}

