//
//  Home.swift
//  Todolist
//
//  Created by i'm Tony` on 8/24/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView{
            VStack{
            listRow()// VIỆC GHIM VIEW
            }
            .navigationTitle("Việc đã ghim")
            .onAppear {
                UINavigationBarAppearance()
                    .setColor(title: .white, background: .init(named: "Xanhla"))
            }
            .toolbar {
                Avatar() //VIEW AVATAR
            }
        }
        
    }
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
//MARK: CONTENTLISTVIEW
struct listRow: View {
    @State var models = [ToDoModel]() // BIẾN models CỦA MẢNG ResponseModel TRONG FILE ResponseModel
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? "" //BIẾN User ĐƯỢC LẤY RA TRONG UserDefaults
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect() //BIẾN timer DÙNG ĐỂ LOAD LẠI TỪNG GIÂY
    @State private var showsheet = false //BIẾN SHOW SHEET TRONG SWIFTUI
    @State private var models1: ToDoModel? = nil
    @State private var modelsempty = false
    var body: some View {
       
        VStack{
            if modelsempty {
                VStack{
                    Spacer()
                    Image("Test2")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(contentMode: .fit)
                    Text("Hãy ghim công việc của bạn")
                        .font(.headline)
                        .cornerRadius(5)
                    Spacer()
                }.background(Color.init("Gray1"))
            }else{
                
                if #available(iOS 15.0, *) {
                    List{ // VÒNG LẶP VIỆC ĐÃ GHIM
                        Section(header: Text("Việc của bạn đã ghim")) {
                        ForEach(models){ model in //VÒNG LẶP TODO
                            
                                VStack{
                                    HStack{
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .font(.title2)
                                            .foregroundColor(Color.init("Cam"))
                                        Text("\(model.noidung)")
                                            .font(.title2)
                                        Spacer()
                                        Button {
        //                                       showsheet.toggle()
        //                                       showsheet = true
                                            self.models1 = model
                                        } label: {
                                            Image(systemName: "info.circle")
                                                .foregroundColor(Color.init("White1"))
                                        }
                                       
                                    }
                                    .onTapGesture {
        //                                   showsheet.toggle()
        //                                   showsheet = true
                                        self.models1 = model
                                    }
                                    .sheet(item: self.$models1)  { model in
                                        InfoTodo(noidung: model.noidung, danhsach: model.danhsach, ngaythem: model.ngaythem, ngayth: model.ngayth, checklist: model.checklist, pin: model.pin)
                                    }// SHEET THÔNG TIN THÊM
                                    }
                                         
                                        .padding()
                                        .background(Color.init("White"))
                                        .overlay(
                                         Rectangle()
                                                     .fill(Color.init("Xanhla"))
                                                     .mask(
                                                    HStack {
                                                        Rectangle().frame(width: 7)
                                                        Spacer()
                                                    })
                                                  )
                                        .cornerRadius(3)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                        .padding()
                                        .listRowSeparatorTint(.clear)
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                           
                        }
                        
                        }
                    }
                    .listStyle(.insetGrouped)
                    
                    
                   
                   
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .onReceive(timer, perform: { _ in
            getPin()
           
        })
           
    }
   
    
    func getPin(){ //HÀM GỌI TỪ API
        
        //send request to sever
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/showpin?account="+User.urlEncoded!+"&pin=1&checklist=0")else{
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
struct EmptyListView: View {
    @State var title = String()
    var body: some View {
        Text("\(title)")
            .font(.title)
            .cornerRadius(5)
        Image("Test2")
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(contentMode: .fit)
    }
}
