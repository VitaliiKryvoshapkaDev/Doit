//
//  TaskListController.swift
//  Doit
//
//  Created by Vitalii Kryvoshapka on 17.11.2021.
//

import UIKit

class TaskListController: UITableViewController {
    
    
    //Tasks Starage
    var tasksStorage: TaskStorageProtocol = TaskStorage()
    //tasks Collection
    var tasks: [TaskPriority:[TaskProtocol]] = [:]
    
    //порядок отображения секций по типам
    //индекс в массиве соответствует индексу секции в таблице
    var sectionsTypesPosition: [TaskPriority] = [.important,.normal]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Bacground image
        let wallpaper = UIImageView(image: UIImage(named: "868844"))
        wallpaper.contentMode = .scaleAspectFill
        tableView.backgroundView = wallpaper
        
        //Load Tasks
        loadTasks()
        
    }
    
    private func loadTasks(){
        //Prepare collections with tasks
        //Use only sasks with section
        sectionsTypesPosition.forEach { taskType in tasks[taskType] = []
        }
        //Load & check task from storage
        tasksStorage.loadTasks().forEach { task in tasks[task.type]?.append(task)
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Task priority in current section
        let taskType = sectionsTypesPosition[section]
        guard let currentTasksType = tasks[taskType] else {
            return 0
        }
        // #warning Incomplete implementation, return the number of rows
        return currentTasksType.count
    }
    
    // Cell for Row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getConfiguredTaskCell_constraints(for: indexPath)
    }
    
    // ячейка на основе ограничений
    private func getConfiguredTaskCell_constraints(for indexPath: IndexPath) -> UITableViewCell{
        
        //Load prototype cell with ID // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        
        cell.backgroundColor = UIColor.clear
        //Get Data about task, with need to show in cell
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        //Text symbol lable
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        //Text task name label
        let textLabel = cell.viewWithTag(2) as? UILabel
        
        //Change symbol in cell
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        //Change text in label
        textLabel?.text = currentTask.title
        
        //Change text color & symbol
        if currentTask.status == .planned{
            textLabel?.textColor = .black
            symbolLabel?.textColor = .black
        } else {
            textLabel?.textColor = .lightGray
            symbolLabel?.textColor = .lightGray
        }
        return cell
    }
    
    
    //Return Symbol for current task Type
    private func getSymbolForTask(with status: TaskStatus) -> String{
        var resultSymbol: String
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .completed{
            resultSymbol = "\u{25C9}"
        } else {
            resultSymbol = ""
        }
        return resultSymbol
    }
    
    //Title for header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let taskType = sectionsTypesPosition[section]
        if taskType == .important{
            title = "Важные"
        }else if taskType == .normal{
            title = "Текущие"
        }
        return title
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

