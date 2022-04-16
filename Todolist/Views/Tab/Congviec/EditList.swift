//
//  EditList.swift
//  Todolist
//
//  Created by imTony on 12/22/21.
//

import SwiftUI

struct EditList: View {
    enum ActiveAlert {
        case first, second
    }
    @State var id = String()
    @State var namelist = String()
    @State var icon = String()
    @State var newnamelist = String()
    @Environment(\.presentationMode) var presentationMode
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State var activeAlert: ActiveAlert = .first
    @State var messageshow = ""
    @State var showAlert = false
    var body: some View {
        NavigationView{
                VStack{
                    VStack{
                        HStack{
                            Text("TÊN DANH SÁCH")
                                .foregroundColor(Color.gray)
                                .font(.caption)
                                Spacer()
                        }
                        //MARK: TEXTFIELD
                        TextField("Nhập tên danh sách tại đây...", text: self.$newnamelist)
                            .padding()
                            .frame(maxWidth: .infinity)
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
                                updateList()
                                self.showAlert = true
                            }, label: {
                                HStack{
                                    Text("Lưu")
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
                               
                        
                    }.padding()
                    Spacer()
            }
            .navigationTitle("Sửa danh sách")
            .onAppear {
                UINavigationBarAppearance()
                    .setColor(title: .white, background: .init(named: "Xanhla"))
            }
            .toolbar {
                Button{
                  
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.white)
                        .font(.headline)
                }
            }
        }
        
    }
    func updateList(){
        
        let urltodo = "https://2dolist.website/api/danhsach/update.php"
        guard  let url = URL(string: "\(urltodo)?id=\(self.id)&account=\(User.urlEncoded!)&namelist=\(self.namelist.urlEncoded!)&newnamelist=\(self.newnamelist.urlEncoded!)&icon=\(self.icon)")else{
            
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
                self.activeAlert = .first
                self.messageshow = shellys.message
            }else{
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
                        return Alert(title: Text("Thông báo"), message: Text("\(self.messageshow)"), dismissButton: .destructive(Text("Đóng"), action: {
                            presentationMode.wrappedValue.dismiss()
                            AppState.shared.resetID = UUID()
                        }))
                    case .second:
                        return Alert(title: Text("Thông báo"), message: Text("\(self.messageshow)"), dismissButton: .default(Text("Đóng")))
                    }
    }
}

struct EditList_Previews: PreviewProvider {
    static var previews: some View {
        EditList()
    }
}
