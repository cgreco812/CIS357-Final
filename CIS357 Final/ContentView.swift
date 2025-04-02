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
    @State var pixels: [Double] = Array(repeating:255, count: 28*28)
    @State var guess: Int64 = 0
    @State var displayImage = false
    @State var pixel: CVPixelBuffer?
    
    var body: some View {
        VStack {
            if (displayImage){
                if let buffer = pixel{
                    if let cgImage = buffer.toCGImage() {
                        Image(decorative: cgImage, scale: 1.0)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Text("Failed to create image from pixel buffer")
                    }
                }
            }
            DrawingArea(erasing: $erasing, pixels: $pixels)
                .border(Color.black)
            HStack{
                Button("Guess"){
                    guess = predictNumber(pixels: pixels)
                }
                Button(action: {
                    for index in 0..<pixels.count {
                        pixels[index] = 255
                    }
                }){
                    Image(systemName: "trash")
                }
                Text("Guess is: \(guess)")
            }
        }
        .padding()
    }
    private func predictNumber(pixels: [Double]) -> Int64{
        guard let cgImage = createMNISTImage(from: pixels)else{
            print("Failed to create image from drawing")
            return -1
        }
        pixel = cgImage
        displayImage = true
        let model = try? MNISTClassifier(configuration: .init())
        
        do {
            let prediction = try model?.prediction(image: cgImage)
            
            if let classes = prediction?.labelProbabilities{
                for (num, confidence) in classes{
                    print("Number: \(num) : \(confidence)")
                }
            }
            guard let guess = prediction?.classLabel else{
                return -1
            }
                    
            return guess
        }catch{
            print("error making predictions")
            return -1
        }
        
        
    }
    
    private func createMNISTImage(from pixelArray: [Double], width: Int = 28, height: Int = 28) -> CVPixelBuffer? {
        // Create CVPixelBuffer
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_OneComponent8,  // 8-bit grayscale
            [kCVPixelBufferCGImageCompatibilityKey: true, kCVPixelBufferCGBitmapContextCompatibilityKey: true] as CFDictionary,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            print("Failed to create pixel buffer: \(status)")
            return nil
        }
        
        // Lock the buffer for writing
        CVPixelBufferLockBaseAddress(buffer, [])
        
        // Get a pointer to the pixel data
        guard let baseAddress = CVPixelBufferGetBaseAddress(buffer) else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }
        
        // Create a byte buffer from the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        let bufferPtr = baseAddress.assumingMemoryBound(to: UInt8.self)
        
        // Fill the buffer with our drawing data
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                // Convert 1.0 (white) to 0 and 0.0 (black) to 255
                // MNIST expects white digits on black background
                let pixelValue = UInt8(pixelArray[index])
                //print(pixelValue)
                bufferPtr[y * bytesPerRow + x] = pixelValue
            }
        }
        
        // Unlock the buffer
        CVPixelBufferUnlockBaseAddress(buffer, [])
        
        return buffer
    }
}
#Preview {
    ContentView()
}


