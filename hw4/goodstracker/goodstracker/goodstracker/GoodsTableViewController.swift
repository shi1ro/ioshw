//
//  GoodsTableViewController.swift
//  goodstracker
//
//  Created by njuios on 2020/11/14.
//

import UIKit
import os.log

class GoodsTableViewController: UITableViewController {
    var goodlist = [Goods]()
    @IBAction func unwindToGoodsList(sender:UIStoryboardSegue){
        if let sourceVC = sender.source as? GoodsViewController,let good = sourceVC.goods{
                if let selectedindexpath = tableView.indexPathForSelectedRow{
                    //update
                    goodlist[selectedindexpath.row] = good
                    tableView.reloadRows(at: [selectedindexpath], with: .none)
                }
                else{
                    //add
                    let newIndexPath = IndexPath(row:goodlist.count,section:0)
                    goodlist.append(good)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
                savegoods()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedgoods = loadgoods(){
            goodlist += savedgoods
        }
        else{
            loadSample()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goodlist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GoodsCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GoodsTableViewCell else{
            fatalError("The dequeued cell is not an instance of GoodsTableViewCell")
        }
        let curgood = goodlist[indexPath.row]
        cell.desclabel.text = curgood.desc
        cell.namelabel.text = curgood.name
        cell.phiv.image = curgood.photo
        // Configure the cell...

        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? ""){
        case "additem":
            os_log("add a new goods",log:OSLog.default,type:.debug)
        case "showdetail":
            guard let detailVC = segue.destination as? GoodsViewController else{
                fatalError("Unexpected destination:\(segue.destination)")
            }
            guard let selectedcell = sender as? GoodsTableViewCell else{
                fatalError("Unexpected sender:\(sender ?? "")")
            }
            guard let indexpath = tableView.indexPath(for: selectedcell) else{
                fatalError("the selected cell is not being displayed by the table")
            }
            let selectedgoods = goodlist[indexpath.row]
            detailVC.goods = selectedgoods
        default:
            fatalError("Unexpected Segue Identifier;\(segue.identifier ?? "")")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            goodlist.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            savegoods()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
    func loadSample(){
        let photo1 = UIImage(named:"milkph")
        let photo2 = UIImage(named:"breadph")
        guard let goods1 = Goods(name: "milk", desc: "i want a cup of milk", photo: photo1) else{
            fatalError("Unable to initialize goods1")
        }
        guard let goods2 = Goods(name: "bread", desc: "i want bread", photo: photo2) else{
            fatalError("Unable to initialize goods2")
        }
        goodlist += [goods1,goods2]
        
    }
    func savegoods(){
        let issuccsave = NSKeyedArchiver.archiveRootObject(goodlist, toFile: Goods.archiveurl.path)
        if issuccsave{
            os_log("goodlist successfully saved.",log:OSLog.default,type:.debug)
        }
        else{
            os_log("goodlist failed to be saved.",log:OSLog.default,type:.error)
        }
    }
    func loadgoods()->[Goods]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Goods.archiveurl.path) as? [Goods]
    }
}
