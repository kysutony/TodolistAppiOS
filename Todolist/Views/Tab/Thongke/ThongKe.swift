//
//  ThongKe.swift
//  Todolist
//
//  Created by i'm Tony` on 8/24/21.
//

import SwiftUI
import UIKit

struct ThongKe: View {
    enum ActiveAlertSign {
        case first, second
    }
    @State var selected = 0
    @State var User = ""
    @State var showAlertSign = false
    @State var activeAlertSign: ActiveAlertSign = .first
    @State var messageshow = ""
    var body: some View {

        NavigationView{
            VStack{
                
                TopBarCongViec(selected: self.$selected)
                    .padding()
                if self.selected == 0 {
                    Ghim()
                }else{
                    ThongKeView()
                }
            }
            .background(Color("Gray1"))
            .navigationBarTitle("Thống Kê")
            .onAppear {
                UINavigationBarAppearance()
                    .setColor(title: .white, background: .init(named: "Xanhla"))
            }
            .navigationBarItems(
                trailing:
                    Button {
                        delete()
                        self.showAlertSign = true
                    } label: {
                        Image(systemName: "xmark.app.fill")
                            .foregroundColor(Color.white)
                    }
                    .alert(isPresented: $showAlertSign, content: {
                        self.alert
                    })
            )
        }
        
    }
    func getUser() {
        User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    }
    func delete() {
        getUser()
        let url = URL(string: "https://2dolist.website/api/nhiemvu/deletedone.php?user="+User)
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
                self.activeAlertSign = .first
            }else{
                
                self.activeAlertSign = .second
            }

        }catch{
            print(error.localizedDescription)
        }
    }
        task.resume()
    }
    var alert: Alert{
        switch activeAlertSign {
                    case .first:
                        return Alert(title: Text("Thông báo"), message: Text("Đã xoá nhiệm vụ đã hoàn thành"), dismissButton: .default(Text("Đóng")))
                    case .second:
                        return Alert(title: Text("Thông báo"), message: Text("Không có việc đã hoàn thành"), dismissButton: .default(Text("Đóng")))
                    }
    }
}

struct ThongKe_Previews: PreviewProvider {
    static var previews: some View {
        ThongKe()
    }
}

struct ThongKeView : View{
    @State var models = [ToDoModel]()
    @State var User = ""
    @State private var showsheet = false
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var modelsempty = false
    var body: some View{
        if #available(iOS 15.0, *) {
            HStack{
                Text("Công việc thường đã hoàn thành")
                    .textCase(.uppercase)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .padding(.leading)
                Spacer()
            }
            VStack{
                if modelsempty {
                    VStack{
                        Spacer()
                        
                        Image("Test1")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(contentMode: .fit)
                        Text("Hãy hoàn thành công việc của bạn")
                            .font(.headline)
                            .cornerRadius(5)
                        Spacer()
                    }.background(Color.init("Gray1"))
                }else{
                List(models){model in
                    HStack{
                        Image(systemName: model.checklist == "0" ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                            .foregroundColor(model.checklist == "0" ? Color.init("Cam") : Color.init("Xanhla") )
                        Text("\(model.noidung)")
                        Spacer()
                        Button {
                            showsheet.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .sheet(isPresented: $showsheet, content: {
                            InfoTodo(noidung: model.noidung, danhsach: model.danhsach, ngaythem: model.ngaythem, ngayth: model.ngayth, checklist: model.checklist, pin: model.pin)
                        })
                        
                    }
                }
                }
            }
                
            
            .onReceive(timer, perform: { _ in
                getTodo()
            })
           
            
        } else {
            // Fallback on earlier versions
        }
    }
    func getUser() {
        User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    }
    func getTodo() {
        getUser()
        //send request to sever
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/showpin?account="+User.urlEncoded!+"&pin=0&checklist=1")else{
            print("invalid URL")
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
            //convert JSON response into class model as an array
            do{
                self.models = try JSONDecoder().decode([ToDoModel].self, from: data)
                if self.models.count == 0 {
                    self.modelsempty = true
                }else{
                    self.modelsempty = false
                }
            }catch{
                print(error.localizedDescription)
            }
        }).resume()
    }
}
struct TopBarCongViec : View {
    @Binding var selected : Int
    var body: some View{
        HStack{
            Button(action: {
                self.selected = 0
            }) {
                Image(systemName: "pin.circle.fill")
                    .padding(.vertical, 8)
                    .padding(.horizontal,15)
                    .background(self.selected == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
                
            }
            .foregroundColor(self.selected == 0 ? .init("Cam") : .gray)
            Button(action: {
                self.selected = 1
            }) {
                Image(systemName: "list.bullet.below.rectangle")
                    .padding(.vertical, 8)
                    .padding(.horizontal,15)
                    .background(self.selected == 1 ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }
            .foregroundColor(self.selected == 1 ? .init("Cam") : .gray)
        }
        .padding(5)
        .background(Color.init("Gray3"))
        .clipShape(Capsule())
    }
}
