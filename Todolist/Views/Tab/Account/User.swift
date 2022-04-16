//
//  User.swift
//  Todolist
//
//  Created by i'm Tony` on 9/21/21.
//

import SwiftUI

struct User: View {
    @State var AvatarUser: String = ""
//    @State var model = UserAvatar()
    @State var avatarApi = String()
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var email = String()
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State private var showingSheet = false
    @State private var showingAlert = false
    var body: some View {
            NavigationView{
                    VStack{
                        List{
                            Section(header: Text("")) {
                                HStack{
                                    Spacer()
                                    if #available(iOS 15.0, *) {
                                        AsyncImage(url: URL(string: "https://2dolist.website/asset/icon/\(avatarApi).png")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 150, height: 150, alignment: .center)
                                        .cornerRadius(10)
                                        .onReceive(timer, perform: { _ in
                                            getAvatarUser()
                                        })
                                        
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                    Spacer()
                                }
                                HStack{
                                        Image(systemName: "tag.square.fill")
                                            .foregroundColor(Color.init("Xanhla"))
                                   
                                    Text("Tên người dùng:")
                                        
                                    Spacer()
                                    Text("\(User)")
                                        
                                    }
                                HStack{
                                    Image(systemName: "envelope")
                                        .foregroundColor(Color.init("Xanhla"))
                               
                                Text("Email")
                                    
                                Spacer()
                                Text("\(email)")
                                        .onReceive(timer, perform: { _ in
                                            getEmail()
                                        })
                                }
                                Button {
                                    showingAlert = true
                                } label: {
                                    HStack{
                                        Text("Đăng xuất")
                                        .foregroundColor(Color.white)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.init("Cam2"))
                                    .cornerRadius(10)
                                    .shadow(color: Color.init("Cam").opacity(0.3), radius: 10, x: 0.0, y: 10)
                                    .padding()
                                }
                                .padding()
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text("Cảnh báo!"), message: Text("Bạn có chắc bạn muốn đăng xuất"),
                                          
                                          primaryButton: .default(Text("Huỷ"), action: {
                                                 
                                             }),
                                          secondaryButton: .destructive(Text("Có"), action: {
                                                 UserDefaults.standard.removeObject(forKey: "UserName")
                                                 UserDefaults.standard.set(false, forKey: "status")
                                                 NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                                                 self.avatarApi = ""
                                                 self.User = ""
                                                      })
                                    )
                                }
                            }
                            
                        }
                        .listStyle(.insetGrouped)
                        
                        
                    }
                    
                    .navigationTitle("Tài khoản")
                    .onAppear {
                        UINavigationBarAppearance()
                            .setColor(title: .white, background: .init(named: "Xanhla"))
                    }
                    .toolbar {
                        Button {
                            showingSheet = true
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(Color.white)
                                
                        }
                        .sheet(isPresented: $showingSheet ,content: {
                            EditInfo(avatarapi: avatarApi, email: email)
                        })
                    }
                  
                    
                
            }
            
            
            
        
        
    }
    func getAvatarUser() {
        let url = URL(string: "https://2dolist.website/api/user/getavatar?user="+User.urlEncoded!)
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
                var avt : String
            }
        let decoder = JSONDecoder()
        do{
            let shellys = try decoder.decode(Model.self, from: data!)
            if shellys.success == true{
                self.avatarApi = shellys.avt
            }else{
                print("error")
            }

        }catch{
            print(error.localizedDescription)
        }
    }
        task.resume()
    }
    func getEmail() {
        let url = URL(string: "https://2dolist.website/api/user/email?user="+User.urlEncoded!)
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
                var email : String
            }
        let decoder = JSONDecoder()
        do{
            let shellys = try decoder.decode(Model.self, from: data!)
            if shellys.success == true{
                self.email = shellys.email
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

struct User_Previews: PreviewProvider {
    static var previews: some View {
        User()
    }
}
