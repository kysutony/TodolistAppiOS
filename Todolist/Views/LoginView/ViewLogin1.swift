////
////  Login.swift
////  Todolist
////
////  Created by i'm Tony` on 8/24/21.
////
//
//import SwiftUI
//
//struct ViewLogin1: View {
//    var body: some View {
//       login()
//        
//    }
//}
//
//struct login : View {
//    @State private var username: String = ""
//    @State private var password: String = ""
//    @State private var showAlert = false
//    @State var SaveName = ""
//    var body : some View{
//        ScrollView {
//            ZStack{
//                VStack{
//                    HStack(alignment: .top, spacing: 0){
//                        Image("Login")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 150, height: 150, alignment: .center)
//                        
//                    }
//                    VStack{
//                        Text("\(SaveName)")
//                            .bold()
//                            .onAppear(perform: {
//                                getData()
//                            })
//                        Button(action: {
//                            deleteData()
//                        }, label: {
//                            Text("Đăng Xuất")
//                        })
//                    }
//                    
//                    VStack(alignment: .leading){
//                        VStack{
//                            HStack{
//                                Text("Tên người dùng:")
//                                    .font(.callout)
//                                    .fontWeight(.medium)
//                                    .foregroundColor(Color.init("Xanhla"))
//                                Spacer()
//                            }
//                            .padding()
//                            TextField("Nhập tên đăng nhập tại đây",text:$username)
//                                .padding()
//                                .background(Color.init("Gray"))
//                                .cornerRadius(10)
//                                .padding()
//                        }
//                        VStack{
//                            HStack{
//                                Text("Mật khẩu:")
//                                    .font(.callout)
//                                    .fontWeight(.medium)
//                                    .foregroundColor(Color.init("Xanhla"))
//                                Spacer()
//                            }
//                            .padding()
//                            SecureField("Nhập mật khẩu tại đây",text:$password)
//                                .padding()
//                                .background(Color.init("Gray"))
//                                .cornerRadius(10)
//                                .padding()
//                            
//                        }
//                        HStack{
//                            Spacer()
//                            if #available(iOS 15.0, *) {
//                                Button(action: {
//                                    saveUser()
//                                }, label: {
//                                    Text("Đăng nhập")
//                                        .foregroundColor(Color.white)
//                                })
//                                    .refreshable {
//                                        saveUser()
//                                    }
//                                    .alert(isPresented: $showAlert, content: {
//                                        Alert(
//                                            title: Text("Thông báo"),
//                                            message: Text("Đăng nhập thành công")
//                                        )
//                                    })
//                            } else {
//                                // Fallback on earlier versions
//                            }
//                            Spacer()
//                        }
//                        .padding()
//                        .background(Color.init("Cam"))
//                        .cornerRadius(10)
//                        .padding()
//                    }
//                }
//            }
//            .background(Color.white)
//        }
//        
//    }
//    func saveUser() {
//        let url = URL(string: "https://2dolist.website/api/sign.php?user="+username+"&pass="+password)
//        guard let requestUrl = url else { fatalError()}
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = "GET"
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error{
//                print ("Error took place\(error)")
//                return
//            }
//            struct Model: Decodable {
//                var success: Bool
//                var message : String
//            }
//        let decoder = JSONDecoder()
//        do{
//            let shellys = try decoder.decode(Model.self, from: data!)
//            if shellys.success == true{
//                UserDefaults.standard.set(self.username, forKey: "UserName")
//                print(shellys.message)
//                showAlert = true
//            }else{
//                print(shellys.message)
//            }
//            
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
//        task.resume()
//}
//    
//    func getData() {
//       
//        SaveName =  "Tên Tài Khoản: \(UserDefaults.standard.string(forKey: "UserName") ?? "")"
//    }
//    func deleteData() {
//        UserDefaults.standard.removeObject(forKey: "UserName")
//    }
//}
//
//struct Login_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewLogin1()
//    }
//}
