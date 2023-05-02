//
//  NoteViewController.swift
//  MA_Notes
//
//  Created by Luis Valle-Arellanes on 3/7/23.
//

import UIKit

class NoteViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    var models: [(title: String, Note: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource  = self
        title = "NOTES"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapNewNotes(){
        
    }
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text  = models[indexPath.row].title
        cell.detailTextLabel?.text  = models[indexPath.row].Note
    
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        
        //show note contr
        
        guard let vc  =  storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else{
            return
        }
        vc.title =  "Notes"
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
