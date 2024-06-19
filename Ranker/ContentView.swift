//
//  ContentView.swift
//  Ranker
//
//  Created by TJ Prestosh on 6/18/24.
//

import SwiftUI


struct President: Codable, Identifiable {
    var id = UUID()
    let name: String
    var eloScore: Int
}

struct ContentView: View {
    @State private var presOne: String = "President One"
    @State private var presTwo: String = "President Two"
    @State private var numOne: Int = 0
    @State private var numTwo: Int = 0
    @State private var showTopFive = false
    @State private var buttonMessage: String = "Start"
    @State private var presidents: [President] = [
        President(name: "George Washington", eloScore: 1000),
        President(name: "John Adams", eloScore: 1000),
        President(name: "Thomas Jefferson", eloScore: 1000),
        President(name: "James Madison", eloScore: 1000),
        President(name: "James Monroe", eloScore: 1000),
        President(name: "John Quincy Adams", eloScore: 1000),
        President(name: "Andrew Jackson", eloScore: 1000),
        President(name: "Martin Van Buren", eloScore: 1000),
        President(name: "William Henry Harrison", eloScore: 1000),
        President(name: "John Tyler", eloScore: 1000),
        President(name: "James K. Polk", eloScore: 1000),
        President(name: "Zachary Taylor", eloScore: 1000),
        President(name: "Millard Fillmore", eloScore: 1000),
        President(name: "Franklin Pierce", eloScore: 1000),
        President(name: "James Buchanan", eloScore: 1000),
        President(name: "Abraham Lincoln", eloScore: 1000),
        President(name: "Andrew Johnson", eloScore: 1000),
        President(name: "Ulysses S. Grant", eloScore: 1000),
        President(name: "Rutherford B. Hayes", eloScore: 1000),
        President(name: "James A. Garfield", eloScore: 1000),
        President(name: "Chester A. Arthur", eloScore: 1000),
        President(name: "Grover Cleveland", eloScore: 1000),
        President(name: "Benjamin Harrison", eloScore: 1000),
        President(name: "William McKinley", eloScore: 1000),
        President(name: "Theodore Roosevelt", eloScore: 1000),
        President(name: "William Howard Taft", eloScore: 1000),
        President(name: "Woodrow Wilson", eloScore: 1000),
        President(name: "Warren G. Harding", eloScore: 1000),
        President(name: "Calvin Coolidge", eloScore: 1000),
        President(name: "Herbert Hoover", eloScore: 1000),
        President(name: "Franklin D. Roosevelt", eloScore: 1000),
        President(name: "Harry S. Truman", eloScore: 1000),
        President(name: "Dwight D. Eisenhower", eloScore: 1000),
        President(name: "John F. Kennedy", eloScore: 1000),
        President(name: "Lyndon B. Johnson", eloScore: 1000),
        President(name: "Richard Nixon", eloScore: 1000),
        President(name: "Gerald Ford", eloScore: 1000),
        President(name: "Jimmy Carter", eloScore: 1000),
        President(name: "Ronald Reagan", eloScore: 1000),
        President(name: "George H. W. Bush", eloScore: 1000),
        President(name: "Bill Clinton", eloScore: 1000),
        President(name: "George W. Bush", eloScore: 1000),
        President(name: "Barack Obama", eloScore: 1000),
        President(name: "Donald Trump", eloScore: 1000),
        President(name: "Joe Biden", eloScore: 1000)

    ]
    
    func randPres() {
        if buttonMessage == "Start" {
            if let savedData = UserDefaults.standard.data(forKey: "presidentsArray") {
                let decoder = JSONDecoder()
                if let loadedPresidents = try? decoder.decode([President].self, from: savedData) {
                    presidents = loadedPresidents
                }
            }

        }
        buttonMessage = "Refresh"
        numOne = Int.random(in:0..<presidents.count)
        numTwo = Int.random(in:0..<presidents.count)
        while numTwo == numOne {
            numTwo = Int.random(in:0..<presidents.count)
        }
        presOne = presidents[numOne].name
        presTwo = presidents[numTwo].name
        
        
    }
    
    func ELO(win: Int, lose: Int, winIndex: Int, loseIndex: Int) {
        let K: Double = 30
        let winProbability = 1 / (1 + pow(10, Double(lose - win) / 400))
        let loseProbability = 1 / (1 + pow(10, Double(win - lose) / 400))
        presidents[winIndex].eloScore = win + Int(K * (1 - winProbability))
        presidents[loseIndex].eloScore = lose + Int(K * (0 - loseProbability))
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(presidents) {
            UserDefaults.standard.set(encoded, forKey: "presidentsArray")
        }
    }
    
    func sort () {
        presidents.sort { $0.eloScore > $1.eloScore}
    }
    
    func resetScores() {
        for index in 0..<presidents.count {
            presidents[index].eloScore = 1000
        }
    }

    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    let winningScore = presidents[numOne].eloScore
                    let losingScore = presidents[numTwo].eloScore
                    ELO(win: winningScore, lose: losingScore, winIndex: numOne, loseIndex: numTwo)
                    randPres()
                }) {
                    VStack(alignment: .leading) {
                        Text(presOne)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        randPres()
                    }) {
                        Text(buttonMessage)
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(.red))
                    }
                    
                    Button(action: {
                        sort()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            showTopFive = true
                        }
                    }) {
                        Text("Top 5")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(.purple))
                    }
                    .sheet(isPresented: $showTopFive, content: {
                        Top5PresidentsView(presidents: presidents, showTopFive: $showTopFive, resetScores: resetScores)
                    })
                    
                    
                }
                
                Spacer()
                
                
                Button(action: {
                    let winningScore = presidents[numTwo].eloScore
                    let losingScore = presidents[numOne].eloScore
                    ELO(win: winningScore, lose: losingScore, winIndex: numTwo, loseIndex: numOne)
                    randPres()
                }) {
                    VStack(alignment: .leading) {
                        Text(presTwo)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.green))
                }
            }
            .padding(.all, 5.0)
        }
    }
}

struct Top5PresidentsView: View {
    var presidents: [President]
    @Binding var showTopFive: Bool
    var resetScores: () -> Void
    var body: some View {
        Spacer()
        VStack {
            ForEach(presidents.prefix(5)) { president in
                HStack {
                    Text(president.name)
                    Text(String(president.eloScore))
                }
            }
        }        .padding()
        Button(action: {
            showTopFive = false
        }) {
            Text("Close")
        }
        
        Spacer()
        
        Button(action: {
            resetScores()
        }) {
            Text("Reset")
        }
    }
}



#Preview {
    ContentView()
}

