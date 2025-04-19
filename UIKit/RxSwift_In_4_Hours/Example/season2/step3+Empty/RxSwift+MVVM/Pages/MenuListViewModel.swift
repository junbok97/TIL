//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 이준복 on 2023/03/14.
//  Copyright © 2023 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class MenuListViewModel {
    
    static let shard = MenuListViewModel()
    
    lazy var menuObservable = BehaviorRelay<[Menu]>(value: [])
    
    lazy var itemsCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    private init() {
        APIService.fetchAllMenusRx()
            .map { data in
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.menus
            }
            .map { menuItems -> [Menu] in
                return menuItems.map { return Menu.fromMenuItems(item: $0) }
            }
            .take(1)
//            .subscribe { [weak self] menus in
//                self?.menuObservable.accept(menus)
//            }
            .bind(to: menuObservable)
    }
    
    
    func clearAllItemsSelections() {
        menuObservable
            .map { menus in
                menus.map { menu in
                    Menu(name: menu.name, price: menu.price, count: 0)
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.menuObservable.accept($0)
            })
    }
    
    func changeCount(_ item: Menu, _ count: Int) {
        menuObservable
            .map { menus in
                return menus.map { menu in
                    if menu.id == item.id {
                        return Menu(
                            name: menu.name,
                            price: menu.price,
                            count: max(menu.count + count, 0))
                    } else {
                        return menu
                    }
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.menuObservable.accept($0)
            })
    }
    
    func onOrder() {
        
    }
 
}
