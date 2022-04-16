//
//  ListItem.swift
//  Todolist
//
//  Created by imTony on 12/21/21.
//

import SwiftUI

 struct ListItem: View {
    @State var idList = String()
    @State var name = String()
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State var todoCount = 0
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack{
            return Text("\(todoCount)")
        }
        
        .onReceive(timer, perform: { _ in
            countList()
            
        })
        
    }
    
    func countList() {
        let url = URL(string: "https://2dolist.website/api/danhsach/count1.php?account="+User+"&idlist=\(idList)&list="+self.name.urlEncoded!)
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print ("Error took place\(error)")
                return
            }
            struct Model: Decodable {
                
                var success: Bool
                var message: Int
            }
        let decoder = JSONDecoder()
        do{
            let shellys = try decoder.decode(Model.self, from: data!)
            
            if shellys.success == true{
                self.todoCount = shellys.message
            }else{
                print("error")
                
            }
            

        }catch{
            print(error.localizedDescription)
        }
    }
        task.resume()
        
    }
    
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem()
    }
}
struct ListSystem1: View {
    @State var namelistSystem = String()
    @State var iconlistSystem = String()
   
    @State var color = String()
    @State var todoCountlistsystem = String()
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var body: some View {
        HStack {
            Image(systemName: "\(iconlistSystem)")
                .foregroundColor(Color.init("\(color)"))
            Text("\(namelistSystem)")
            Spacer()
            Text("\(todoCountlistsystem)")
        }
        .onReceive(timer, perform: { _ in
            countSystemlist()
            
        })
    }
    func countSystemlist() {
        let url = URL(string: "https://2dolist.website/api/danhsach/countsystemlist1.php?account="+User.urlEncoded!)
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print ("Error took place\(error)")
                return
            }
            struct Model: Decodable {
                
                var success: Bool
                var message: String
            }
        let decoder = JSONDecoder()
        do{
            let shellys = try decoder.decode(Model.self, from: data!)
            
            if shellys.success == true{
                self.todoCountlistsystem = shellys.message
            }else{
                print("error")
                
            }
            

        }catch{
            print(error.localizedDescription)
        }
    }
        task.resume()
        
    }
}
struct ListSystem2: View {
    @State var namelistSystem = String()
    @State var iconlistSystem = String()
    
    @State var color = String()
    @State var todoCountlistsystem = String()
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var body: some View {
        HStack {
            Image(systemName: "\(iconlistSystem)")
                .foregroundColor(Color.init("\(color)"))
            Text("\(namelistSystem)")
            Spacer()
            Text("\(todoCountlistsystem)")
        }
        .onReceive(timer, perform: { _ in
            countSystemlist()
            
        })
    }
    func countSystemlist() {
        let url = URL(string: "https://2dolist.website/api/danhsach/countsystemlist2.php?account="+User.urlEncoded!)
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print ("Error took place\(error)")
                return
            }
            struct Model: Decodable {
                
                var success: Bool
                var message: String
            }
        let decoder = JSONDecoder()
        do{
            let shellys = try decoder.decode(Model.self, from: data!)
            
            if shellys.success == true{
                self.todoCountlistsystem = shellys.message
            }else{
                print("error")
                
            }
            

        }catch{
            print(error.localizedDescription)
        }
    }
        task.resume()
        
    }
}
struct ListSystem3: View {
    @State var namelistSystem = String()
    @State var iconlistSystem = String()
    
    @State var color = String()
    @State var todoCountlistsystem = String()
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var body: some View {
        HStack {
            Image(systemName: "\(iconlistSystem)")
                .foregroundColor(Color.init("\(color)"))
            Text("\(namelistSystem)")
            Spacer()
            Text("\(todoCountlistsystem)")
        }
        .onReceive(timer, perform: { _ in
            countSystemlist()
            
        })
    }
    func countSystemlist() {
        let url = URL(string: "https://2dolist.website/api/danhsach/countsystemlist3.php?account="+User.urlEncoded!)
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print ("Error took place\(error)")
                return
            }
            struct Model: Decodable {
                
                var success: Bool
                var message: String
            }
        let decoder = JSONDecoder()
        do{
            let shellys = try decoder.decode(Model.self, from: data!)
            
            if shellys.success == true{
                self.todoCountlistsystem = shellys.message
            }else{
                print("error")
                
            }
            

        }catch{
            print(error.localizedDescription)
        }
    }
        task.resume()
        
    }
}
