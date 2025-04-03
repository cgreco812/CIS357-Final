//
//  ScoreAlert.swift
//  CIS357 Final
//
//  Created by Charles F. Greco on 4/3/25.
//

import SwiftUI

struct ScoreAlert:View {
    @Binding var highScore: Double
    @Binding var score: Double
    
    var body: some View {
        VStack{
            Text("High Score: \(highScore)")
            Text("Score: \(score)")
        }
    }
}
#Preview {
    @Previewable @State var highScore = 2.0
    @Previewable @State var score = 0.6
    ScoreAlert(highScore: $highScore, score: $score)
}
