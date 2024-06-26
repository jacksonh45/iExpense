//
//  ContentView.swift
//  iExpense”
//
//  Created by Jackson Harrison on 3/4/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
    
    
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Business Expenses"){
                    ForEach(expenses.items) {item in
                        if item.type == "Business" {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                    

                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .foregroundColor(self.expenseStyles(forAmount: Int(item.amount)))
                                }
                            }
                        }
                        
                    }.onDelete(perform: removeItems)
                }
                Section("Personal Expenses") {
                    ForEach(expenses.items) {item in
                        if item.type == "Personal" {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                    

                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .foregroundColor(self.expenseStyles(forAmount: Int(item.amount)))
                                }
                            }
                        }
                        
                    }
                    .onDelete(perform: removeItems)
                }
            } .toolbar {
//                Button {
//                    showingAddExpense = true
//                } label: {
//                    Image(systemName: "plus")
//                }
                NavigationLink(destination: AddView(expenses: Expenses())) {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("iExpense")
        }
//        .sheet(isPresented: $showingAddExpense) {
//            AddView(expenses: expenses)
//        }
    }
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    func expenseStyles(forAmount amount: Int) -> Color {
        switch amount {
        case Int.min..<11:
            return .green
        case 11..<100:
            return .yellow
        default:
            return .red
        }
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
