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
    
    private let recoverTestSeed = "six faith rain lawsuit any analyst clock bargain match pistol brown night forget miss truly design assault marriage baby core shove melt spray finger"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        updateUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GaiaTendermintAPI().getAbciInfo() { result in
            switch result {
            case .success(let abciInfo):
                self.info = abciInfo.first
                self.info?.savetoDisk()
                self.updateUI()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        getkeys()
        
        GaiaRestTester.selfTesting()
    }
    
    @IBAction func updatePass(_ sender: Any) {
        let data = KeyPasswordData(name: "test", oldPass: "1234", newPass: "12345")
        restApi.changeKeyPassword(keyData: data) { result in
            switch result {
            case .success(_):
                self.getkeys()
                
            case .failure(let error):
                print(error.localizedDescription)
            }

        }
    }
    
    @IBAction func deleteTestAction(_ sender: Any) {
        
        let data = KeyPostData(name: "test", pass: "12345", seed: nil)
        restApi.deleteKey(keyData: data) { result in
            switch result {
            case .success(_):
                self.getkeys()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        let rdata = KeyPostData(name: "recovered", pass: "12345", seed: nil)
        restApi.deleteKey(keyData: rdata) { result in
            switch result {
            case .success(_):
                self.getkeys()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    @IBAction func recoverKey(_ sender: Any) {
        let data = KeyPostData(name: "recovered", pass: "12345", seed: recoverTestSeed)
        restApi.recoverKey(keyData: data) { result in
            switch result {
            case .success(let key):
                print(key)
                self.getkeys()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func newKeyAction(_ sender: Any) {
        restApi.createSeed { result in
            switch result {
            case .success(let seed):
                let data = KeyPostData(name: "test", pass: "12345", seed: seed.first)
                self.restApi.createKey(keyData: data) { result in
                    switch result {
                    case .success(_):
                        self.getkeys()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
         }
    }
    
    private func getkeys() {
        restApi.getKeys() { result in
            switch result {
            case .success(let keys):
                self.keys = keys
                let _ = Keys(items: keys).savetoDisk()
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadData() {
        info = AbciInfo.loadFromDisk() as? AbciInfo
        if let ks = Keys.loadFromDisk() as? Keys, let items = ks.items {
            keys = items
        }
    }
    
    private func updateUI() {
        dataLabel?.text = info?.result?.response?.data ?? "x"
        heightlabel?.text = info?.result?.response?.lastBlockHeight ?? "x"
        hashLabel?.text = info?.result?.response?.lastBlockAppHash ?? "x"
        self.tableView.reloadData()
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
