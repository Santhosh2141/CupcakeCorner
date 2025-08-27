//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Santhosh Srinivas on 26/08/25.
//

import SwiftUI

struct AddressView: View {
    
    // use this in ios17+
//    @Bindable var order: Order
    
    @ObservedObject var order: Order
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Your Name: ", text: $order.name)
                    TextField("City: ", text: $order.city)
                    TextField("Street Address: ", text: $order.streetAddress)
                    TextField("Enter Zip: ", text: $order.zip)
                }
                
                Section{
                    NavigationLink("Checkout"){
                        CHeckoutView(order: order)
                    }
                }
                .disabled(order.hasValidAddress == false)
            }
            .navigationTitle("Delivery Address")
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
