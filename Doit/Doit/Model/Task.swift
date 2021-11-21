//
//  Task.swift
//  Doit
//
//  Created by Vitalii Kryvoshapka on 17.11.2021.
//

import Foundation

//Task type
enum TaskPriority{
    case normal
    case important
}

//Task condition
enum TaskStatus: Int{
    case planned
    case completed
}


//Protocol to type "Task"
protocol TaskProtocol{
    //Name
    var title: String {get set}
    var type: TaskPriority {get set}
    var status: TaskStatus {get set}
}

// Essence "TASK"
struct Task: TaskProtocol{
    var title: String
    
    var type: TaskPriority
    
    var status: TaskStatus
}
