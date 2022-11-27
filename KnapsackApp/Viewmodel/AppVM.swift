//
//  AppViewModel.swift
//  BestRouteApp
//
//  Created by Rafał on 11/11/2022.
//

import Foundation

class AppVM: ObservableObject{
    
    @Published var GENERATED_DATA: Double  = 10

    @Published var MAX_WEIGHT: Double  = 300
    @Published var RANDOM_DATA = true
    @Published var GENERATION_COUNT: Double  = 40
    @Published var ELITISM = true
    @Published var PARENTS = true

    @Published var CROSSOVER_RATE: Double = 0.3
    @Published var MUTATION_RATE: Double = 0.1

    @Published var WEIGHT = [91, 30, 70, 2, 11]
    @Published var VALUE = [42, 28, 14, 66, 25]

    @Published var chromosome = [Int]()
    @Published var population = [[Int]]()
    @Published var bestChart = [chartData]()
    @Published var worstChart = [chartData]()
    @Published var avarageChart = [chartData]()
    @Published var chartSertiesData = [chartSeries]()
    @Published var showResult: Bool = false
    
    @Published var bestValue = 0
    @Published var bestFitnessAsChromosome = ""
    @Published var bestValueWeight = 0
    
    @Published var isLoading: Bool = false
    
    var generationCounter = 0
    
    func computeWeight(chromosome: [Int]) -> Int{
        var weightScore = 0
        for i in 0...chromosome.count - 1{
            if chromosome[i] == 1{
                weightScore += WEIGHT[i]
            }
        }
        return weightScore
    }
    
    func makeStringFromArray(array: [Int]) -> String{
        var result = ""
        
        for i in 0...array.count - 1{
            result = result + String(array[i]) + ", "
        }
        return result
    }
    
    func generateData(){
        WEIGHT.removeAll()
        VALUE.removeAll()
        for _ in 1...Int(GENERATED_DATA){
            VALUE.append(Int.random(in: 1...100))
            WEIGHT.append(Int.random(in: 1...100))
        }
    }
    
    func clearData(){
        WEIGHT.removeAll()
        VALUE.removeAll()
        chromosome.removeAll()
        population.removeAll()
        bestChart.removeAll()
        worstChart.removeAll()
        avarageChart.removeAll()
        chartSertiesData.removeAll()
    }

    func makeInitialSolutions() -> [[Int]]{
        population.removeAll()
        for _ in 1...Int(GENERATED_DATA){
            for _ in  1...VALUE.count{
                chromosome.append(Int.random(in: 0...1))
            }
            population.append(chromosome)
            chromosome.removeAll()
        }
        print("Population generated: ", population)
        return population
    }

    func computeFitness(chromosome: [Int]) -> Int{
        
        var weightScore = 0
        var valueScore = 0
        for i in 0...chromosome.count - 1{
            if chromosome[i] == 1{
                weightScore += WEIGHT[i]
                valueScore += VALUE[i]
            }
        }
        
        if weightScore <= Int(MAX_WEIGHT){
            return valueScore
        }
        else{
            valueScore = 0
            return valueScore
        }
    }

    func selectParentsByTournament(population: [[Int]]) -> [[Int]]{
        
        var randomChoosenParents = [[Int]]()
        var result = [[Int]]()
        var startPopulation = population
        
        
        for _ in 1...4{
            let randomNumber = Int.random(in: 0...startPopulation.count - 1)
            randomChoosenParents.append(startPopulation[randomNumber])
            startPopulation.remove(at: randomNumber)
        }
        for i in 0...randomChoosenParents.count - 1{
            let checked = computeFitness(chromosome: randomChoosenParents[i])
            if checked > 0{
                result.append(randomChoosenParents[i])
            }
        }
        
        var sortedRandomParentsArray = sortArrayByFitness(arrayToSort: randomChoosenParents)

        sortedRandomParentsArray = sortedRandomParentsArray.dropLast(3) //returning just 1 best parent

        return sortedRandomParentsArray
    }

    func sortArrayByFitness(arrayToSort: [[Int]]) -> [[Int]]{
        let sortedArray = arrayToSort.sorted(by: { lhs, rhs in
            return computeFitness(chromosome: lhs) > computeFitness(chromosome: rhs)
        })
        return sortedArray
    }

    func elite(population: [[Int]]) -> [[Int]]{
        var elite = sortArrayByFitness(arrayToSort: population)
        elite = elite.dropLast(elite.count - 1)
        return elite
    }
    
    func worstFitness(population: [[Int]]) -> [[Int]]{
        var worst = sortArrayByFitness(arrayToSort: population)
        worst.reverse()
        worst = worst.dropLast(worst.count - 1)
        return worst
    }
    
    func avarageFitness(population: [[Int]]) -> Double{
        
        var fitnessOfChromosome = 0
        var sumFitnessOfPopulation: Double = 0
        
        for i in 0...population.count - 1{
            fitnessOfChromosome = computeFitness(chromosome: population[i])
            sumFitnessOfPopulation += Double(fitnessOfChromosome)
        }
        let avarageFitnessOfPopulation = Double(sumFitnessOfPopulation / Double(population.count))
        
        return avarageFitnessOfPopulation
    }

    func crossover(parents: [[Int]]) -> [[Int]]{
        var parentsToCrossover = parents
        if(parents[0].count % 2 == 0){
            let n = parents[0].count / 2
            let firstHalf = parents[0][..<n]
            let secondHalf = parents[0][n...]
            let firstHalf2 = parents[1][..<n]
            let secondHalf2 = parents[1][n...]
            parentsToCrossover[0] = Array(firstHalf + secondHalf2)
            parentsToCrossover[1] = Array(firstHalf2 + secondHalf)
            return parentsToCrossover
        }
        else{
            let n = parents[0].count / 2
            let firstHalf = parents[0][..<n]
            let secondHalf = parents[0][n...]
            let firstHalf2 = parents[1][..<n]
            let secondHalf2 = parents[1][n...]
            parentsToCrossover[0] = Array(firstHalf + secondHalf2)
            parentsToCrossover[1] = Array(firstHalf2 + secondHalf)
            return parentsToCrossover
        }
    }

    func mutate(population: [[Int]]) -> [[Int]]{

        var populationToMutate = population
        
        for i in 0...population.count - 1{
            var chromosome = population[i]
            for b in 0...chromosome.count - 1{
                
                let x = Double.random(in: 0..<1)
                
                if x < MUTATION_RATE{
                    if chromosome[b] == 0{
                        chromosome[b] = 1
                    }else{
                        chromosome[b] = 0
                    }
                }
            }
            populationToMutate[i] = chromosome
        }
        return populationToMutate
    }

    func nextGeneration(population: [[Int]]) -> [[Int]]{
       var nextGen = [[Int]]()


        while nextGen.count < population.count{
            
            generationCounter = generationCounter + 1
            print(generationCounter)
            
            var children = population
            var eliteFromPopulation: [[Int]]
            var parents: [[Int]]
            

            eliteFromPopulation = elite(population: population)
            print("BEST:", eliteFromPopulation)

            parents = selectParentsByTournament(population: population)


            if Double.random(in: 0...1) < CROSSOVER_RATE{
                children = crossover(parents: population)
            }
            if Double.random(in: 0...1) < MUTATION_RATE{
                children = mutate(population: children)
            }
            let worstFromPopulation = worstFitness(population: population)
            let avarageFromPopulation = avarageFitness(population: population)
            
            if ELITISM{
                nextGen.append(contentsOf: eliteFromPopulation)
            }
            if PARENTS{
                nextGen.append(contentsOf: parents)
            }
            nextGen.append(contentsOf: children)

            bestChart.append(chartData(name: "\(generationCounter)",
                                       score: computeFitness(chromosome: eliteFromPopulation[0])))
            
            if bestValue < computeFitness(chromosome: eliteFromPopulation[0]){
                
                bestValue = computeFitness(chromosome: eliteFromPopulation[0])
                
                bestFitnessAsChromosome = makeStringFromArray(array: eliteFromPopulation[0])
                
                bestValueWeight = computeWeight(chromosome: eliteFromPopulation[0])
                
            }
            print("best: ", bestChart)
            worstChart.append(chartData(name: "\(generationCounter)",
                                        score: computeFitness(chromosome: worstFromPopulation[0])))
            print("worst: ", worstChart)
            avarageChart.append(chartData(name: "\(generationCounter)", score: Int(avarageFromPopulation)))
            print("avarage: ", avarageChart)
            
            chartSertiesData = [chartSeries(whats: "Best", results: bestChart),
                                                   chartSeries(whats: "Worst", results: worstChart),
                                                   chartSeries(whats: "Avarage", results: avarageChart)
            ]
            print("CHARTSERIES: ", chartSertiesData)
        }
        return nextGen
    }

    func solveBackpack(){
        
        if RANDOM_DATA{
            generateData()
        }
        
        var population = makeInitialSolutions()
        
        for _ in 1...Int(GENERATION_COUNT){
            population = nextGeneration(population: population)
            print(population)
        }
        showResult.toggle()
        generationCounter = 0
    }


    
}





