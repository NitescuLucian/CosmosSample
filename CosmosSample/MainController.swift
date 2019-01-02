//
//  ViewController.swift
//  CosmosSample
//
//  Created by Calin Chitu on 02/01/2019.
//  Copyright © 2019 Calin Chitu. All rights reserved.
//

import UIKit
import CosmosRestApi

class MainController: UIViewController {

    
    @IBOutlet weak var dataLabel: UILabel?
    @IBOutlet weak var heightlabel: UILabel?
    @IBOutlet weak var hashLabel: UILabel?
    @IBOutlet weak var tableView: UITableView!

    var keys: [Key] = []
    var selectedKey: Key? = nil
    var info: AbciInfo?
    let restApi = GaiaRestAPI()
    
    private let accountdetailsSegue = "AccountDetaisSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        info = AbciInfo.loadFromDisk() as? AbciInfo
        updateUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GaiaSimpleAPI().getAbciInfo() { result in
            switch result {
            case .success(let abciInfo):
                self.info = abciInfo
                self.info?.savetoDisk()
                self.updateUI()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        restApi.getkeys() { result in
            switch result {
            case .success(let keys):
                self.keys = keys
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    private func updateUI() {
        dataLabel?.text = info?.result?.response?.data ?? "x"
        heightlabel?.text = info?.result?.response?.lastBlockHeight ?? "x"
        hashLabel?.text = info?.result?.response?.lastBlockAppHash ?? "x"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == accountdetailsSegue {
            let dest = segue.destination as? AccountController
            dest?.selectedKey = selectedKey
        }
    }
}

extension MainController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keyCell", for: indexPath)
        let key = keys[indexPath.item]
        cell.textLabel?.text = key.name
        cell.detailTextLabel?.text = key.address
        return cell
    }
    
    
}

extension MainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = keys[indexPath.item]
        selectedKey = key
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: self.accountdetailsSegue, sender: self)
        }
    }
}
