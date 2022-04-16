//
//  ToDoItem.swift
//  ToDoItem
//
//  Created by i'm Tony` on 9/1/21.
//

import Foundation
import SwiftUI

class ToDoModel: Codable, Identifiable {
    var id : String
    var idaccount: String
    var noidung: String
    var danhsach: String
    var checklist: String
    var pin: String
    var ngayth: String
    var ngaythem: String
//    init(id: String, idaccount: String, noidung: String, checklist: String) {
//        self.id = id
//        self.idaccount = idaccount
//        self.noidung = noidung
//        self.checklist = checklist
//    }
    
}
