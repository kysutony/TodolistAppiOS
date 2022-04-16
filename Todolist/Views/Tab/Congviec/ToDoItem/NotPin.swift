//
//  NotPin.swift
//  Todolist
//
//  Created by i'm Tony` on 10/21/21.
//

import SwiftUI

struct NotPin: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingSheet = false
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
                }
                
                HStack{
                    Text("Việc thường")
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                VStack{
                    contentNotPin()
                }
            }
            .background(Color("Xanhla").ignoresSafeArea())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
        }
    }
}

struct NotPin_Previews: PreviewProvider {
    static var previews: some View {
        NotPin()
    }
}

struct contentNotPin: View {
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State var models = [ToDoModel]()
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var body: some View {
        if #available(iOS 15.0, *) {
            List(models){ model in
                    HStack{
                        Image(systemName: "circle.fill")
                            .foregroundColor( Color.init("Xanhla"))
                        Text("\(model.noidung)")
                        Spacer()
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {
                            
                                pinTodo(item: model)
                            
                            
                           
                        } label: {
                            Image(systemName:"pin.circle.fill")
                        }
                        .tint(Color.init("Cam"))
                    }
                    .swipeActions {
                        Button {
                            updateTodo(item: model)
                        } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.white)
                        }
                        .tint(Color.init("Xanhla"))
                        Button {
                            deleteTodo(item: model)
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .foregroundColor(Color.white)
                        }.tint(Color.init("Red"))

                    } //MARK: 2 NÚT HÀNH ĐỘNG BÊN PHẢI
                
            }
            .onReceive(timer, perform: { _ in
                getPin()
            })
            .refreshable {
                getPin()
            }
            .onAppear() {
                getPin()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    func getPin(){
        //send request to sever
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/showinlistpin?account="+User.urlEncoded!+"&check=0&pin=0")else{
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
    } //MARK: GHIM TODO
  
    func deleteTodo(item: ToDoModel) {
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/delete?user="+User+"&id="+item.id)else{
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
    } //MARK: XOÁ TODO
    func updateTodo(item: ToDoModel) {
        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/finish?idaccount="+User+"&id="+item.id)else{
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
}
