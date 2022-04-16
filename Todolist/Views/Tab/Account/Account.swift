//
//  SignIn.swift
//  SignIn
//
//  Created by i'm Tony` on 9/2/21.
//

import SwiftUI

//MARK: VIEW TỔNG
struct Account: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var height : CGFloat = 0
    var body: some View {
        NavigationView{
            
                VStack{
                    if self.status{
                        TabView()
                    }else{
                        ZStack{
                            NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                                Text("")
                            }
                            .hidden()
                            Login(show: self.$show)
                        }
                        
                    }
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                        self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    }
                    
                
            }
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        Account()
    }
}
//MARK: VIEW ĐĂNG NHẬP
struct Login: View {
    enum ActiveAlertSign {
        case first, second
    }
    @Binding var show: Bool
    @State var color = Color.black.opacity(0.7)
    @State var username = ""
    @State var password = ""
    @State var visible = false
    @State var showAlertSign = false
    @State var activeAlertSign: ActiveAlertSign = .first
    @State var messageshow = ""
    var body: some View{
        ScrollView{
            ZStack(alignment: .topTrailing){
               
                    VStack{
                        HStack(alignment: .top, spacing: 0){
                            Image("Login")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150, alignment: .center)
                                }
                        Text("Hãy đăng nhập tài khoản!")
                            .font(.title)
                            .fontWeight(.bold)
                            
                            .padding(.top, 35)
                        TextField("Tên đăng nhập", text: self.$username)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.username != "" ? Color.init("Cam") : Color.init("White1"), lineWidth: 2))
                            .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            VStack{
                                if self.visible{
                                    TextField("Mật khẩu", text: self.$password)
                                }else{
                                    SecureField("Mật khẩu", text: self.$password)
                                }
                            }
                            Button {
                                self.visible.toggle()
                            } label: {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(Color.init("White1"))
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color.init("Cam") : Color.init("White1"), lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack{
                            Spacer()
//                            Button {
//
//                            } label: {
//                                Text("Quên mật khẩu")
//                                    .fontWeight(.bold)
//                                    .foregroundColor(Color.init("Cam"))
//                            }
                            Link("Quên mật khẩu", destination: URL(string: "https://2dolist.website/forgetpassword.php")!)
                                .font(.subheadline)
                                .foregroundColor(Color.init("Cam"))
                        }
                        .padding(.top, 20)
                        Button {
//                            self.verify()
                            self.saveUser()
                            self.showAlertSign = true
                        } label: {
                            Text("Đăng Nhập")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(self.username == "" || self.password == "" ? Color.gray : Color.init("Cam"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        .shadow(color: self.username == "" || self.password == "" ? Color.gray.opacity(0.5) : Color.init("Cam").opacity(0.5), radius: 10, x: 0, y: 10)
                        .disabled(self.username == "" || self.password == "")
                        .alert(isPresented: $showAlertSign, content: {
                            self.alert
                        })
                    }
                    .padding(.horizontal, 25)
               
                Button(action: {
                    self.show.toggle()
                }, label: {
                    Text("Đăng Ký")
                        .fontWeight(.bold)
                        .foregroundColor(Color.init("Cam"))
                })
                .padding()
            }//

        }
        
    }
    func saveUser() {
            let url = URL(string: "https://2dolist.website/api/sign.php?user="+username.urlEncoded!+"&pass="+password.urlEncoded!)
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
                    var message : String
                }
            let decoder = JSONDecoder()
            do{
                let shellys = try decoder.decode(Model.self, from: data!)
                if shellys.success == true{
                    
                    UserDefaults.standard.set(self.username.lowercased(), forKey: "UserName")
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                    self.messageshow = shellys.message
                    self.activeAlertSign = .first
                }else{
                    
                    self.messageshow = shellys.message
                    self.activeAlertSign = .second
                }
    
            }catch{
                print(error.localizedDescription)
            }
        }
            task.resume()
    } //MARK: LƯU THÔNG TIN NGƯỜI DÙNG VÀO USERDEFAULD
    var alert: Alert{
        switch activeAlertSign {
                    case .first:
            return Alert(title: Text("Thông báo!"), message: Text("\(messageshow)"), dismissButton: .default(Text("Đóng"), action: {
                self.messageshow = ""
            }))
                    case .second:
            return Alert(title: Text("Thông báo!"), message: Text("\(messageshow)"), dismissButton: .default(Text("Đóng"), action: {
                self.messageshow = ""
            }))
                    }
    }
//    func verify() {
//        if self.username != "" && self.password != "" {
//
//        }else{
//            self.error = "Hãy điền đầy đủ thông tin"
//            self.alert.toggle()
//        }
//    }
}

//MARK: VIEW ĐĂNG KÝ
struct SignUp: View {
    enum ActiveAlertSign {
        case first1, second1
    }
    @Binding var show : Bool
    @State var color = Color.black.opacity(0.7)
//    @StateObject private var formViewModel = FormViewModel()
    @State var username = ""
    @State var password = ""
    @State var repassword = ""
    
    @State var visible = false
    @State var revisible = false
    @State var showAlertSign = false
    @State var activeAlertSign: ActiveAlertSign = .first1
    @State var messageshow = ""
    @State private var emailString  : String = ""
    @State  var email : String = ""
    @State private var isEmailValid : Bool   = true
    var body: some View{
        ScrollView{
            ZStack(alignment: .topLeading){
                
                    VStack{
                        HStack(alignment: .top, spacing: 0){
                            Image("SignUp")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150, alignment: .center)
                                }
                        Text("Hãy đăng nhập tài khoản!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 35)
                        TextField("Tên đăng nhập", text: self.$username)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke( self.username != "" ? Color.init("Cam") : Color.init("White1"), lineWidth: 2))
                            .padding(.top, 25)
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
                            .background(RoundedRectangle(cornerRadius: 4).stroke( self.email != "" ? Color.init("Cam") : Color.init("White1"), lineWidth: 2))
                            .padding(.top, 25)
                        if !self.isEmailValid {
                                    Text("Email không đúng")
                                        .font(.callout)
                                        .foregroundColor(Color.red)
                                }
                        HStack(spacing: 15){
                            VStack{
                                if self.visible{
                                    TextField("Mật khẩu", text: self.$password)
                                }else{
                                    SecureField("Mật khẩu", text: self.$password)
                                }
                            }
                            Button {
                                self.visible.toggle()
                            } label: {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(Color.init("White1"))
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color.init("Cam") : Color.init("White1"), lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            VStack{
                                if self.revisible{
                                    TextField("Nhập lại", text: self.$repassword)
                                }else{
                                    SecureField("Nhập lại", text: self.$repassword)
                                }
                            }
                            Button {
                                self.revisible.toggle()
                            } label: {
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(Color.init("White1"))
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repassword != "" ? Color.init("Cam") : Color.init("White1"), lineWidth: 2))
                        .padding(.top, 25)
                        
                        Button {
                            addUser()
                            self.showAlertSign = true
                        } label: {
                            Text("Đăng Ký")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(self.username == "" || self.password == "" || self.repassword == "" || self.email == "" || !self.isEmailValid ? Color.gray : Color.init("Cam"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        .shadow(color: self.username == "" || self.password == "" || self.repassword == "" || self.email == "" || !self.isEmailValid ? Color.gray.opacity(0.5) : Color.init("Cam").opacity(0.5), radius: 10, x: 0, y: 10)
                        .alert(isPresented: $showAlertSign, content: {
                            self.alert
                        })
                        .disabled(self.username == "" || self.password == "" || self.repassword == "" || self.email == "" || !self.isEmailValid)
                    }
                    .padding(.horizontal, 25)
                
                Button(action: {
                    self.show.toggle()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color.init("Cam"))
                })
                .padding()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
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
    func addUser() {
        let url = URL(string: "https://2dolist.website/api/user/create?user="+username.urlEncoded!+"&pass="+password.urlEncoded!+"&repass="+repassword.urlEncoded!+"&email="+self.email.urlEncoded!)
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
                var message : String
            }
        let decoder = JSONDecoder()
        do{
            let shellys = try decoder.decode(Model.self, from: data!)
            if shellys.success == true{
                print(shellys.message)
                self.messageshow = shellys.message
                self.activeAlertSign = .first1
            }else{
                print(shellys.message)
                self.messageshow = shellys.message
                self.activeAlertSign = .second1
            }

        }catch{
            print(error.localizedDescription)
        }
    }
        task.resume()
    }
    var alert: Alert{
        switch activeAlertSign {
                    case .first1:
            return Alert(title: Text("Thông báo!"), message: Text("\(messageshow)"), dismissButton: .default(Text("Đóng"), action: {
                self.messageshow = ""
            }))
                    case .second1:
            return Alert(title: Text("Thông báo!"), message: Text("\(messageshow)"), dismissButton: .default(Text("Đóng"), action: {
                self.messageshow = ""
            }))
                    }
    }
}
