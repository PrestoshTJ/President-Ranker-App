import SwiftUI

struct Pack: Codable, Identifiable {
    var id = UUID()
    var name: String
    var eloScore: Int
    var attribute: String
}

struct ContentView: View {
    @State private var itemOne: String = "Item One"
    @State private var itemTwo: String = "Item Two"
    @State private var numOne: Int = 0
    @State private var numTwo: Int = 0
    @State private var showTopFive = false
    @State private var showPacks = false
    @State private var buttonMessage: String = "Start"
    @State private var totalMatchups: [Int] = [0,0]
    @State private var attributes: [[String]] = [["Republican", "Democratic", "Third"], ["Primary", "Secondary", "Other"]]
    @State private var packs: [[Pack]] = []
    @State private var packInfo: [[String]] = [["Presidents", "red"], ["Colors", "purple"]]
    @State private var selectedPack: Int = 0
    init() {
        _packs = State(initialValue: [[
                Pack(name: "George Washington", eloScore: 1000, attribute: "Third"),
                Pack(name: "John Adams", eloScore: 1000, attribute: "Third"),
                Pack(name: "Thomas Jefferson", eloScore: 1000, attribute: "Third"),
                Pack(name: "James Madison", eloScore: 1000, attribute: "Third"),
                Pack(name: "James Monroe", eloScore: 1000, attribute: "Third"),
                Pack(name: "John Quincy Adams", eloScore: 1000, attribute: "Third"),
                Pack(name: "Andrew Jackson", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Martin Van Buren", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "William Henry Harrison", eloScore: 1000, attribute: "Third"),
                Pack(name: "John Tyler", eloScore: 1000, attribute: "Third"),
                Pack(name: "James K. Polk", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Zachary Taylor", eloScore: 1000, attribute: "Third"),
                Pack(name: "Millard Fillmore", eloScore: 1000, attribute: "Third"),
                Pack(name: "Franklin Pierce", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "James Buchanan", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Abraham Lincoln", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Andrew Johnson", eloScore: 1000, attribute: "Democratic "),
                Pack(name: "Ulysses S. Grant", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Rutherford B. Hayes", eloScore: 1000, attribute: "Republican"),
                Pack(name: "James A. Garfield", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Chester A. Arthur", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Grover Cleveland", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Benjamin Harrison", eloScore: 1000, attribute: "Republican"),
                Pack(name: "William McKinley", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Theodore Roosevelt", eloScore: 1000, attribute: "Republican"),
                Pack(name: "William Howard Taft", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Woodrow Wilson", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Warren G. Harding", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Calvin Coolidge", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Herbert Hoover", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Franklin D. Roosevelt", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Harry S. Truman", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Dwight D. Eisenhower", eloScore: 1000, attribute: "Republican"),
                Pack(name: "John F. Kennedy", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Lyndon B. Johnson", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Richard Nixon", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Gerald Ford", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Jimmy Carter", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Ronald Reagan", eloScore: 1000, attribute: "Republican"),
                Pack(name: "George H. W. Bush", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Bill Clinton", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "George W. Bush", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Barack Obama", eloScore: 1000, attribute: "Democratic"),
                Pack(name: "Donald Trump", eloScore: 1000, attribute: "Republican"),
                Pack(name: "Joe Biden", eloScore: 1000, attribute: "Democratic")
            ],
                                      [
                                          Pack(name: "Red", eloScore: 1000, attribute: "Primary"),
                                          Pack(name: "Blue", eloScore: 1000, attribute: "Primary"),
                                          Pack(name: "Yellow", eloScore: 1000, attribute: "Primary"),
                                          Pack(name: "Green", eloScore: 1000, attribute: "Secondary"),
                                          Pack(name: "Orange", eloScore: 1000, attribute: "Secondary"),
                                          Pack(name: "Purple", eloScore: 1000, attribute: "Secondary"),
                                          Pack(name: "White", eloScore: 1000, attribute: "Other"),
                                          Pack(name: "Black", eloScore: 1000, attribute: "Other"),
                                          Pack(name: "Brown", eloScore: 1000, attribute: "Other"),
                                          Pack(name: "Grey", eloScore: 1000, attribute: "Other")
                                      ]

                                     
                                     ])
    }


    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    let winningScore = packs[selectedPack][numOne].eloScore
                    let losingScore = packs[selectedPack][numTwo].eloScore
                    ELO(win: winningScore, lose: losingScore, winIndex: numOne, loseIndex: numTwo)
                    randPres()
                }) {
                    VStack(alignment: .leading) {
                        Text(itemOne)
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
                        Top5PresidentsView(items: packs[selectedPack], showTopFive: $showTopFive, resetScores: resetScores, sort: sort, antiSort: antiSort, totalMatchups: totalMatchups, selectedPack: selectedPack, attributes: attributes)
                    })
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            showPacks = true
                        }
                    }) {
                        Text("Packs")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(.red))

                    }
                    .sheet(isPresented: $showPacks, content: {
                        RankerPackView(showPacks: $showPacks, packAmount: packs.count, packInfo: $packInfo, packs: $packs,attributes: $attributes,selectedPack: $selectedPack, randPres: randPres, savePresidents: savePresidents, totalMatchups: $totalMatchups)
                    })
                    
                }
                
                Spacer()
                
                Button(action: {
                    let winningScore = packs[selectedPack][numTwo].eloScore
                    let losingScore = packs[selectedPack][numOne].eloScore
                    ELO(win: winningScore, lose: losingScore, winIndex: numTwo, loseIndex: numOne)
                    randPres()
                }) {
                    VStack(alignment: .leading) {
                        Text(itemTwo)
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
        numOne = Int.random(in:0..<packs[selectedPack].count)
        numTwo = Int.random(in:0..<packs[selectedPack].count)
        while numTwo == numOne {
            numTwo = Int.random(in:0..<packs[selectedPack].count)
        }
        itemOne = packs[selectedPack][numOne].name
        itemTwo = packs[selectedPack][numTwo].name
    }
    
    func ELO(win: Int, lose: Int, winIndex: Int, loseIndex: Int) {
        let K: Double = 30
        let winProbability = 1 / (1 + pow(10, Double(lose - win) / 400))
        let loseProbability = 1 / (1 + pow(10, Double(win - lose) / 400))
        packs[selectedPack][winIndex].eloScore = win + Int(K * (1 - winProbability))
        packs[selectedPack][loseIndex].eloScore = lose + Int(K * (0 - loseProbability))
        totalMatchups[selectedPack] += 1
        sort()
    }
    
    func sort () {
        packs[selectedPack].sort { $0.eloScore > $1.eloScore }
        savePresidents()
    }
    
    func antiSort() {
        packs[selectedPack].sort { $1.eloScore > $0.eloScore }
    }
    
    func resetScores() {
        totalMatchups[selectedPack] = 0
        for index in 0..<packs[selectedPack].count {
            packs[selectedPack][index].eloScore = 1000
        }
        savePresidents()
    }
    
    func savePresidents() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(packs) {
            UserDefaults.standard.set(encoded, forKey: "packsArray")
        }
        if let encoded = try? encoder.encode(totalMatchups) {
            UserDefaults.standard.set(encoded, forKey: "totalMatchups")
        }
        if let encoded = try? encoder.encode(packInfo) {
            UserDefaults.standard.set(encoded, forKey: "packInfo")
        }
        if let encoded = try? encoder.encode(attributes) {
            UserDefaults.standard.set(encoded, forKey: "attributes")
        }
    }
    
    func loadPresidents() {
        if let savedData = UserDefaults.standard.data(forKey: "packsArray") {
            let decoder = JSONDecoder()
            if let loadedPresidents = try? decoder.decode([[Pack]].self, from: savedData) {
                packs = loadedPresidents
            }
        }
        if let moreData = UserDefaults.standard.data(forKey: "totalMatchups") {
            let decoder = JSONDecoder()
            if let loadedMatchups = try? decoder.decode([Int].self, from: moreData) {
                totalMatchups = loadedMatchups
            }
        }
        if let packInfoData = UserDefaults.standard.data(forKey: "packInfo") {
            let decoder = JSONDecoder()
            if let loadedPackInfo = try? decoder.decode([[String]].self, from: packInfoData) {
                packInfo = loadedPackInfo
            }
        }
        if let attributeData = UserDefaults.standard.data(forKey: "attributes") {
            let decoder = JSONDecoder()
            if let loadedAttributes = try? decoder.decode([[String]].self, from: attributeData) {
                attributes = loadedAttributes
            }
        }
    
    }
}

//Outdated name but I literally don't care
struct Top5PresidentsView: View {
    var items: [Pack]
    @Binding var showTopFive: Bool
    @State private var listText: String = ""
    @State private var selectedButton:Int = 1
    @State private var listAmount: Int = 5
    @State private var filterParty: String = "All Attributes"
    
    var resetScores: () -> Void
    var sort: () -> Void
    var antiSort: () -> Void
    var totalMatchups: [Int]
    var selectedPack: Int
    var attributes: [[String]]
    
    private func selector () -> [Pack] {
        var filtered = items
        if filterParty != "All Attributes" {
            filtered = filtered.filter { $0.attribute == filterParty }
            listAmount = filtered.count
        }
        return Array(filtered.prefix(listAmount))
    }
    
    private func originalIndex(for item: Pack) -> Int? {
           return items.firstIndex(where: { $0.id == item.id })
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
            ForEach(0..<attributes[selectedPack].count) {index in
                Text(attributes[selectedPack][index]).tag(attributes[selectedPack][index])
            }
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
        Text(String(totalMatchups[selectedPack]) + " total matchups")
        
        Spacer()
        
        Button(action: {
            resetScores()
        }) {
            Text("Reset")
        }.padding(11.0)
        .background(RoundedRectangle(cornerRadius: 10).fill(.red))
    }
}

struct RankerPackView: View {
    @Binding var showPacks: Bool
    var packAmount: Int
    @Binding var packInfo: [[String]]
    @Binding var packs: [[Pack]]
    @Binding var attributes: [[String]]
    @Binding var selectedPack: Int
    var randPres: () -> Void
    var savePresidents: () -> Void
    @Binding var totalMatchups: [Int]
    @State private var showMaker: Bool = false
    @State private var PacksValues: Bool = true
    var body: some View {
        VStack {
            
            Button(action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    showMaker = true
                }
            }) {
                Text("Make a Pack")
            }.padding()
            .background(RoundedRectangle(cornerRadius: 30).fill(.red))
            .sheet(isPresented: $showMaker, content: {
                MakePackView(showMaker: $showMaker, packInfo: $packInfo, packs: $packs, attributes: $attributes, savePresidents: savePresidents, totalMatchups: $totalMatchups)
            })
            
            if PacksValues {
                VStack {
                    ScrollView {
                        ForEach(0..<packAmount, id: \.self) {index in
                            HStack{
                                Button(action: {
                                    selectedPack = index
                                    randPres()
                                    showPacks = false
                                }) {
                                    Text(packInfo[index][0])
                                }.padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
                                if index > 1 {
                                    Button(action: {
                                        
                                    }) {
                                        Text("X")
                                    }.padding(3.0)
                                        .background(RoundedRectangle(cornerRadius: 30).fill(.red))
                                }
                            }
                        }
                    }
                }
            }
            
            // Figure out how to delete each individual I don't feel like it
            Button(action: {
                PacksValues = false
                var packsRemover = packs.count - 1
                while packsRemover > 1 {
                    packs.remove(at: packsRemover)
                    packInfo.remove(at: packsRemover)
                    attributes.remove(at: packsRemover)
                    totalMatchups.remove(at: packsRemover)
                    packsRemover -= 1
                }
                savePresidents()
                showPacks = false
            }) {
                Text("Delete Custom Packs")
            }.padding()
                .background(RoundedRectangle(cornerRadius: 30).fill(.red))
            
            Button(action: {
                showPacks = false
            }) {
                Text("Close")
            }

        }
        .padding(.top, 20.0)
    }
}

struct MakePackView: View {
    @Binding var showMaker: Bool
    @State private var dummyArray: [[String]] = [[]]
    @State private var name: String = ""
    @State private var stackCount: Int = 0
    @State private var stacks: [Pack] = []
    @State private var stackAttributes: [String] = []
    @Binding var packInfo: [[String]]
    @Binding var packs: [[Pack]]
    @Binding var attributes: [[String]]
    var savePresidents: () -> Void
    @Binding var totalMatchups: [Int]
    var body: some View {
        VStack{
            
            Button(action: {
                stackCount += 1
                stacks.append(Pack(name: "", eloScore: 1000, attribute: ""))
            }) {
                Text("+")
                    .font(.title)
            }.background(RoundedRectangle(cornerRadius: 30).fill(.red))
                .padding()
            
            if stackCount > 0 {
                HStack{
                    TextField("Title", text: $name)
                }
            }
            
            ForEach(0..<stackCount, id: \.self) {index in
                HStack{
                    Text(String(index + 1) + "             ")
                    TextField("Name", text: $stacks[index].name)
                    TextField("Attribute", text: $stacks[index].attribute)
                }            }
            
            if stackCount > 1 {
                Button(action: {
                    packs.append(stacks)
                    packInfo.append([name, "Yellow"])
                    for stack in stacks {
                        if !stackAttributes.contains(stack.attribute) {
                            stackAttributes.append(stack.attribute)
                        }
                    }
                    attributes.append(stackAttributes)
                    totalMatchups.append(0)
                    showMaker = false
                    savePresidents()
                }) {
                    Text("Submit")
                }
            }
            
            
            Button(action: {
                showMaker = false
            }) {
                Text("Close")
            }
        }
    }
}


#Preview {
    ContentView()
}
