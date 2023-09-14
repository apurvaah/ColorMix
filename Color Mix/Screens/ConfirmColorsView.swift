//
//  ConfirmColorsView.swift
//  Color Mix
//
//  Created by Apurva H on 9/13/23.
//

import SwiftUI

struct ConfirmColorsView: View {
    @Binding var selectedColors: [UIColor] // Use UIColor instead of String
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Confirm if these are the colors you have")
                        .foregroundColor(.black)
                }
                
                List(selectedColors, id: \.self) { color in
                    ColorCircleView(color: color, isSelected: selectedColors.contains(color)) {
                        // Toggle the selected state of the color
                        if selectedColors.contains(color) {
                            selectedColors.removeAll { $0 == color }
                        } else {
                            selectedColors.append(color)
                        }
                    }
                }
                
                // Confirm and Cancel buttons
                HStack {
                    Button("Confirm") {
                        // Handle the confirm action (e.g., pass selectedColors to another function)
                        print("Selected colors: \(selectedColors)")
                        // You can perform any other actions you need here
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    
                    Button("Cancel") {
                        // Handle the cancel action (e.g., dismiss the view)
                        // You can also clear the selectedColors array here if needed.
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }
            }
        }
    }
}

struct ColorCircleView: View {
    var color: UIColor // Use UIColor instead of String
    var isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(color)) // Use the passed UIColor directly
                .frame(width: 60, height: 60) // Adjust the frame size as needed

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
            }
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct ConfirmColorsView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a binding to an array of UIColor with the three colors
        let selectedColorsBinding = Binding<[UIColor]>(
            get: {
                [
                    UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1), // Crimson
                    UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1), // Sky Blue
                    UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1) // Lavender
                ]
            },
            set: { _ in }
        )

        // Pass the selectedColors binding when creating ConfirmColorsView
        return ConfirmColorsView(selectedColors: selectedColorsBinding)
    }
}
