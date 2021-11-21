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
    var tasks: [TaskPriority:[TaskProtocol]] = [:] {

        //Sort task from task list
        didSet{
            for (tasksGroupPriority, tasksGroup) in tasks{
                tasks[tasksGroupPriority] = tasksGroup.sorted {
                    task1, task2 in
                    let task1Position = taskStatusPosition.firstIndex(of: task1.status) ?? 0
                    let task2Position = taskStatusPosition.firstIndex(of: task2.status) ?? 0
                    return task1Position < task2Position
                }
            }
        }
    }
    
    //порядок отображения секций по типам
    //индекс в массиве соответствует индексу секции в таблице
    var sectionsTypesPosition: [TaskPriority] = [.important,.normal]
    
    
    var taskStatusPosition:[TaskStatus] = [.planned, .completed]
    
    //MARK: -LOAD TASKS- METHOD
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
        //return getConfiguredTaskCell_constraints(for: indexPath)
        return getConfiguretTaskCell_stack(for: indexPath)
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
    
    
    //MARK: - Show task list with prototype (Stack View) -
    
    //StackView Cell
    private func getConfiguretTaskCell_stack(for indexPath: IndexPath) -> UITableViewCell {
        //Load Cell prototype with ID
        let cell = tableView.dequeueReusableCell(withIdentifier: "taksCellStack", for: indexPath) as! TaskCell
        //Get data about taks, what need to show in cell
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        //Change text in cell
        cell.title.text = currentTask.title
        //Change symbol in cell
        cell.symbol.text = getSymbolForTask(with: currentTask.status)
        
        //Change text color
        if currentTask.status == .planned {
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        } else {
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
        }
        return cell
    }
    
    
    //MARK: - Realised taks status with didDelectRowAt (COMPLETED PLANNED)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //1 .Check task life?
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return
        }
        //2 .Make sure that task not complete
        guard tasks[taskType]![indexPath.row].status == .planned else {
            // delete highlighted from row
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        //3. Do selected task DONE
        tasks[taskType]![indexPath.row].status = .completed
        //4 . Reload table section
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
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

