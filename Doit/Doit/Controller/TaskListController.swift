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
        //        let wallpaper = UIImageView(image: UIImage(named: "868844"))
        //        wallpaper.contentMode = .scaleAspectFill
        //        tableView.backgroundView = wallpaper
        tableView.backgroundColor = #colorLiteral(red: 0.776, green: 0.804, blue: 0.843, alpha: 1.000)
        editButtonItem.tintColor = #colorLiteral(red: 0.000, green: 0.118, blue: 0.220, alpha: 1.000)
        
        //Load Tasks
        loadTasks()
        
        //ADD Edit Button
        navigationItem.leftBarButtonItem = editButtonItem
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
    //MARL: Use CONSTRAINTS OR STACK
    // Cell for Row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return getConfiguredTaskCell_constraints(for: indexPath)
        return getConfiguretTaskCell_stack(for: indexPath)
    }
    //MARK: - Show task list with prototype (Cnstraints) With TAGs-
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
        //Cell Color
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    //MARK: - Realise task status with didDelectRowAt (COMPLETED)
    
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
    
    //MARK: Realise task status (PLANNED)
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Get data about taks, to swipe that to planned
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return nil
        }
        
        // действие для изменения статуса на "запланирована"
        let actionSwipeInstance = UIContextualAction(style: .normal, title: "Не выполнена") { _,_,_ in
            self.tasks[taskType]![indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        
        // Create Action to change status "Planned"
        let actionEditInstance = UIContextualAction(style: .normal, title: "Изменить") {_,_,_ in
            // load scene from storyboard
            let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskEditController") as! TaskEditController
            // Send value redactet task
            editScreen.taskText = self.tasks[taskType]![indexPath.row].title
            editScreen.taskType = self.tasks[taskType]![indexPath.row].type
            editScreen.taskStatus = self.tasks[taskType]![indexPath.row].status
            // Transfer handler to save task
            editScreen.doAfterEdit = {[unowned self] title, type, status in
                let editedTask = Task(title: title, type: type, status: status)
                tasks[taskType]![indexPath.row] = editedTask
                tableView.reloadData()
            }
            // Move to Edit screen
            self.navigationController?.pushViewController(editScreen, animated: true)
        }
        // Change backround color of swipe
        actionEditInstance.backgroundColor = .darkGray
        
        // Create object, описывающий доступные действия
        // depend of status taks (Show 1 or 2 Action)
        let actionsConfiguration: UISwipeActionsConfiguration
        if tasks[taskType]![indexPath.row].status == .completed{
            actionsConfiguration = UISwipeActionsConfiguration(actions: [actionSwipeInstance, actionEditInstance])
        } else {
            actionsConfiguration = UISwipeActionsConfiguration(actions: [actionEditInstance])
        }
        //return done object
        return actionsConfiguration
    }
    
    //MARK: - Delete Task -
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let taskType = sectionsTypesPosition[indexPath.section]
        //Delete TASK
        tasks[taskType]?.remove(at: indexPath.row)
        //Delete ROW
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    //MARK: - Move At Row - Hand sort
    // Hand sort task
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // From Section
        let taskTypeFrom = sectionsTypesPosition[sourceIndexPath.section]
        // To Section
        let taskTypeTo = sectionsTypesPosition[destinationIndexPath.section]
        
        // Unwrap task and copy them
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return
        }
        
        //Delete task from old position
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        //Insert task to new position
        tasks[taskTypeTo]!.insert(movedTask, at: destinationIndexPath.row)
        
        // IF sections change, change task type with new position
        if taskTypeFrom != taskTypeTo{
            tasks[taskTypeTo]![destinationIndexPath.row].type = taskTypeTo
        }
        //Reload Data
        tableView.reloadData()
    }
    
    
    //MARK: move to Create Screen
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateScreen"{
            let destination = segue.destination as! TaskEditController
            destination.doAfterEdit = { [unowned self] title, type, status in
                let newTask = Task(title: title, type: type, status: status)
                tasks[type]?.append(newTask)
                tableView.reloadData()
            }
        }
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

