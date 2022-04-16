////
////  Tododata.swift
////  Todolist
////
////  Created by i'm Tony` on 8/26/21.
////
//
//import SwiftUI
//
//struct ToDo: View {
////    @State var models = [ResponseModel]()
////    @State var User = ""
//    var body: some View {
//        HStack{
//            if #available(iOS 15.0, *) {
////                List(models){ model in
////                    Button(action: {
////                        updateTodo(item: model)
////                    }, label: {
////                        HStack{
////                            Image(systemName: "circle.fill")
////                                .foregroundColor( Color.init("Cam"))
////                            Text("\(model.noidung)")
////                                .foregroundColor(Color.black)
////                            Spacer()
////                        }
////                    })
////                    .padding()
////                    .background(Color.init("Gray"))
////                    .cornerRadius(10)
////                }
////                .refreshable {
////                    getTodo()
////                }
////                .onAppear() {
////                   getTodo()
////                }
////            } else {
////                // Fallback on earlier versions
////            }
////        }.background(Color.white)
//    }
////    func updateTodo(item: ResponseModel) {
////        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/finish?idaccount="+User+"&id="+item.id)else{
////            print("invalid URL")
////            return
////        }
////        var urlRequest: URLRequest = URLRequest(url: url)
////        urlRequest.httpMethod = "GET"
////        URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
////            // check if response is okay
////            guard let data = data else {
////                print("invalid response")
////                return
////            }
////            //convert JSON response into class model as an array
////            do{
////                self.models = try JSONDecoder().decode([ResponseModel].self, from: data)
////            }catch{
////                print(error.localizedDescription)
////            }
////        }).resume()
////
////    }
////    func getUser() {
////        User = UserDefaults.standard.string(forKey: "UserName") ?? ""
////    }
////    func getTodo() {
////        getUser()
////        //send request to sever
////        guard let url: URL = URL(string: "https://2dolist.website/api/nhiemvu/todo?account="+User+"&check=0")else{
////            print("invalid URL")
////            return
////        }
////        var urlRequest: URLRequest = URLRequest(url: url)
////        urlRequest.httpMethod = "GET"
////        URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
////            // check if response is okay
////            guard let data = data else {
////                print("invalid response")
////                return
////            }
////            //convert JSON response into class model as an array
////            do{
////                self.models = try JSONDecoder().decode([ResponseModel].self, from: data)
////            }catch{
////                print(error.localizedDescription)
////            }
////        }).resume()
////    }
//}
////class ResponseModel: Codable, Identifiable {
////    var id : String
////    var idaccount: String
////    var noidung: String
////    var checklist: String
////}
//
//struct Tododata_Previews: PreviewProvider {
//    static var previews: some View {
//        ToDo()
//    }
//}
//
//
