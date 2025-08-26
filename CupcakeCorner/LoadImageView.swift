//
//  LoadImageView.swift
//  CupcakeCorner
//
//  Created by Santhosh Srinivas on 25/08/25.
//

import SwiftUI

// @Observable
class User: Codable, ObservableObject{
    // this is for encoding it properly
//    enum CodingKeys: String, CodingKey {
//        case _name = "name"
//    }
    var name = "Santhosh"
}
struct LoadImageView: View {
    
    @State private var userName = ""
    @State private var email = ""
    var disabledForm: Bool {
        (userName.count < 5) || (email.count < 5)
    }
    var body: some View {
        // SwiftUI Doesnt know about the image details.
        // It has to download the image to know the details.
        VStack{
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 5)
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")){ phase in
                // This is a 3 step process.
                // 1. Loaded Image
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                // 2. Error in loading Image
                } else if phase.error != nil {
                    Text("There was an error in loading the image")
                // 3. While Loading Image
                } else{
                    ProgressView()
                }
            }
//            } placeholder: {
//                ProgressView()
//                // this shows a spinner
//            }
                .frame(width: 200, height: 200)
            
            Form{
                Section{
                    TextField("Username", text: $userName)
                    TextField("Email ID", text: $email)
                }
                
                Section{
                    Button{
                        print("Creating account...")
                    } label: {
                        Text("Create Account")
                    }
                }
//                .disabled(userName.isEmpty || email.isEmpty)
                .disabled(disabledForm)
            }
            Button{
                encodeTaylor()
            } label: {
                Text("Encode Taylor")
            }
        }
    }
    
    func encodeTaylor(){
        let data = try! JSONEncoder().encode(User())
        let str = String(decoding: data, as: UTF8.self)
        print(str)
        // if we use an @Observable for the class instead od an observableObject. we get a dict
        // {"_name":"Santhosh","_$observationRegistrar":{}}
        
    }
}

struct LoadImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadImageView()
    }
}
