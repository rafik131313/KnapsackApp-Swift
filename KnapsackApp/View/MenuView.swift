//
//  MenuView.swift
//  KnapsackApp
//
//  Created by Rafał on 24/11/2022.
//

import SwiftUI


struct MenuView: View {
    
    @EnvironmentObject var appVM: AppVM
    
    var body: some View {
        
        VStack(alignment: .center){
            
            Text("KNAPSACK")
                .font(.title)
                .foregroundColor(.cyan)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("background"))
                
                VStack(alignment: .leading){

                    VStack{
                        
                        
                        Text("Mutation")
                            .textCase(.uppercase)
                            .padding(.top, 8)
                            .bold()
                        
                        HStack{
                            Slider(value: $appVM.MUTATION_RATE,
                                   in: 0...1,
                                   step: 0.01)
                            
                            Text(
                                String(format: "%.2f", appVM.MUTATION_RATE)
                            )
                        }
                        
                        Text("Crossover")
                            .textCase(.uppercase)
                            .padding(.top, 8)
                            .bold()
                        
                        HStack{
                            Slider(value: $appVM.CROSSOVER_RATE,
                                   in: 0...1,
                                   step: 0.01)
                            
                            Text(
                                String(format: "%.2f", appVM.CROSSOVER_RATE)
                            )
                        }
                        
                        Text("Generations")
                            .textCase(.uppercase)
                            .padding(.top, 8)
                            .bold()
                        
                        HStack{
                            Slider(value: $appVM.GENERATION_COUNT,
                                   in: 0...100,
                                   step: 2)
                            
                            Text(
                                String(format: "%.2f", appVM.GENERATION_COUNT)
                            )
                        }
                        
                        Text("Generated data")
                            .textCase(.uppercase)
                            .padding(.top, 8)
                            .bold()
                        
                        HStack{
                            Slider(value: $appVM.GENERATED_DATA,
                                   in: 0...25,
                                   step: 1)
                            
                            Text(
                                String(format: "%.2f", appVM.GENERATED_DATA)
                            )
                        }
                        
                        Text("Max weight")
                            .textCase(.uppercase)
                            .padding(.top, 8)
                            .bold()
                        
                        HStack{
                            Slider(value: $appVM.MAX_WEIGHT,
                                   in: 0...800,
                                   step: 20)
                            
                            Text(
                                String(format: "%.2f", appVM.MAX_WEIGHT)
                            )
                        }
                    }
                    
                    HStack(alignment: .center){
                        Spacer()
                        
                            Text("Elitism")
                                .font(appVM.ELITISM ? .title : .caption)
                                .textCase(.uppercase)
                                .padding(.top, 8)
                                .bold()
                                .foregroundColor(appVM.ELITISM ? .green : .red)
                                .onTapGesture {
                                    appVM.ELITISM.toggle()
                                }
                            
                            Spacer()
                            
                            Text("Parents")
                                .font(appVM.PARENTS ? .title : .caption)
                                .textCase(.uppercase)
                                .padding(.top, 8)
                                .bold()
                                .foregroundColor(appVM.PARENTS ? .green : .red)
                                .onTapGesture {
                                    appVM.PARENTS.toggle()
                                }
                        
                        Spacer()
                    }
                    
                }
                .padding(10)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
            
            Button {
                appVM.clearData()
                appVM.solveBackpack()
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 50)
                    .foregroundColor(.cyan)
                    .overlay {
                            HStack{
                                Text("START")
                                    .font(.headline)
                                Image(systemName: "arrow.right")
                            }
                    }
            }
            .padding(.top, 10)
        }
        .sheet(isPresented: $appVM.showResult) {
            ResultView()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
