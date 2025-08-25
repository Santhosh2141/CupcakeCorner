//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Santhosh Srinivas on 25/08/25.
//

import SwiftUI

struct Response: Codable{
    var results: [Result]
}

struct Result: Codable{
    var trackId: Int
    var trackName: String
    var collectionName: String
}
struct ContentView: View {
    @State private var results = [Result]()
    var body: some View {
        NavigationStack{
                List(results, id: \.trackId){ item in
                    VStack(alignment: .leading){
                        Text(item.trackName)
                            .font(.title2)
                        Text(item.collectionName)
                            .font(.headline)
                    }
                }
    //        }
    //        .padding()
            .task {
                await loadData()
            }
            .toolbar{
                NavigationLink{
                    LoadImageView()
                } label: {
                    Text("Load Image View")
                }
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("invalid URL")
            return
        }
        
        do {
//            takes a URL and returns the Data object at that URL
            let (data,_) = try await URLSession.shared.data(from: url)
            // returns a tuple, thee data we want and metaData which is how the data has come. so we say we take the data and discard the rest.
            if let decodedResp = try? JSONDecoder().decode(Response.self, from: data){
                results = decodedResp.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
