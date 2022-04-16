//
//  CongViec.swift
//  Todolist
//
//  Created by i'm Tony` on 8/24/21.
//

import SwiftUI

struct CongViec: View {
    enum ActiveSheet: Hashable {
      case first
      case second
    }

    enum ActiveSheet1 {
       case first1, second1
       var id: Int {
          hashValue
       }
    }
    @State private var _activeSheet: ActiveSheet?
    @State private var showSheet = false
       @State private var activeSheet1: ActiveSheet1? = .first1
//    @State var selected = 0
    @Environment(\.presentationMode) var presentationMode
    @State private var showingSheet = false
    @State var namelist: String = ""
    @State var icon: String = ""
    @State var idList: String = ""
    @State var models = [ToDoModel]()
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var showModal =  false
    @State private var modelsempty = false
    @State private var models1: ToDoModel? = nil
    @State private var showingAlert = false
    @State private var models2: ToDoModel? = nil
    var body: some View {
            NavigationView{
                VStack(spacing: 22){
                    HStack{
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                        Spacer()
                        VStack{
                            Text("Công Việc")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            
                                Text("\(namelist)")
                                    .font(.subheadline)
                                    .foregroundColor(Color.white)
                        }
                        
                        Spacer()
                        Button {
                            self._activeSheet = .first
                        } label: {
                            VStack{
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color.white)
                               
                            }
                        }
                        .sheet(tag: .first, selection: $_activeSheet) {
                            AddToDo(date: .constant(Date()), namelist: namelist, idlist: idList)
                        }
                        .padding()
                        
                    }
                    VStack{
                       
                        if modelsempty {
                            VStack{
                                Spacer()
                                
                                Image("Login")
                                    .resizable()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(contentMode: .fit)
                                Text("Hãy thêm công việc của bạn")
                                    .font(.headline)
                                    .cornerRadius(5)
                                Spacer()
                            }.background(Color.init("Gray1"))
                        }else{
                            List{
                                ForEach(models){model in
                                    if #available(iOS 15.0, *) {
                                        //MARK: ITEM TO DO
                                        HStack{
                                            VStack{
                                                Image(systemName: "circle")
                                                    .foregroundColor(model.pin == "1" ? Color.init("Cam") : Color.init("Xanhla"))
                                            }
                                            .onTapGesture {
                                                finishTodo(item: model)
                                                //MARK: CỬ CHỈ CHỌN VÀO 1 HÌNH (KHỞI CHẠY HÀM CẬP NHẬT CÔNG VIỆC)
                                            }
                                            Text("\(model.noidung)")
                                            
                                            
                                            Spacer()
                                            
                                            
                                        }
                                        //MARK: 2 NÚT HÀNH ĐỘNG BÊN TRÁI
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                if model.pin == "1"{
                                                    unpinTodo(item: model)
                                                }else{
                                                    pinTodo(item: model)
                                                }
                                                
                                            } label: {
                                                Image(systemName: model.pin == "0" ? "pin.circle.fill" : "pin.slash")
                                            }
                                            .tint(Color.init("Cam"))
                                            Button {
                                                self.models1 = model
                                                self.showSheet = true
                                                self.activeSheet1 = .second1
                                            } label: {
                                                Image(systemName: "pencil.circle.fill")
                                            }
                                            .tint(Color.init("Vang"))
                                        }
                                        //MARK: 2 NÚT HÀNH ĐỘNG BÊN PHẢI
                                        .swipeActions {
                                            Button {
                                                self.models1 = model
                                                self.showSheet = true
                                                self.activeSheet1 = .first1
                                            } label: {
                                                    Image(systemName: "info.circle.fill")
                                                        .foregroundColor(Color.white)
                                            }
                                            .tint(Color.init("Xanhla"))
                                            Button {
                                                showingAlert = true
                                                self.models2 = model
                                            } label: {
                                                Image(systemName: "trash.circle.fill")
                                                    .foregroundColor(Color.white)
                                            }.tint(Color.init("Red"))
                                                
                                        }
                                        .alert("Cảnh báo!",
                                              isPresented: $showingAlert,

                                               presenting: models2,

                                                       actions: { model in
                                                      Button("Có", role: .destructive, action: {
                                                          deleteTodo(item: model)
                                                      })
                                                      Button("Huỷ", role: .cancel, action: {})
                                                  
                                                }, message: { model in
                                                    Text("Bạn có chắc bạn muốn xoá nhiệm vụ này")
                                                })
                                        
                                        //MARK: SHEET 2 VIEW EDIT VÀ INFO
                                        .sheet(item: self.$models1) { model in
                                            if self.activeSheet1 == .first1 {
                                            InfoTodo(noidung: model.noidung, danhsach: model.danhsach, ngaythem: model.ngaythem, ngayth: model.ngayth, checklist: model.checklist, pin: model.pin)
                                            }else{
                                                EditTodo(date: .constant(Date()), id: model.id,noidung: model.noidung, danhsach: model.danhsach, ngaythem: model.ngaythem, ngayth: model.ngayth, checklist: model.checklist, pin: model.pin)
                                            }
                                               }
                                        
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    .onReceive(timer, perform: { _ in
                        getTodo()
                        //MARK: CHẠY HÀM GETTODO LIÊN TỤC TRONG MỖI 1S (TIMER)
                    })
                }
                .background(Color("Xanhla").ignoresSafeArea())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
            }
        }
    func deleteTodo(item: ToDoModel) {
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/delete?user="+User.urlEncoded!+"&id="+item.id)else{
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
            }catch{
                print(error.localizedDescription)
            }
        }).resume()
    } //MARK: XOÁ CÔNG VIỆC
    func pinTodo(item: ToDoModel) {
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/pin?idaccount="+User.urlEncoded!+"&id="+item.id+"&pin=1")else{
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
            }catch{
                print(error.localizedDescription)
            }
        }).resume()
    } //MARK: GHIM CÔNG VIỆC
    func unpinTodo(item: ToDoModel) {
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/pin?idaccount="+User.urlEncoded!+"&id="+item.id+"&pin=0")else{
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
            }catch{
                print(error.localizedDescription)
            }
        }).resume()
    }
    //MARK: HOÀN THÀNH CÔNG VIỆC
    func finishTodo(item: ToDoModel) {
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/finish?idaccount="+User.urlEncoded!+"&id="+item.id)else{
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
            }catch{
                print(error.localizedDescription)
            }
        }).resume()

    } //MARK: HOÀN THÀNH TODO
    
    func getTodo() {
        //send request to sever
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/todo?account="+User.urlEncoded!+"&list=\(namelist.urlEncoded!)&check=0&idlist=\(idList)")else{
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

struct CongViec_Previews: PreviewProvider {
    static var previews: some View {
        CongViec()
    }
}

//struct TopBarCongViec : View {
//    @Binding var selected : Int
//    var body: some View{
//        HStack{
//            Button(action: {
//                self.selected = 0
//            }) {
//                Text("")
//                    .fontWeight(.bold)
//                    .padding(.vertical, 12)
//                    .padding(.horizontal,25)
//                    .background(self.selected == 0 ? Color.white : Color.clear)
//                    .clipShape(Capsule())
//
//            }
//            .foregroundColor(self.selected == 0 ? .init("Cam") : .gray)
//            Button(action: {
//                self.selected = 1
//            }) {
//                Text("Ngày Mai")
//                    .fontWeight(.bold)
//                    .padding(.vertical, 12)
//                    .padding(.horizontal,25)
//                    .background(self.selected == 1 ? Color.white : Color.clear)
//                    .clipShape(Capsule())
//            }
//            .foregroundColor(self.selected == 1 ? .init("Cam") : .gray)
//        }
//        .padding(8)
//        .background(Color.init("Gray"))
//        .clipShape(Capsule())
//    }
//}
