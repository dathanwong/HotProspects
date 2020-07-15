//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Dathan Wong on 7/13/20.
//  Copyright © 2020 Dathan Wong. All rights reserved.
//

import SwiftUI
import CodeScanner

struct ProspectsView: View {
    enum FilterType{
        case none, contacted, uncontacted
    }
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    let filter: FilterType
    
    var title: String{
        switch filter{
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    var filteredProspects: [Prospect]{
        switch filter{
            case .none:
                return prospects.people
            case .contacted:
                return prospects.people.filter {
                    $0.isContacted
                }
            case .uncontacted:
                return prospects.people.filter {
                    !$0.isContacted
                }
            }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>){
        self.isShowingScanner = false
        
        switch result{
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else{
                return
            }
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            self.prospects.people.append(person)
        case .failure(let _):
            print("Scanning failed")
        }
    }
    
    var body: some View {
        NavigationView{
            List{
                ForEach(filteredProspects){ prospect in
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                    .contextMenu{
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted"){
                            self.prospects.toggle(prospect)
                        }
                    }
                }
            }
            .navigationBarTitle(title)
                .navigationBarItems(trailing: Button(action: {
                    self.isShowingScanner = true
                }, label: {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                }))
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Dathan Wong\ndathan@dathan.com", completion: self.handleScan)
            }
        }
        
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
