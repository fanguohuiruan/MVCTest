//
//  ToDoItemStore.swift
//  MVVM Test
//
//  Created by 范国徽 on 2019/1/24.
//  Copyright © 2019年 范国徽. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let didChangeItemsNotification = Notification.Name.init("change.notification")
}




class ToDoItemStore: NSObject {

    static let share = ToDoItemStore()

    enum ToDoItemProviderBehavior{
        case add([Int])
        case remove([Int])
        case reload
    }
    /// 数据源
    private var items = [ToDoItem]() {
        didSet{
            let behavior = diff(originItems: oldValue, now: items)
            sendNotificationWith(behavior: behavior)
        }
    }

    /// 数量
    var count: Int {
        return self.items.count
    }

    /// 添加一个数据
    ///
    /// - Parameter index: 索引
    func append(index: ToDoItem) {
        if let _ = items.lastIndex(of: index){
            return
        }
        self.items.append(index)
        //let maxIndex = self.items.count - 1
    }

    /// 移除某一行的数据
    ///
    /// - Parameter index: 索引
    func remove(item: ToDoItem){
        if let index = self.items.lastIndex(of: item){
            self.items.remove(at: index)
        }
    }

    func removeIndex(of index: Int) {
        if  index < self.items.count{
            self.items.remove(at: index)
        }
    }

    /// 获取最大的当前数据源中，id最大的Element的id
    var maxIndex: Int {
        let max = self.items.max { $1.id > $0.id }?.id
        print(max)
        if let max = max {
            return max + 1
        }
        return 0
    }

    /// 获取index对应的Item
    ///
    /// - Parameter index: Int对象
    /// - Returns: 返回Element
    func itemOfIndex(index: Int) -> ToDoItem?{
        guard  index < self.items.count else{
            return nil
        }
        return self.items[index]
    }

    /// 返回Element对应的索引，分别匹配id和title，使用过程是重载了“==”
    ///
    /// - Parameter item: Element = ToDoItem
    /// - Returns: Int 对应的索引
    func indexOf(item: ToDoItem) -> Int?{
        guard let index = self.items.lastIndex(of: item) else{
            return nil
        }
        return index
    }

    /// 比较两个数据源的数据
    ///
    /// - Parameters:
    ///   - originItems: 修改之前的数据
    ///   - now: 现在的真实数据
    /// - Returns: ToDoItemProviderBehavior
    func diff(originItems: [ToDoItem], now: [ToDoItem]) -> ToDoItemProviderBehavior{
        let nowSet = Set(now)
        let originSet = Set(originItems)
        //originSet是nowSet的子集
        if originSet.isSubset(of: nowSet) {
            //找到新增的元素集
            let addedItems = nowSet.subtracting(originSet)
            print(addedItems)
//            let addedItemsIndex = addedItems.compactMap{ now.index(of: $0)}
            let addedItemsIndex = addedItems.compactMap { (item) -> Int in
                print(item)
                let index = now.lastIndex(of: item)
                return index!
            }
            return .add(addedItemsIndex)
        }else if nowSet.isSubset(of: originSet) {
            let lessItems = originSet.subtracting(nowSet)
            let addedItemsIndex = lessItems.compactMap { (item) -> Int in
                print(item)
                let index = originItems.lastIndex(of: item)
                return index!
            }
            return .remove(addedItemsIndex)
        }
        return .reload
    }

    /// 发送一条通知
    ///
    /// - Parameter behavior: ToDoItemProviderBehavior
    func sendNotificationWith(behavior: ToDoItemProviderBehavior) {

        NotificationCenter.default.post(name: .didChangeItemsNotification, object: self, userInfo: [Notification.Name.didChangeItemsNotification: behavior])
    }

 }
