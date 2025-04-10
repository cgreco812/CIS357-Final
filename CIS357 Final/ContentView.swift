//
//  ContentView.swift
//  CIS357 Final
//
//  Created by user940079 on 3/31/25.
//
import SwiftUI
import CoreML

struct ContentView: View {
    @State var erasing = false
    @State var pixels: [Double] = Array(repeating: 255, count: 28*28)
    @State var guess: Int64 = 0
    @State var displayImage = false
    @State var pixel: CVPixelBuffer?
    @State var targetNumber: Int = 0
    @State var showingAlert = false
    @State var highScore: Double = 0.0
    @State var score: Double = 0.0
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Draw a perfect \(targetNumber)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                DrawingArea(erasing: $erasing, pixels: $pixels)
                    .border(Color.black)
                    .frame(width: 300, height: 300)
                
                HStack {
                    Button(action: { erasing.toggle() }) {
                        if erasing {
                            Image(systemName: "eraser.fill")
                        } else {
                            Image(systemName: "eraser")
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button("Attempt") {
                        guess = predictNumber(pixels: pixels)
                        showingAlert = true
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: clear) {
                        Image(systemName: "trash")
                    }
                    .padding()
                }
                
                Text("Guess is: \(guess)")
                    .font(.title2)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Draw Number")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: HomeScreen()) {
                        Image(systemName: "house.fill")
                    }
                }
            }
            .alert("You scored: \(score)", isPresented: $showingAlert) {
                Button("OK") {
                    targetNumber = generateNumber()
                    clear()
                }
            }
        }
    }
    
    private func clear() {
        pixels = Array(repeating: 255, count: 28*28)
    }
    
    private func generateNumber() -> Int {
        return Int.random(in: 0..<10)
    }
    
    private func predictNumber(pixels: [Double]) -> Int64 {
        guard let cgImage = createMNISTImage(from: pixels) else {
            print("Failed to create image from drawing")
            return -1
        }
        
        pixel = cgImage
        displayImage = true
        let model = try? MNISTClassifier(configuration: .init())
        
        do {
            let prediction = try model?.prediction(image: cgImage)
            
            if let classes = prediction?.labelProbabilities {
                for (num, confidence) in classes {
                    print("Number: \(num) : \(confidence)")
                }
                let decimalScore = classes[Int64(targetNumber)]
                score = (decimalScore ?? 0) * 100
            }
            
            return prediction?.classLabel ?? -1
        } catch {
            print("Error making predictions: \(error)")
            return -1
        }
    }
    
    private func createMNISTImage(from pixelArray: [Double], width: Int = 28, height: Int = 28) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_OneComponent8,
            [kCVPixelBufferCGImageCompatibilityKey: true,
             kCVPixelBufferCGBitmapContextCompatibilityKey: true] as CFDictionary,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            print("Failed to create pixel buffer: \(status)")
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
        
        guard let baseAddress = CVPixelBufferGetBaseAddress(buffer) else {
            return nil
        }
        
        let bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        let bufferPtr = baseAddress.assumingMemoryBound(to: UInt8.self)
        
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                var pix = pixelArray[index]
                pix = pix == 0 ? 255 : 0
                bufferPtr[y * bytesPerRow + x] = UInt8(pix)
            }
        }
        
        return buffer
    }
}

#Preview {
    ContentView()
}
