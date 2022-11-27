//
//  ContentView.swift
//  KnapsackApp
//
//  Created by Rafał on 24/11/2022.
//

import SwiftUI
import Charts


struct ResultView: View {
    
    @EnvironmentObject var appVM: AppVM
    
    var body: some View {
            VStack {
                Text("Best value: ")
                Text("\(appVM.bestValue)")
                    .fontWeight(.bold)
                Text("Best value weight: ")
                Text("\(appVM.bestValueWeight)")
                    .fontWeight(.bold)
                Text("Best value chromosome: ")
                Text("[" + appVM.bestFitnessAsChromosome + "]")
                    .fontWeight(.bold)
                Text("Weight: ")
                Text(appVM.makeStringFromArray(array: appVM.WEIGHT))
                    .fontWeight(.bold)
                Text("Value: ")
                Text(appVM.makeStringFromArray(array: appVM.VALUE))
                    .fontWeight(.bold)
                
            }.padding()
            if (appVM.bestChart.count == Int(appVM.GENERATION_COUNT)){
                ScrollView(.horizontal){
                    Chart(appVM.chartSertiesData){ series in
                        ForEach(series.results){ element in
                            LineMark(
                                x: .value("Generation:", element.name),
                                y: .value("Weight:", element.score)
                            )
                            .foregroundStyle(by: .value("Whats", series.whats))
                        }
                    }
                    .frame(width: CGFloat(appVM.worstChart.count) * 20)
                }
            }
        }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
