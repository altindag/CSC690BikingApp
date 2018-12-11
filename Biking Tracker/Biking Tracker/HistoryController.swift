import UIKit

class HistoryController: UITableViewController{
    
    var selectedID = 0
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPaths().count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryCell
        cell.textLabel?.text = getPaths()[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedID = indexPath.row
        performSegue(withIdentifier: "showHistoryItem", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as? HistoryItemController;
        dest?.selectedID = selectedID
    }
    
    func getPaths() -> [Path]{
        return PathList.shared.getList()
    }
}
