//
//  TabView.swift
//  Todolist
//
//  Created by i'm Tony` on 8/24/21.
//

import SwiftUI
import SystemConfiguration

struct TabView: View {
    let connectivity = SCNetworkReachabilityCreateWithName(nil, "https://2dolist.website") //MARK: KIỂM TRA KẾT NỐI MẠNG
    @State var lanchScreen: Bool = false
    @ObservedObject var internetConnection = InternetConnetion()
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack{
            if self.lanchScreen {
                VStack{
                    Text("Không có kết nối internet")
                        .font(.title)
                        .cornerRadius(5)
                    Image("urban")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(contentMode: .fit)
                        
                }
            }else{
                home()
            }
           
        }
        .onReceive(timer, perform: { _ in //MARK: CHẠY HÀM MỖI GIÂY ĐỂ KIỂM TRA KẾT NỐI MẠNG
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                var flgs = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(self.connectivity!, &flgs)
                
                if self.internetConnection.NetWorkReachable(to: flgs) {
                    self.lanchScreen = false
                }else{
                    lanchScreen = true
                }
            }
        })
    }
}



struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}

struct home : View {
    @State var selectedTab = "Trang Chủ"
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @Namespace var animation
  
    var body: some View {
        VStack(spacing: 0){
            
            GeometryReader{_ in
                ZStack{
                    //MARK: TABS
                    
                    Home()
                        .opacity(selectedTab == "Trang Chủ" ? 1 : 0)
                    ListView()
                        .opacity(selectedTab == "Công Việc" ? 1 : 0)
                    ThongKe()
                        .opacity(selectedTab == "Thống Kê" ? 1 : 0)
                    User()
                        .opacity(selectedTab == "Tài Khoản" ? 1 : 0)
                    
                }
            }
            //MARK: TABVIEW
            HStack(spacing: 0){
                ForEach(tabs, id: \.self) {tab in
                    TabButton(title: tab, selectedTab: $selectedTab, animation: animation)
                    if tab != tabs.last{
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal,30)
            //MARK: FOR IPHONE LIKE 8 OR SE
            .padding(.bottom,edges!.bottom == 0 ? 15 : edges!.bottom)
            .background(Color.init("White2"))
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .background(Color.black.opacity(0.06).ignoresSafeArea(.all, edges: .all))
        
    }
    
    
}

//MARK: TAB BUTTON
struct TabButton: View {
    var title : String
    @Binding var selectedTab : String
    var animation : Namespace.ID
    var body: some View {
        Button(action: {
            withAnimation{selectedTab = title}
        }){
            VStack(spacing: 6){
                
                //MARK: TOP INDICATOR
                
                //MARK: CUSTOM SHAPE
                
                //MARK: SLIDE IN AND OUT ANIMATION
                ZStack{
                    CustomShape()
                        .fill(Color.clear)
                        .frame(width: 45, height: 6)
                    
                    if selectedTab == title{
                        CustomShape()
                            .fill(Color("Xanhla"))
                            .frame(width: 45, height: 6)
                            .matchedGeometryEffect(id: "Tab_Chage", in: animation)
                    }
                }
                .padding(.bottom,10)
                Image(title)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(selectedTab == title ? Color("Xanhla") : Color.black.opacity(0.2))
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.init("White1").opacity(selectedTab == title ? 0.6 : 0.2))
            }
        }
    }
}
//MARK: CUSTOM SHAPE
struct CustomShape : Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}

//MARK: IMAGE TAB
var tabs = ["Trang Chủ","Công Việc","Thống Kê","Tài Khoản"]

//MARK: LỚP GỬI YÊU CẦU TỚI SEVER
class InternetConnetion : ObservableObject {
    func NetWorkReachable(to flags: SCNetworkReachabilityFlags) -> Bool {
        let reachable = flags.contains(.reachable)
        let nConnection = flags.contains(.connectionRequired)
        let cConnectionAutomatically = flags.contains(.connectionOnDemand) ||
        flags.contains(.connectionOnTraffic)
        let cConnetionWithInternetion = cConnectionAutomatically &&
        !flags.contains(.interventionRequired)
        
        return reachable && (!nConnection || cConnetionWithInternetion)
    }
}
