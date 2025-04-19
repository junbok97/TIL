//
//  Menu.swift
//  RxSwift+MVVM
//
//  Created by 이준복 on 2023/03/14.
//  Copyright © 2023 iamchiwon. All rights reserved.
//

import Foundation

// View를위한 Model
struct Menu {
    let id: UUID
    var name: String
    var price: Int
    var count: Int
    
    init(name: String, price: Int, count: Int) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.count = count
    }
}


extension Menu {
    static func fromMenuItems(item: MenuItem) -> Menu {
        return Menu(name: item.name, price: item.price, count: 0)
    }
}
