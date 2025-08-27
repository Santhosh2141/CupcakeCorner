//
//  CHeckoutView.swift
//  CupcakeCorner
//
//  Created by Santhosh Srinivas on 27/08/25.
//

import SwiftUI

struct CHeckoutView: View {
    var order: Order
    
    @State private var confirmationMsg = ""
    @State private var orderDetails = ""
    @State private var showingMsg = false
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg")){ image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 223)
                
                Text("Your Total Cost is: \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                Button("Place Order"){
                    // Button does not take asynchronous functions so we use Task
                    Task{
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("CheckOut")
        .navigationBarTitleDisplayMode(.inline)
//        The scrollBounceBehavior() modifier helps us disable that bounce when there is nothing to scroll.
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank You for ordering", isPresented: $showingMsg){
            Button("OK"){ }
        } message: {
            Text("\(confirmationMsg) \n \(orderDetails)")
        }
    }
    
    func placeOrder() async {
        // adding this as REQRES doesnt work anymore
        // so creating custom using Beeceptor
//        struct OrderResponse: Codable {
//            let status: String?
//            let message: String
//            let orderId: String
//        }
        
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode")
            return
        }
//         it lets us send any data we want, and will automatically send it back. This is a great way of prototyping network code, because you’ll get real data back from whatever you send.
//        let url = URL(string: "https://cupcakes-api.free.beeceptor.com")!
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        // this is a forced unwrap. even if its optional return a non optional
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            
            confirmationMsg = "Your order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            
//            confirmationMsg = "Your \(decodedOrder.message)\nOrder ID: \(decodedOrder.orderId)"
//
//            orderDetails = "\(order.quantity) x \(Order.types[order.type].lowercased()) cupcakes is on its way!"
            showingMsg = true
        } catch {
            confirmationMsg = "Checkout failed: \(error.localizedDescription)"
            showingMsg = true
        }
        
//        p String(decoding: encoded, as: UTF8.self). That converts our encoded data back to a string, and prints it out. This gives a lot of underscore var names given by ObservableObject
    }
}

struct CHeckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CHeckoutView(order: Order())
    }
}
