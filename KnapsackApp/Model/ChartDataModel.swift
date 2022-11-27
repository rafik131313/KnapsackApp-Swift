//
//  ChartDataModel.swift
//  KnapsackApp
//
//  Created by Rafał on 24/11/2022.
//

import Foundation

struct chartData: Identifiable{
    let name: String
    let score: Int
    
    var id: String { name }
}
