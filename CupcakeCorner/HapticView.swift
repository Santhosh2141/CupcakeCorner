//
//  HapticView.swift
//  CupcakeCorner
//
//  Created by Santhosh Srinivas on 26/08/25.
//

import CoreHaptics
import SwiftUI

struct HapticView: View {
    @State private var counter = 0
    @State private var engine: CHHapticEngine?
    var body: some View {
        VStack{
            Button("Tap Count: \(counter)"){
                counter += 1
            }
            Button("Tap Me", action: complexSuccess)
                .onAppear(perform: prepareHaptics)
        }
        
//        .sensoryFeedback(.increase, trigger: counter)
//        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: counter)
        // this is a customizable way
        // heave objects hitting them hard
//        .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: counter)


    }
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            // you need to create the Haptic engine and start it before performing any action for it to work. so we put it in the onAppear
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,sharpness], relativeTime: 0)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

struct HapticView_Previews: PreviewProvider {
    static var previews: some View {
        HapticView()
    }
}
