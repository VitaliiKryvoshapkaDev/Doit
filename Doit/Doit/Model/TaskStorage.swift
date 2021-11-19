//
//  TaskStorage.swift
//  Doit
//
//  Created by Vitalii Kryvoshapka on 18.11.2021.
//

import Foundation

//Protocol to essence "TaskStorage"
protocol TaskStorageProtocol{
    func loadTasks() -> [TaskProtocol]
  //  func saveTasks(_ tasks: [TaskProtocol])
}


// "TaskStorage" ESSENCE
class TaskStorage: TaskStorageProtocol{
    func loadTasks() -> [TaskProtocol] {
        //Temporarily, return test task collection
        let testTasks: [TaskProtocol] = [Task(title: "Clean Macbook", type: .normal, status: .planned),
                                         Task(title: "Watch Dexter", type: .important, status: .planned),
                                         Task(title: "Learn Swift", type: .important, status: .completed),
                                         Task(title: "By new iPhone", type: .normal, status: .completed),
                                         Task(title: "Buy flowers to Alisa", type: .important, status: .planned),
                                         Task(title: "Call grandmother", type: .important, status: .planned)
        ]
        return testTasks
    }
    
//    func saveTasks(_ tasks: [TaskProtocol]) {
//        <#code#>
//    }
    
}
