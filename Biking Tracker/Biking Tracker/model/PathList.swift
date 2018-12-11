import Foundation

class PathList: Codable{
    
    static let shared = PathList()
    
    var paths: [Path] = []
    
    // file to save the list
    var fileURL: URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data"))
    }
    
    private init() {
        
        do {
            let savedData = try Data(contentsOf: fileURL)
            
            let decoder = JSONDecoder()
            guard let loadedPaths = try? decoder.decode(PathList.self, from: savedData) else{
                return
            }
            paths = loadedPaths.paths
        }
        catch {/* error handling here */}
    }
    
    func getList() -> [Path]{
        return paths
    }
    
    func add(_ path: Path){
        paths.append(path)
        saveToDisk()
    }
    
    func saveToDisk(){
        if let encodedData = try? JSONEncoder().encode(self) {
            do {
                try encodedData.write(to: fileURL)
            }
            catch {
                print("Failed to write JSON data: \(error.localizedDescription)")
            }
        }
    }
    

//    func commit(){
//        let encoder = JSONEncoder()
//        let encoded = try! encoder.encode(self)
//        UserDefaults.standard.set(encoded, forKey: KEY)
//    }
//
//    func getNextId() -> Int {
//        if(tasks.count == 0){
//            return 0
//        }
//        return tasks[tasks.count - 1].id + 1
//    }
//
//    func saveNewTask(newTask: Path){
//        tasks.append(newTask)
//        commit()
//    }
//
//
//
//    func getTaskWithId(_ id: Int) -> Path?{
//        for task in tasks{
//            if task.id == id{
//                return task
//            }
//        }
//        return nil
//    }
//
//    func getTaskIndexWithId(_ id: Int) -> Int?{
//        var c : Int = 0
//        for task in tasks{
//            if task.id == id{
//                return c
//            }
//            c = c + 1
//        }
//        return nil
//    }
//
//    func updateTask(_ task: Path){
//        guard let index = getTaskIndexWithId(task.id) else {
//            return
//        }
//        tasks[index] = task
//        commit()
//    }
//
//    func deleteTask(_ deleteId: Int){
//        guard let index = getTaskIndexWithId(deleteId) else {
//            return
//        }
//        tasks.remove(at: index)
//        commit()
//    }
    

}
