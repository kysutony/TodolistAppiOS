//
//  ListView.swift
//  Todolist
//
//  Created by i'm Tony` on 10/17/21.
//

import SwiftUI


extension View {
  func sheet<Content, Tag>(
    tag: Tag,
    selection: Binding<Tag?>,
    content: @escaping () -> Content ) -> some View where Content: View, Tag: Hashable {
    let binding = Binding(
      get: {
        selection.wrappedValue == tag
      },
      set: { isPresented in
        if isPresented {
          selection.wrappedValue = tag
        } else {
          selection.wrappedValue = .none
        }
      }
    )
    return background(EmptyView().sheet(isPresented: binding, content: content))
  }
}

enum ActiveSheet: Hashable {
  case first
  case second
}
class AppState: ObservableObject {
    static let shared = AppState()

    @Published var resetID = UUID()
}
struct ListView: View {
    @State private var fullScreen = false
    @State var models = [ListModel]()
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State var randomColor : Color = .green
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var showingSheet = false
    @State private var showingSheet2 = false
    @State private var _activeSheet: ActiveSheet?
    @StateObject var appState = AppState.shared
    @State private var modelsempty = false
    @State private var models1: ListModel? = nil
    @State private var showingAlert = false
    @State private var models2: ListModel? = nil
    var body: some View {
        NavigationView{
            VStack{
                if modelsempty {
                    VStack{
                        Spacer()
                    Image("Test1")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(contentMode: .fit)
                    Text("Hãy thêm danh sách")
                        .font(.headline)
                        .cornerRadius(5)
                        .padding()
                        Spacer()
                    }.background(Color.init("Gray1"))
                }else{
                    if #available(iOS 15.0, *) {
                        List{
                            Section(header: Text("")) {
                                NavigationLink {
                                    All()
                                        .navigationBarBackButtonHidden(true)
                                        .navigationBarHidden(true)
                                } label: {
                                    
                                    ListSystem1(namelistSystem: "Tất cả", iconlistSystem: "archivebox.fill", color: "Red")
                                }
                                
                                NavigationLink {
                                    Pin()
                                        .navigationBarBackButtonHidden(true)
                                        .navigationBarHidden(true)
                                } label: {
                                    
                                    ListSystem2(namelistSystem: "Việc ghim", iconlistSystem: "pin.square.fill", color: "Cam")
                                }
                                NavigationLink {
                                    NotPin()
                                        .navigationBarBackButtonHidden(true)
                                        .navigationBarHidden(true)
                                } label: {
                                    
                                    ListSystem3(namelistSystem: "Việc thường", iconlistSystem: "lineweight", color: "Vang")
                                    
                                }
                            }
                            Section(header: Text("Danh sách việc của tôi")) {
                            
                                    
                                      ForEach(models){ model in
                                          
                                          NavigationLink(destination:
                                                          CongViec(namelist: model.tendanhsach, icon: model.icon, idList: model.id)
                                                          .navigationBarBackButtonHidden(true)
                                                          .navigationBarHidden(true)
                                              , label: {
                                              HStack {
                                                  Image(systemName: "\(model.icon)")
                                                      .foregroundColor(Color.init("Xanhla"))
                                                  
                                                  Text("\(model.tendanhsach)")
                                                  Spacer()
                                                 

                                                  ListItem(idList: model.id, name: model.tendanhsach)
                                                      
                                              }
                                              
                                          })
                                          
                                              .swipeActions(edge: .leading) {
                                                  Button {
                                                     
                                                      self.models1 = model
                                                     
                                                  } label: {
                                                      Image(systemName: "square.and.pencil")
                                                  }
                                                  .tint(Color.init("Cam"))
                                                  
                                              }
                                              .sheet(item: self.$models1) { model in
                                                  EditList(id: model.self.id, namelist: model.self.tendanhsach, icon: model.self.icon, newnamelist: model.self.tendanhsach)
                                              }
                                              .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                  Button {
                                                      showingAlert = true
                                                      self.models2 = model
                                                  } label: {
                                                      Image(systemName: "trash")
                                                  }
                                                  .tint(Color.init("Red"))
                                                  
                                              }
                                              .alert("Cảnh báo!",
                                                    isPresented: $showingAlert,

                                                     presenting: models2,

                                                             actions: { model in
                                                            Button("Có", role: .destructive, action: {
                                                                deleteList(item: model)
                                                            })
                                                            Button("Huỷ", role: .cancel, action: {})
                                                        
                                                      }, message: { model in
                                                          Text("Bạn có chắc là bạn muốn xoá danh sách này")
                                                      })
                                              
                                      }
                                      .id(appState.resetID)
                                      
                                
                            }
                        }
                        .refreshable {
                            AppState.shared.resetID = UUID()
                        }
                        .listStyle(.insetGrouped)
                        
                        
                        
                        
                    } else {
                        // Fallback on earlier versions
                    }
                }//
                
                
            }//
            .onReceive(timer, perform: { _ in
                getList()
                
            })
            .navigationBarTitle("Danh Sách")
            .onAppear {
                UINavigationBarAppearance()
                    .setColor(title: .white, background: .init(named: "Xanhla"))
            }
            .navigationBarItems(
                trailing:
                    Button(action: {
                        
                        self._activeSheet = .second
                    }, label: {
                        
                        Image(systemName: "rectangle.fill.badge.plus")
                            .foregroundColor(Color.white)
                        
                    })
                
                
            )
        }
        .sheet(tag: .second, selection: $_activeSheet) {
            AddList()
        }
        
    }
   
    func getList(){
        //send request to sever
        guard let url: URL = URL(string: "https://2dolist.website/api/danhsach/all?account="+User.urlEncoded!)else{
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
                self.models = try JSONDecoder().decode([ListModel].self, from: data)
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
   
    func deleteList(item: ListModel) {
        guard let url: URL = URL(string: "https://2dolist.website/api/danhsach/delete?user="+User.urlEncoded!+"&list="+item.tendanhsach.urlEncoded!+"&idlist=\(item.id)")else{
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
                self.models = try JSONDecoder().decode([ListModel].self, from: data)
            }catch{
                print(error.localizedDescription)
            }
        }).resume()
    } //MARK: XOÁ DANH SÁCH
}
extension UINavigationBarAppearance {
    func setColor(title: UIColor? = nil, background: UIColor? = nil) {
        configureWithTransparentBackground()
        if let titleColor = title {
            largeTitleTextAttributes = [.foregroundColor: titleColor]
            titleTextAttributes = [.foregroundColor: titleColor]
        }
        backgroundColor = background
        UINavigationBar.appearance().scrollEdgeAppearance = self
        UINavigationBar.appearance().standardAppearance = self
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
