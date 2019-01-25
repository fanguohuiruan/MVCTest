//
//  ToDoItem.swift
//  MVVM Test
//
//  Created by 范国徽 on 2019/1/24.
//  Copyright © 2019年 范国徽. All rights reserved.
//

import UIKit

/// 数据源： 添加记录
struct ToDoItem{

    /// id
    var id: Int
    /// 标题
    var title: String

    /// initialize
    ///
    /// - Parameter id: Int
    init(id: Int) {
        self.id = id
        self.title = "\(id)"
    }

}

extension ToDoItem: Hashable {
    /// 运算符重载
    ///
    /// - Parameters:
    ///   - rhs: 比较的ToDoItem
    /// - Returns: 如果id相等返回true其他返回false

    static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool{
        return lhs.id == rhs.id && lhs.title == rhs.title
    }


}
