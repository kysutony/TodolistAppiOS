//
//  EditTodo.swift
//  Todolist
//
//  Created by imTony on 12/22/21.
//

import SwiftUI


struct EditTodo: View {
    @Binding var date: Date
    @State private var showPicker: Bool = false
    @State private var selectedDateText: String = "Date"

    private var selectedDate: Binding<Date> {
    Binding<Date>(get: { self.date}, set : {
        self.date = $0
        self.setDateString()
    })
    } // This private var I found… somewhere. I wish I could remember where
      // To take the selected date and store it as a string for the text field
    private func setDateString() {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd, yyyy"

    self.selectedDateText = formatter.string(from: self.date)
    }
    enum ActiveAlert {
        case first, second
    }
    @Environment(\.presentationMode) var presentationMode
    @State var id = String()
    @State var noidung = String()
    @State var danhsach = String()
    @State var ngaythem = String()
    @State var ngayth = String()
    @State var checklist = String()
    @State var pin = String()
    @State var chooseday = Date()
    @State private var isOn = true
    @State var visible = false
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State var ngayupdate = ""
    @State var activeAlert: ActiveAlert = .first
    @State var messageshow = ""
    @State var showAlert = false
 
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                   
                    VStack{
                        HStack{
                            Text("TÊN CÔNG VIỆC")
                                .foregroundColor(Color.gray)
                                .font(.caption)
                                Spacer()
                        }
                        //MARK: TEXTFIELD
                        TextField("Thêm công việc tại đây...", text: self.$noidung)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.init("Gray"))
                            .cornerRadius(10)
                        HStack{
                            Text("TÊN DANH SÁCH")
                                .foregroundColor(Color.gray)
                                .font(.caption)
                                Spacer()
                        }
                        HStack{
                            Text("Danh sách")
                                .foregroundColor(Color.gray)
                                .font(.subheadline)
                            Spacer()
                            Text("\(danhsach)")
                                .foregroundColor(Color.init("Red"))
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.init("Gray"))
                        .cornerRadius(10)
                        HStack{
                            Text("NGÀY THỰC HIỆN")
                                .foregroundColor(Color.gray)
                                .font(.caption)
                                Spacer()
                        }
                        HStack{
                            Text("Thực hiện vào")
                                .foregroundColor(Color.gray)
                                .font(.subheadline)
                            Spacer()
                            if self.visible == true {
                                DatePicker("", selection: self.$chooseday, in: Date()..., displayedComponents: .date)
                            }else{
                                Text("\(ngayth)")
                                    .foregroundColor(Color.gray)
                                    .font(.subheadline)
                            }
                            
                            Button {
                                self.visible.toggle()
                                self.visible = true
                            } label: {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.black)
                            }

    //                        DatePicker("Thực hiện vào:", selection: self.$ngayth, displayedComponents: .date )
                        }
                        .padding()
                        .background(Color.init("Gray"))
                        .cornerRadius(10)
                        HStack{
                            Text("GHIM CÔNG VIỆC")
                                .foregroundColor(Color.gray)
                                .font(.caption)
                                Spacer()
                        }
                        HStack{
                            Text("Ghim việc quan trọng")
                                .foregroundColor(Color.gray)
                                .font(.subheadline)
                            
                            Toggle("", isOn: $isOn)
                                    .onChange(of: isOn) { _isOn in
                                        if isOn == true {
                                            self.pin = "1"
                                        }else{
                                            self.pin = "0"
                                        }
                                        
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: Color.init("Xanhla")))
                        }
                        .padding()
                        .background(Color.init("Gray"))
                        .cornerRadius(10)
                        
                        Button(action: {
                            updateTodo()
                            self.showAlert = true
                        }, label: {
                            HStack{
                                Text("Lưu")
                                    .foregroundColor(Color.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(self.noidung == "" ? Color.gray : Color.init("Cam"))
                            .cornerRadius(10)
                            .shadow(color: self.noidung == "" ? Color.gray : Color.init("Cam").opacity(0.3), radius: 10, x: 0.0, y: 10)
                            .padding()
                        })
                            .alert(isPresented: $showAlert, content: {
                                self.alert
                            })
                            .disabled(self.noidung == "")
                        
                        
                    }.padding()
                    Spacer()
                }
                .navigationTitle("Sửa công việc")
                .onAppear {
                    UINavigationBarAppearance()
                        .setColor(title: .white, background: .init(named: "Xanhla"))
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
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
        
    }
    func updateTodo() {
        let urltodo = "https://2dolist.website/api/nhiemvu/updatetodo"
      // let urlEncodeds = model.noidung.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let dateFormater = DateFormatter()
               
               //Format ngày bạn muốn hiển thị trên Label
        dateFormater.dateFormat = "dd-MM-yyyy"
        let stringDate = dateFormater.string(from: chooseday)
        
        if self.visible == true {
            self.ngayupdate = stringDate
        }else{
            self.ngayupdate = ngayth
        }
        guard  let url = URL(string: "\(urltodo)?id=\(id)&user=\(User.urlEncoded!)&noidung=\(self.noidung.urlEncoded!)&ngayth=\(self.ngayupdate)&pin=\(self.pin)")else{
            
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
    var alert: Alert{
        switch activeAlert {
                    case .first:
            return Alert(title: Text("Thông báo"), message: Text("\(self.messageshow)"), dismissButton: .destructive(Text("Đóng"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
                    case .second:
                        return Alert(title: Text("Thông báo"), message: Text("\(self.messageshow)"), dismissButton: .default(Text("Đóng")))
                    }
    }
}

struct EditTodo_Previews: PreviewProvider {
    static var previews: some View {
        EditTodo(date: .constant(Date()))
    }
}
