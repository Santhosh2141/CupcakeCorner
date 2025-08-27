//
//  SwiftUIView.swift
//  CupcakeCorner
//
//  Created by Santhosh Srinivas on 26/08/25.
//

import SwiftUI

struct CupcakeCornerView: View {
    
    // adding StateObject as ios15
    @StateObject private var order = Order()
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    Picker("Select your type", selection: $order.type){
                        ForEach(Order.types.indices, id: \.self){
                            Text(Order.types[$0])
                        }
                    }
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())

                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)

                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                Section{
                    NavigationLink("Delivery Details"){
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
            .toolbar{
                NavigationLink{
                    ContentView()
                } label: {
                    Text("Go to Learning")
                }
            }
        }
    }
}

struct CupcakeCornerView_Previews: PreviewProvider {
    static var previews: some View {
        CupcakeCornerView()
    }
}
