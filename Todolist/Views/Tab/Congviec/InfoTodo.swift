//
//  InfoTodo.swift
//  Todolist
//
//  Created by imTony on 12/23/21.
//

import SwiftUI

struct InfoTodo: View {
    @Environment(\.presentationMode) var presentationMode
    @State var noidung = String()
    @State var danhsach = String()
    @State var ngaythem = String()
    @State var ngayth = String()
    @State var checklist = String()
    @State var pin = String()
    var body: some View {
        NavigationView{
            VStack{
                if #available(iOS 15.0, *) {
                List{
                    Section(header: Text("Chi tiết")) {
                    HStack{
                            Image(systemName: "tag.square.fill")
                                .foregroundColor(Color.init("Xanhla"))
                       
                        Text("Tên công việc:")
                            
                        Spacer()
                        Text("\(noidung)")
                            
                        }
                        HStack{
                                Image(systemName: "lineweight")
                                    .foregroundColor(Color.init("Red"))
                           
                            Text("Danh sách:")
                                
                            Spacer()
                            Text("\(danhsach)")
                                
                            }
                    HStack{
                            Image(systemName: "calendar.badge.plus")
                                .foregroundColor(Color.init("Xanhla"))
                        
                        Text("Ngày thêm:")
                            
                        Spacer()
                        Text("\(ngaythem)")
                            
                    }
                        HStack{
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.init("Xanhla"))
                            
                            Text("Ngày thực hiện:")
                                
                            Spacer()
                            Text("\(ngayth)")
                                
                        }
                        
                    }
                    .headerProminence(.increased)
                    
                        Section(header: Text("Trạng thái")) {
                            HStack{
                                Image(systemName: checklist == "0" ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                                    .foregroundColor(checklist == "0" ? Color.init("Cam") : Color.init("Xanhla"))
                                Text("Tình trạng")
                                Spacer()
                                Text(checklist == "0" ? "Chưa hoàn thành" : "Đã hoàn thành")
                                
                            }
                            HStack{
                                Image(systemName: pin == "0" ? "pin.slash.fill" : "pin.fill")
                                    .foregroundColor(pin == "0" ? Color.init("Cam") : Color.init("Xanhla"))
                                Text("Ghim")
                                Spacer()
                                Text(pin == "0" ? "Chưa ghim" : "Đã ghim")
                                
                            }
                        } .headerProminence(.increased)
                    
                }.listStyle(.insetGrouped)
                } else {
                    // Fallback on earlier versions
                }
            }
            .navigationTitle("Thông tin")
            .onAppear {
                UINavigationBarAppearance()
                    .setColor(title: .white, background: .init(named: "Xanhla"))
            }
            .toolbar {
                Button{
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.white)
                        .font(.headline)
                }
            }
        }
        
    }
}

struct InfoTodo_Previews: PreviewProvider {
    static var previews: some View {
        InfoTodo()
    }
}
