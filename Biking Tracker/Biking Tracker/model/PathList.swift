//import Foundation
//
//class PathList {
//    
//    static let shared = PathList()
//    
//    let KEY = "TODO_STORAGE_KEY"
//    var paths: [Path] = []
//    
//    
//    private init() {
////        guard let savedTasks = UserDefaults.standard.object(forKey: KEY) as? Data else{
////            return;
////        }
////
////        let decoder = JSONDecoder()
////        guard let todoList = try? decoder.decode(PathList.self, from: savedTasks) else{
////            return
////        }
////        tasks = todoList.tasks
////        commit()
//    }
//    
//    func getList() -> [Path]{
//        return paths
//    }
//
////    func commit(){
////        let encoder = JSONEncoder()
////        let encoded = try! encoder.encode(self)
////        UserDefaults.standard.set(encoded, forKey: KEY)
////    }
////
////    func getNextId() -> Int {
////        if(tasks.count == 0){
////            return 0
////        }
////        return tasks[tasks.count - 1].id + 1
////    }
////
////    func saveNewTask(newTask: Path){
////        tasks.append(newTask)
////        commit()
////    }
////
////
////
////    func getTaskWithId(_ id: Int) -> Path?{
////        for task in tasks{
////            if task.id == id{
////                return task
////            }
////        }
////        return nil
////    }
////
////    func getTaskIndexWithId(_ id: Int) -> Int?{
////        var c : Int = 0
////        for task in tasks{
////            if task.id == id{
////                return c
////            }
////            c = c + 1
////        }
////        return nil
////    }
////
////    func updateTask(_ task: Path){
////        guard let index = getTaskIndexWithId(task.id) else {
////            return
////        }
////        tasks[index] = task
////        commit()
////    }
////
////    func deleteTask(_ deleteId: Int){
////        guard let index = getTaskIndexWithId(deleteId) else {
////            return
////        }
////        tasks.remove(at: index)
////        commit()
////    }
//    
//    func add(_ path: Path){
//        
//    }
//}
