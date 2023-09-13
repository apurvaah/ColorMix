//
//  ColorPointPickerView.swift
//  Color Mix
//
//  Created by Apurva H on 9/13/23.
//

import SwiftUI

struct ColorPointPickerView: View {
    @State private var numberOfPoints = ""
    @State private var points: [CGPoint] = []
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            Text("Number of Color Points:")
            TextField("Enter a number", text: $numberOfPoints)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            if let image = selectedImage {
                Image(uiImage: image) // Use uiImage: to safely unwrap the optional UIImage
                    .resizable()
                    .frame(width: 200, height: 200) // Adjust image size as needed
                    .overlay(
                        ZStack {
                            ForEach(0..<min(points.count, Int(numberOfPoints) ?? 0), id: \.self) { index in
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .position(points[index])
                            }
                        }
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if points.count < (Int(numberOfPoints) ?? 0) {
                                    points.append(value.location)
                                }
                            }
                    )
            } else {
                Text("No Image Selected")
            }
        }
    }
}


struct ColorPointPickerView_Previews: PreviewProvider {
    @State private static var selectedImage: UIImage? = UIImage(named: "Paintbrush")
    static var previews: some View {
        ColorPointPickerView(selectedImage: $selectedImage)
    }
}
