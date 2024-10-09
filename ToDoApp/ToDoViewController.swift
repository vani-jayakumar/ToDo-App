//
//  ToDoViewController.swift
//  ToDoApp
//
//  Created by Vani on 10/4/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var todoView:UITableView!
    @IBOutlet weak var addButton: UIButton!

    var todoItems:[(id:String, title: String)] = []
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoCell")
        fetchToDoItems()
    }
    private func fetchToDoItems() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("todos").document(userId).collection("tasks").getDocuments{[weak self] (snapshot, error) in
            if let error = error {
                print("Error fetching To-Do items!: \(error.localizedDescription)")
            } else {
                self?.todoItems = snapshot?.documents.compactMap { doc in
                    let title = doc.data()["title"] as? String ?? ""
                    return (id: doc.documentID, title: title)
                } ?? []
                self?.todoView.reloadData()
            }
        }
    }
 
    @IBAction func didTapAdd(button: UIButton) {
        let addAlert = UIAlertController(title: "New Task", message: "Enter a task title " , preferredStyle: .alert)
        addAlert.addTextField { textField in
            textField.placeholder = "Task Title"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) {[weak self] _ in
            guard let taskTitle = addAlert.textFields?.first?.text, !taskTitle.isEmpty else {return}
            self?.saveTaskToFirebase(title: taskTitle)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAlert.addAction(addAction)
        addAlert.addAction(cancelAction)
        
        present(addAlert, animated: true, completion: nil)
        
    }
    private func saveTaskToFirebase(title: String) {
        guard let userId = Auth.auth().currentUser?.uid else{ return }
        db.collection("todos").document(userId).collection("tasks").addDocument(data: ["title": title])
        {[weak self] error in
            if let error = error {
                print("Error saving task: \(error.localizedDescription)")
            } else {
                self?.fetchToDoItems()
            }
        }
    }
    private func deleteTask(id: String, at indexPath: IndexPath) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        db.collection("todos").document(userId).collection("tasks").document(id).delete {[weak self] error in
            if let error = error {
                print("Error deleting task: \(error.localizedDescription)")
            } else {
                self?.todoItems.remove(at: indexPath.row)
                self?.todoView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
extension ToDoViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        cell.textLabel?.text = todoItems[indexPath.row].title
        return cell
    }
}
extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = todoItems[indexPath.row]
        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {[weak self]_ in
            self?.deleteTask(id: task.id, at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        present(deleteAlert, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
