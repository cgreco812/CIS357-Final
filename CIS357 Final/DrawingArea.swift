//
//  DrawingArea.swift
//  CIS357 Final
//
//  Created by user940079 on 3/31/25.
//
import SwiftUI
struct DrawingArea: View {
    @Binding var erasing : Bool
    @Binding var pixels: [Double]
    
    @State var frames : [CGRect] = Array(repeating: CGRect(), count:  28 * 28)
    
    let columns = Array(repeating: GridItem(spacing:0), count: 28)
    
    var swipeGesture : some Gesture{
        DragGesture(minimumDistance: 0, coordinateSpace:    .global)
            .onChanged{ value in
                if let match = self.frames.firstIndex(where: {$0.contains((value.location))}) {
                    if erasing {
                        pixels[match] = 255
                    }else{
                        pixels[match] = 0
                    }
                }
            }
    }
    var body: some View {
        LazyVGrid( columns: columns, spacing: 0){
            ForEach(0..<pixels.count, id: \.self) { index in
                Rectangle()
                    .foregroundColor(Color(white:pixels[index]))
                    .overlay(
                        GeometryReader{ geometry in
                            Color.clear
                                .onAppear{
                                    frames[index] = geometry.frame(in: .global)
                                }
                        }
                    )
            }
        }
        .gesture(swipeGesture)
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity, alignment: .center)
        
    }
}


