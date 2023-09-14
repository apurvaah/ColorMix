//
//  ColorPointPickerView.swift
//  Color Mix
//
//  Created by Apurva H on 9/13/23.
//

import SwiftUI
import UIKit

struct ColorPointPickerView: View {
    @State private var numberOfPoints = ""
    @State private var points: [CGPoint] = []
    @Binding var selectedImage: UIImage?
    @State private var selectedColors: Set<UIColor> = []
    @State private var isAddingPoint = false
    @State private var isConfirmColorsViewPresented = false
    @State private var finalHexValues: [UIColor] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Number of Color Points:")
                TextField("Enter a number", text: $numberOfPoints)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()

                if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 200, height: 200)
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
                                        if points.count < (Int(numberOfPoints) ?? 0) && isAddingPoint {
                                            points.append(value.location)
                                            if let color = image.pixelColor(at: value.location) {
                                                selectedColors.insert(color)
                                            }
                                            isAddingPoint = false
                                        }
                                    }
                            )

                    HStack {
                        VStack(alignment: .leading){
                            Button(action: {
                                if points.count < (Int(numberOfPoints) ?? 0) {
                                    isAddingPoint = true
                                }
                            }) {
                                Text("Add Point")
                                    .padding()
                                    .background(points.count == (Int(numberOfPoints)) ? Color.gray: (isAddingPoint ? Color.indigo : Color.blue))
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }

                        VStack(alignment: .trailing){
                            Button(action: {
                                // Remove the last added point and its corresponding color
                                if !points.isEmpty, let lastColor = selectedColors.max(by: { color1, color2 in
                                    let red1 = color1.cgColor.components?[0] ?? 0.0
                                    let red2 = color2.cgColor.components?[0] ?? 0.0
                                    return red1 < red2
                                }) {
                                    points.removeLast()
                                    selectedColors.remove(lastColor)
                                    print("Removed Color")
                                }
                            }) {
                                Text("Remove Last Point")
                                    .padding()
                                    .background(points.isEmpty ? Color.gray : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            .disabled(points.isEmpty)
                        }
                    }
                    .padding(.top)

                    HStack {
                        Button(action: {
                            // Clear all points and hex values
                            points.removeAll()
                            selectedColors.removeAll()
                        }) {
                            Text("Redo")
                                .padding()
                                .background(points.isEmpty ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }

                        Button(action: {
                            // Call the ConfirmColorsView by setting the flag
                            isConfirmColorsViewPresented = true
                            finalHexValues = Array(selectedColors)
                        }) {
                            Text("Confirm")
                                .padding()
                                .background(points.count == (Int(numberOfPoints)) ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                    .padding(.top)

                    if !selectedColors.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Selected Colors:")
                                .font(.headline)

                            ForEach(Array(selectedColors), id: \.self) { color in
                                Color(color)
                                    .frame(width: 30, height: 30) // Adjust the size as needed
                            }
                        }
                        .padding()
                    }

                } else {
                    Text("No Image Selected")
                }
            }
            .sheet(isPresented: $isConfirmColorsViewPresented) {
                ConfirmColorsView(selectedColors: $finalHexValues)
            }
        }
    }
}

extension UIImage {
    func pixelColor(at point: CGPoint) -> UIColor? {
            guard let cgImage = cgImage, let imageData = cgImage.dataProvider?.data else {
                return nil
            }
            
            let data: UnsafePointer<UInt8> = CFDataGetBytePtr(imageData)
            let scale = UIScreen.main.scale
            let x = Int(point.x * scale)
            let y = Int(point.y * scale)
            let width = cgImage.width
            let bytesPerPixel = cgImage.bitsPerPixel / 8
            
            let index = y * width + x
            let byteIndex = index * bytesPerPixel
            
            let red = CGFloat(data[byteIndex]) / 255.0
            let green = CGFloat(data[byteIndex + 1]) / 255.0
            let blue = CGFloat(data[byteIndex + 2]) / 255.0
            let alpha = CGFloat(data[byteIndex + 3]) / 255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
}

struct ColorPointPickerView_Previews: PreviewProvider {
    @State private static var selectedImage: UIImage? = UIImage(named: "SampleColorPickerImage")
    static var previews: some View {
        ColorPointPickerView(selectedImage: $selectedImage)
    }
}
