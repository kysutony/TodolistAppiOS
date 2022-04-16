//
//  EditInfo.swift
//  Todolist
//
//  Created by imTony on 12/28/21.
//

import SwiftUI

struct EditInfo: View {
    enum ActiveAlert {
        case first, second
    }
    @State var avatarapi = String()
    @Environment(\.presentationMode) var presentationMode
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State private var emailString  : String = ""
    @State  var email : String = ""
    @State private var isEmailValid : Bool   = true
    @State var showAlert = false
    @State var activeAlert: ActiveAlert = .first
    @State var messageshow = ""
    @State var newpassword = ""
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    VStack{
                        HStack{
                            Text("tên người dùng")
                                .textCase(.uppercase)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                Spacer()
                        }
                        HStack{
                            Text("người dùng")
                                .textCase(.uppercase)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                Spacer()
                            Text("\(User)")
                                .foregroundColor(Color.init("Xanhla"))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.init("Gray"))
                        .cornerRadius(10)
                        //MARK: TEXTFIELD
                        HStack{
                            Text("email")
                                .textCase(.uppercase)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                Spacer()
                            
                        }
                        TextField("Email dự phòng", text: self.$email, onEditingChanged: { (isChanged) in
                                    if !isChanged {
                                        if self.textFieldValidatorEmail(self.email) {
                                            self.isEmailValid = true
                                        } else {
                                            self.isEmailValid = false
                                            self.email = ""
                                        }
                                    }
                                })
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.init("Gray"))
                            .cornerRadius(10)
                        if !self.isEmailValid {
                                    Text("Email không đúng")
                                        .font(.callout)
                                        .foregroundColor(Color.red)
                                }
                        HStack{
                            Text("avatar")
                                .textCase(.uppercase)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                Spacer()
                        }
                        HStack{
                            Text("Chọn 1 avatar")
                                .foregroundColor(Color.gray)
                                .font(.subheadline)
                            Button {
                                self.avatarapi = chooseRandomAvatar()
                            } label: {
                                Image(systemName: "shuffle.circle.fill")
                                    .foregroundColor(Color.init("Xanhla"))
                            }
                            Spacer()
                            if #available(iOS 15.0, *) {
                                AsyncImage(url: URL(string: "https://2dolist.website/asset/icon/\(avatarapi).png")!) { images in
                                    if let image = images.image{
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    }else if images.error != nil{
                                        Image(systemName: "photo.fill")
                                    }else{
                                        ProgressView()
                                    }
                                    
                                }
                                .frame(width: 33, height: 33, alignment: .center)
                                .cornerRadius(7)
                            } else {
                                // Fallback on earlier versions
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.init("Gray"))
                        .cornerRadius(10)
                        HStack{
                            Text("mật khẩu mới")
                                .textCase(.uppercase)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                Spacer()
                        }
                        SecureField("Nhập mật khẩu mới tại đây...", text: self.$newpassword)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.init("Gray"))
                                .cornerRadius(10)
                            Button(action: {
                               
                                editInfo()
                                self.showAlert = true
                            }, label: {
                                HStack{
                                    Text("Lưu")
                                    .foregroundColor(Color.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(self.email == "" ? Color.gray : Color.init("Xanhla"))
                                .cornerRadius(10)
                                .shadow(color: self.email == "" ? Color.gray : Color.init("Xanhla").opacity(0.3), radius: 10, x: 0.0, y: 10)
                                .padding()
                            }).alert(isPresented: $showAlert, content: {
                                self.alert
                            })
                            
                            
                               
                        
                    }.padding()
                    Spacer()
            }
            .navigationTitle("Sửa thông tin")
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
    }
    var IntAvatar = ["0","1", "2", "3", "4", "5", "6" ,"7", "8","9", "10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    func chooseRandomAvatar() -> String {
        let array = IntAvatar

        let result = array.randomElement()!

        return result
    }
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    func editInfo() {
        let urltodo = "https://2dolist.website/api/user/update.php"
        guard  let url = URL(string: "\(urltodo)?user=\(User.urlEncoded!)&email=\(email.urlEncoded!)&avatar=\(self.avatarapi)&password=\(self.newpassword)")else{
            
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
    var alert: Alert{
        switch activeAlert {
                    case .first:
                        return Alert(title: Text("Thông báo"), message: Text("\(self.messageshow)"), dismissButton: .default(Text("Đóng"), action: {
                            presentationMode.wrappedValue.dismiss()
                        }))
                    case .second:
                        return Alert(title: Text("Thông báo"), message: Text("\(self.messageshow)"), dismissButton: .default(Text("Đóng"), action: {
                            self.email = ""
                        }))
                    }
    }
}

struct EditInfo_Previews: PreviewProvider {
    static var previews: some View {
        EditInfo()
    }
}
