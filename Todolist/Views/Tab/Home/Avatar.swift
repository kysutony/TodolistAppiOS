//
//  Avatar.swift
//  Todolist
//
//  Created by i'm Tony` on 9/21/21.
//

import SwiftUI

struct Avatar: View {
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var avatarApi = String()
        var body: some View{
            VStack{
                if #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: "https://2dolist.website/asset/icon/\(avatarApi).png")!) { images in
                        if let image = images.image{
                            image
                                .resizable()
                                .scaledToFit()
                        }else if images.error != nil{
                            Image(systemName: "photo.fill")
                        }else{
                            ProgressView()
                        }
                            
                    }
                    .frame(width: 33, height: 33, alignment: .center)
                    .cornerRadius(7)
                    .onReceive(timer) { _ in
                        getavatar()
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    func getavatar() { //HÀM GỌI TỪ API ĐỂ LẤY AVATAR
        let url = URL(string: "https://2dolist.website/api/user/getavatar?user="+User.urlEncoded!)
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print ("Error took place\(error)")
                return
            }
            struct Model: Decodable {
                var success: Bool
                var avt: String
            }
        let decoder = JSONDecoder()
        do{
            let shellys = try decoder.decode(Model.self, from: data!)
            if shellys.success == true{
                self.avatarApi = shellys.avt
            }else{
                print("error")
            }

        }catch{
            print(error.localizedDescription)
        }
    }.resume()
    }
    }


struct Avatar_Previews: PreviewProvider {
    static var previews: some View {
        Avatar()
    }
}
