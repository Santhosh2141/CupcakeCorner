//
//  Order.swift
//  CupcakeCorner
//
//  Created by Santhosh Srinivas on 26/08/25.
//

import Foundation

class Order: Codable, ObservableObject{
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    // adding @Published as ios15 and we can then only access and update the data. in ioa16+ we dont need this
    @Published var type = 0
    @Published var quantity = 3

    @Published var specialRequestEnabled = false{
        didSet{
            if specialRequestEnabled == false{
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        if (name.isEmpty  || streetAddress.isEmpty || city.isEmpty || zip.isEmpty) {
            return false
        }
        return true
    }
    
    var cost: Decimal {
        // $2 per cupcake
        var cost = Decimal(quantity) * 2
        // $0.5 per type
        cost += Decimal(type)/2
        
        if extraFrosting {
            // $1 per cupcake frosting
            cost += Decimal(quantity)
        }
        
        if addSprinkles {
            cost += Decimal(quantity)/2
        }
        return cost
    }
    
    // this is for 106+ solving the _VarName problem
//    enum CodingKeys: String, CodingKey {
//        case _type = "type"
//        case _quantity = "quantity"
//        case _specialRequestEnabled = "specialRequestEnabled"
//        case _extraFrosting = "extraFrosting"
//        case _addSprinkles = "addSprinkles"
//        case _name = "name"
//        case _city = "city"
//        case _streetAddress = "streetAddress"
//        case _zip = "zip"
//    }
    
    enum CodingKeys: CodingKey {
        case type, quantity, specialRequestEnabled, extraFrosting, addSprinkles
        case name, streetAddress, city, zip
    }
    
    // ADDING THESE FOR IOS15 AS PUBLISHED AND CODABLE CANT BE TOGETHER.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        specialRequestEnabled = try container.decode(Bool.self, forKey: .specialRequestEnabled)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(specialRequestEnabled, forKey: .specialRequestEnabled)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
    init() { }
}
