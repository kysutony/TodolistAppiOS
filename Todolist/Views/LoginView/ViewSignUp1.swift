//
//  SignUp.swift
//  Todolist
//
//  Created by i'm Tony` on 8/24/21.
//

import SwiftUI

struct ViewSignUp1: View {
    @State var user = ""
    @State var pass = ""
    @State var re_pass = ""
     var body: some View {
        ScrollView{
            ZStack{
                VStack {
                    HStack(alignment: .top, spacing: 0){
                        Image("SignUp")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150, alignment: .center)
                    }
                    VStack(alignment: .leading){
                        VStack{
                            HStack{
                                Text("Tên người dùng:")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.init("Xanhla"))
                                Spacer()
                            }
                            .padding()
                            TextField("Nhập tên người dùng tại đây", text: self.$user)
                                .padding()
                                .background(Color.init("Gray"))
                                .padding()
                        }
                        VStack{
                            HStack{
                                Text("Mật khẩu:")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.init("Xanhla"))
                                Spacer()
                            }
                            .padding()
                            SecureField("Nhập mật khẩu tại đây", text: self.$pass)
                                .padding()
                                .background(Color.init("Gray"))
                                .padding()
                        }
                        VStack{
                            HStack{
                                Text("Nhập lại mật khẩu:")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.init("Xanhla"))
                                Spacer()
                            }
                            .padding()
                            SecureField("Nhập lại mật khẩu tại đây", text: self.$re_pass)
                                .padding()
                                .background(Color.init("Gray"))
                                .padding()
                        }
                        HStack{
                        Spacer()
                            Button(action: {}, label: {
                                Text("Đăng ký")
                                    .foregroundColor(Color.white)
                            })
                            Spacer()
                        }
                        .padding()
                        .background(Color.init("Cam"))
                        .cornerRadius(10)
                        .padding()
                    }
                    
                }
                
            }.background(Color.white)
        }
            }
    }


//struct SignUp_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewSignUp1()
//    }
//}

