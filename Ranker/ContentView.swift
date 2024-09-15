import SwiftUI

struct President: Codable, Identifiable {
    var id = UUID()
    let name: String
    var eloScore: Int
    let party: String
}

struct ContentView: View {
    @State private var presOne: String = "President One"
    @State private var presTwo: String = "President Two"
    @State private var numOne: Int = 0
    @State private var numTwo: Int = 0
    @State private var showTopFive = false
    @State private var buttonMessage: String = "Start"
    @State private var totalMatchups: Int = 0
    @State private var presidents: [President] = [
        President(name: "George Washington", eloScore: 1000, party: "Third"),
            President(name: "John Adams", eloScore: 1000, party: "Third"),
            President(name: "Thomas Jefferson", eloScore: 1000, party: "Third"),
            President(name: "James Madison", eloScore: 1000, party: "Third"),
            President(name: "James Monroe", eloScore: 1000, party: "Third"),
            President(name: "John Quincy Adams", eloScore: 1000, party: "Third"),
            President(name: "Andrew Jackson", eloScore: 1000, party: "Democratic"),
            President(name: "Martin Van Buren", eloScore: 1000, party: "Democratic"),
            President(name: "William Henry Harrison", eloScore: 1000, party: "Third"),
            President(name: "John Tyler", eloScore: 1000, party: "Third"),
            President(name: "James K. Polk", eloScore: 1000, party: "Democratic"),
            President(name: "Zachary Taylor", eloScore: 1000, party: "Third"),
            President(name: "Millard Fillmore", eloScore: 1000, party: "Third"),
            President(name: "Franklin Pierce", eloScore: 1000, party: "Democratic"),
            President(name: "James Buchanan", eloScore: 1000, party: "Democratic"),
            President(name: "Abraham Lincoln", eloScore: 1000, party: "Republican"),
            President(name: "Andrew Johnson", eloScore: 1000, party: "Democratic "),
            President(name: "Ulysses S. Grant", eloScore: 1000, party: "Republican"),
            President(name: "Rutherford B. Hayes", eloScore: 1000, party: "Republican"),
            President(name: "James A. Garfield", eloScore: 1000, party: "Republican"),
            President(name: "Chester A. Arthur", eloScore: 1000, party: "Republican"),
            President(name: "Grover Cleveland", eloScore: 1000, party: "Democratic"),
            President(name: "Benjamin Harrison", eloScore: 1000, party: "Republican"),
            President(name: "William McKinley", eloScore: 1000, party: "Republican"),
            President(name: "Theodore Roosevelt", eloScore: 1000, party: "Republican"),
            President(name: "William Howard Taft", eloScore: 1000, party: "Republican"),
            President(name: "Woodrow Wilson", eloScore: 1000, party: "Democratic"),
            President(name: "Warren G. Harding", eloScore: 1000, party: "Republican"),
            President(name: "Calvin Coolidge", eloScore: 1000, party: "Republican"),
            President(name: "Herbert Hoover", eloScore: 1000, party: "Republican"),
            President(name: "Franklin D. Roosevelt", eloScore: 1000, party: "Democratic"),
            President(name: "Harry S. Truman", eloScore: 1000, party: "Democratic"),
            President(name: "Dwight D. Eisenhower", eloScore: 1000, party: "Republican"),
            President(name: "John F. Kennedy", eloScore: 1000, party: "Democratic"),
            President(name: "Lyndon B. Johnson", eloScore: 1000, party: "Democratic"),
            President(name: "Richard Nixon", eloScore: 1000, party: "Republican"),
            President(name: "Gerald Ford", eloScore: 1000, party: "Republican"),
            President(name: "Jimmy Carter", eloScore: 1000, party: "Democratic"),
            President(name: "Ronald Reagan", eloScore: 1000, party: "Republican"),
            President(name: "George H. W. Bush", eloScore: 1000, party: "Republican"),
            President(name: "Bill Clinton", eloScore: 1000, party: "Democratic"),
            President(name: "George W. Bush", eloScore: 1000, party: "Republican"),
            President(name: "Barack Obama", eloScore: 1000, party: "Democratic"),
            President(name: "Donald Trump", eloScore: 1000, party: "Republican"),
            President(name: "Joe Biden", eloScore: 1000, party: "Democratic")
    ]
    
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
                            .background(RoundedRectangle(cornerRadius: 10).fill(.orange))
                    }
                    
                    Button(action: {
                        sort()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            showTopFive = true
                        }
                    }) {
                        Text("Stats")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(.purple))
                    }
                    .sheet(isPresented: $showTopFive, content: {
                        Top5PresidentsView(presidents: presidents, showTopFive: $showTopFive, resetScores: resetScores, sort: sort, antiSort: antiSort, totalMatchups: totalMatchups)
                    })
                    Button(action: {
                        
                    }) {
                        Text("Packs")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(.red))

                    }
                    
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
        .onAppear {
            loadPresidents()
            sort()
        }
    }
    
    func randPres() {
        if buttonMessage == "Start" {
            loadPresidents()
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
        totalMatchups += 1
        sort()
    }
    
    func sort () {
        presidents.sort { $0.eloScore > $1.eloScore }
        savePresidents()
    }
    
    func antiSort() {
        presidents.sort { $1.eloScore > $0.eloScore }
    }
    
    func resetScores() {
        totalMatchups = 0
        for index in 0..<presidents.count {
            presidents[index].eloScore = 1000
        }
        savePresidents()
    }
    
    func savePresidents() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(presidents) {
            UserDefaults.standard.set(encoded, forKey: "presidentsArray")
        }
        if let encoded = try? encoder.encode(totalMatchups) {
            UserDefaults.standard.set(encoded, forKey: "totalMatchups")
        }
    }
    
    func loadPresidents() {
        if let savedData = UserDefaults.standard.data(forKey: "presidentsArray") {
            let decoder = JSONDecoder()
            if let loadedPresidents = try? decoder.decode([President].self, from: savedData) {
                presidents = loadedPresidents
            }
        }
        if let moreData = UserDefaults.standard.data(forKey: "totalMatchups") {
            let decoder = JSONDecoder()
            if let loadedMatchups = try? decoder.decode(Int.self, from: moreData) {
                totalMatchups = loadedMatchups
            }
        }
    }
}

//Outdated name but I literally don't care
struct Top5PresidentsView: View {
    var presidents: [President]
    @Binding var showTopFive: Bool
    @State private var listText: String = ""
    @State private var selectedButton:Int = 1
    @State private var listAmount: Int = 5
    @State private var filterParty: String = "All Parties"
    
    var resetScores: () -> Void
    var sort: () -> Void
    var antiSort: () -> Void
    var totalMatchups: Int
    
    
    private func selector () -> [President] {
        var filtered = presidents
        if filterParty != "All Parties" {
            filtered = filtered.filter { $0.party == filterParty }
            listAmount = filtered.count
        }
        return Array(filtered.prefix(listAmount))
    }
    
    private func originalIndex(for president: President) -> Int? {
           return presidents.firstIndex(where: { $0.id == president.id })
       }
    
    var body: some View {
        HStack {
            Button(action: {
                sort()
                listAmount = 5
                selectedButton = 1
            }) {
                Text("Top 5")
                    .foregroundColor(Color.white)
            }.padding(11.0)
                .background(RoundedRectangle(cornerRadius: 10).fill(selectedButton == 1 ? .blue : .black ))
            Button(action: {
                antiSort()
                listAmount = 5
                selectedButton = 2
            }) {
                Text("Bottom 5")
                    .foregroundColor(Color.white)
            }.padding(11.0).background(RoundedRectangle(cornerRadius: 10).fill(selectedButton == 2 ? .blue : .black))
            Button(action: {
                sort()
                selectedButton = 3
                listAmount = 45
            }) {
                Text("Total")
            }.foregroundColor(Color.white)
                .padding(11.0)
                .background(RoundedRectangle(cornerRadius: 10).fill(selectedButton == 3 ? .blue : .black))
            
        }.padding(5.0)
        
        Picker ("Select party", selection: $filterParty) {
            Text("All Parties").tag("All Parties")
            Text("Republican").tag("Republican")
            Text("Democratic").tag("Democratic")
            Text("Third").tag("Third")
        }.pickerStyle(WheelPickerStyle())
            .frame(height: 100)
        
        
        Spacer()
        VStack {
            ScrollView {
                ForEach(selector().indices, id: \.self) { index in
                    let president = self.selector()[index]
                    if let trueIndex = originalIndex(for: president) {
                        HStack {
                            Text(String(trueIndex + 1))
                            Text(president.name)
                            Text("\(president.eloScore)")
                        }.padding(0.5)
                    }
                }
            }.frame(height: 300)
        }
        Button(action: {
            showTopFive = false
        }) {
            Text("Close")
        }.padding()
        Text(String(totalMatchups) + " total matchups")
        
        Spacer()
        
        Button(action: {
            resetScores()
        }) {
            Text("Reset")
        }.padding(11.0)
        .background(RoundedRectangle(cornerRadius: 10).fill(.red))
    }
}


#Preview {
    ContentView()
}
