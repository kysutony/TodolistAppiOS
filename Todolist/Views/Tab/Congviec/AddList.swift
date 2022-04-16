//
//  AddList.swift
//  Todolist
//
//  Created by i'm Tony` on 10/18/21.
//

import SwiftUI

struct AddList: View {
    enum ActiveAlert {
        case first, second
    }
    @Environment(\.presentationMode) var presentationMode
    @State var namelist: String = ""
    @State var icon: String = "gear"
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State var activeAlert: ActiveAlert = .first
    @State var messageshow = ""
    @State var addtodolist: String = ""
    @State var showAlert = false
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    HStack{
                        Text("TÊN DANH SÁCH")
                            .foregroundColor(Color.gray)
                            .font(.caption)
                            Spacer()
                    }
                    //MARK: TEXTFIELD
                    TextField("Nhập tên danh sách tại đây...", text: self.$namelist)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.init("Gray"))
                        .cornerRadius(10)
                    HStack{
                        Text("ICON DANH SÁCH")
                            .foregroundColor(Color.gray)
                            .font(.caption)
                            Spacer()
                    }
                    HStack{
                        Text("Chọn 1 icon")
                            .foregroundColor(Color.gray)
                            .font(.subheadline)
                        Button {
                            self.icon = chooseRandomImage()
                        } label: {
                            Image(systemName: "shuffle.circle.fill")
                                .foregroundColor(Color.init("Xanhla"))
                        }
                        Spacer()
                        Image(systemName: icon)
                            .foregroundColor(Color.init("Red"))
                        Spacer()
                    }
                    .padding()
                    .background(Color.init("Gray"))
                    .cornerRadius(10)
                        Button(action: {
                            addToDo()
                            self.showAlert = true
                        }, label: {
                            HStack{
                                Text("Thêm")
                                .foregroundColor(Color.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(self.namelist == "" ? Color.gray : Color.init("Red"))
                            .cornerRadius(10)
                            .shadow(color: self.namelist == "" ? Color.gray : Color.init("Red").opacity(0.3), radius: 10, x: 0.0, y: 10)
                            .padding()
                        })
                        .alert(isPresented: $showAlert, content: {
                            self.alert
                        })
                        .disabled(self.namelist == "")
                           
                    
                }
            }
            .padding()
            .navigationTitle("Thêm danh sách")
            .navigationBarItems(
                trailing:
                    HStack{
//                        Button {
//                            getUser()
//                            presentationMode.wrappedValue.dismiss()
//                        } label: {
//                            Text("Xong")
//                                .foregroundColor(Color.init("Xanhla"))
//                        }
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.white)
                                .font(.headline)
                        }
                    }
                )
        }
    }
    func addToDo(){
        let urltodo = "https://2dolist.website/api/danhsach/addlist"
        guard  let url = URL(string: "\(urltodo)?account=\(User.urlEncoded!)&namelist=\(namelist.urlEncoded!)&icon=\(self.icon)")else{
            
            return
        }
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            // check if response is okay
            guard let data = data else {
                print("invalid response")
                return
            }
            
            struct Model: Decodable {
                var message : String
                var success : Bool
            }
        let decoder = JSONDecoder()
        do{
            let shellys = try decoder.decode(Model.self, from: data)
           
            if shellys.success == true{
                print(shellys.message)
                self.activeAlert = .first
                self.messageshow = shellys.message
            }else{
                print(shellys.message)
                self.activeAlert = .second
                self.messageshow = shellys.message
            }
        }catch{
            print(error.localizedDescription)
        }
        }).resume()
    }
    var images = ["tray","eye" ,"book","person","lightbulb", "pencil", "folder", "paperclip", "link" ,"moon", "cloud" ,"heart" ,"star", "flag" ,"tag" ,"camera" ,"bookmark", "gear", "command", "sunrise", "tornado","phone","envelope", "bag", "cart","hammer", "house", "clock", "alarm"]
    func chooseRandomImage() -> String {
        let array = images

        let result = array.randomElement()!

        return result
    }
    var alert: Alert{
        switch activeAlert {
                    case .first:
                        return Alert(title: Text("Thông báo"), message: Text("\(self.messageshow)"), dismissButton: .default(Text("Đóng"), action: {
                            self.namelist = ""
                        }))
                    case .second:
                        return Alert(title: Text("Thông báo"), message: Text("\(self.messageshow)"), dismissButton: .default(Text("Đóng")))
                    }
    }
}

struct AddList_Previews: PreviewProvider {
    static var previews: some View {
        AddList()
    }
}
