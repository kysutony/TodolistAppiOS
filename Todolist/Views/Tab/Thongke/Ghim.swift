//
//  Ghim.swift
//  Ghim
//
//  Created by i'm Tony` on 9/7/21.
//

import SwiftUI

struct Ghim: View {
    var body: some View {
        GhimView()
    }
}

struct Ghim_Previews: PreviewProvider {
    static var previews: some View {
        Ghim()
    }
}
struct GhimView : View{
    @State var models = [ToDoModel]()
    @State var User = ""
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var showsheet = false
    @State private var modelsempty = false
    var body: some View{
        if #available(iOS 15.0, *) {
            HStack{
                Text("Công việc ghim đã hoàn thành")
                    .textCase(.uppercase)
                    .foregroundColor(Color.gray)
                    .padding(.leading)
                    .font(.footnote)
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
                                Image(systemName: "pin.circle.fill")
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
            }.onReceive(timer, perform: { _ in
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
        //GỬI REQUEST TỚI SERVER
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/showpin?account="+User.urlEncoded!+"&pin=1&checklist=1")else{
            print("invalid URL")
            return
        }
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            // KIỂM TRA PHẢN HỒI
            guard let data = data else {
                print("invalid response")
                return
            }
            //CHUYỂN JSON DẠNG CHUỖI VÀO LỚP models
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
