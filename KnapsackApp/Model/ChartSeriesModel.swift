//
//  ChartSeriesModel.swift
//  KnapsackApp
//
//  Created by Rafał on 24/11/2022.
//

import Foundation

struct chartSeries: Identifiable{
    let whats: String
    let results: [chartData]
    
    var id: String { whats }
}
