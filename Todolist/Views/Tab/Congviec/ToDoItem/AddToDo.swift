//
//  AddToDo.swift
//  Todolist
//
//  Created by i'm Tony` on 8/24/21.
//

import SwiftUI

extension String {
    var urlEncoded: String? {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "~-_."))
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
}

struct AddToDo: View {
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
    @State var noidung: String = ""
    @State var ngayth = Date()
    @State var User = ""
    @State var pinToDo = "0"
    @State var models = [ToDoModel]()
    @State var showAlert = false
    @State var activeAlert: ActiveAlert = .first
    @State var messageshow = ""
    @State var namelist: String = ""
    @State var idlist = String()
    @State private var isOn = false

    var body: some View {
        NavigationView{
            ScrollView{
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        Text("\(namelist)")
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
                        DatePicker("", selection: self.$ngayth, in: Date()..., displayedComponents: .date)
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
                                    self.pinToDo = "1"
                                }
                                .toggleStyle(SwitchToggleStyle(tint: Color.init("Xanhla")))
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
                        .background(self.noidung == "" ? Color.gray : Color.init("Cam"))
                        .cornerRadius(10)
                        .shadow(color: self.noidung == "" ? Color.gray : Color.init("Cam").opacity(0.3), radius: 10, x: 0.0, y: 10)
                        .padding()
                    })
                        .alert(isPresented: $showAlert, content: {
                            self.alert
                        })
                        .disabled(self.noidung == "")
                    
                    
                }
            }
            .padding()
            .navigationTitle("Thêm công việc")
            .navigationBarItems(
                trailing:
                    HStack{
                       
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
    func getUser() {
        User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    }
    
    func addToDo(){
        getUser()
        let urltodo = "https://2dolist.website/api/nhiemvu/add"
      // let urlEncodeds = model.noidung.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let dateFormater = DateFormatter()
               
               //Format ngày bạn muốn hiển thị trên Label
        dateFormater.dateFormat = "dd-MM-yyyy"
        let stringDate = dateFormater.string(from: ngayth)
        
        guard  let url = URL(string: "\(urltodo)?user=\(User.urlEncoded!)&noidung=\(noidung.urlEncoded!)&list=\(namelist.urlEncoded!)&ngayth=\(stringDate)&pin=\(pinToDo)&idlist=\(idlist)")else{
            
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
                        return Alert(title: Text("Thông báo"), message: Text("\(self.messageshow)"), dismissButton: .destructive(Text("Đóng"), action: {
                            self.noidung = ""
                        }))
                    case .second:
                        return Alert(title: Text("Thông báo"), message: Text("\(self.messageshow)"), dismissButton: .default(Text("Đóng")))
                    }
    }
}

struct AddToDo_Previews: PreviewProvider {
    static var previews: some View {
        AddToDo(date: .constant(Date()))
    }
}
