//
//  LoginView.swift
//  Todolist
//
//  Created by i'm Tony` on 8/24/21.
//

import SwiftUI

struct ViewLoginTotal: View {
    @State var selected = 0
    var body: some View {
        VStack(spacing: 22){
            HStack{
                Text("Tài Khoản")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.white)
                Spacer()
            }
            VStack{
                //MARK: NÚT TOPBAR
                TopBar(selected: self.$selected)
                
                if self.selected == 0{
//                    login()
                }
                else{
                    ViewSignUp1()
                }
                
            }
            
        }
        .background(Color("Xanhla").ignoresSafeArea())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
}
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ViewLoginTotal()
    }
}

struct TopBar : View {
    @Binding var selected : Int
    var body: some View{
        HStack{
            Button(action: {
                self.selected = 0
            }) {
                Text("Đăng Nhập")
                    .fontWeight(.bold)
                    .padding(.vertical, 12)
                    .padding(.horizontal,25)
                    .background(self.selected == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
                    
            }
            .foregroundColor(self.selected == 0 ? .init("Cam") : .gray)
            Button(action: {
                self.selected = 1
            }) {
                Text("Đăng Ký")
                    .fontWeight(.bold)
                    .padding(.vertical, 12)
                    .padding(.horizontal,25)
                    .background(self.selected == 1 ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }
            .foregroundColor(self.selected == 1 ? .init("Cam") : .gray)
        }
        .padding(8)
        .background(Color.init("Gray"))
        .clipShape(Capsule())
    }
    
}
