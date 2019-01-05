//
//  AccountController.swift
//  CosmosSample
//
//  Created by Calin Chitu on 02/01/2019.
//  Copyright © 2019 Calin Chitu. All rights reserved.
//

import UIKit
import CosmosRestApi

class AccountController: UIViewController {

    let restApi = GaiaRestAPI()

    var selectedKey: Key? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        restApi.getTransaction(by: "CE06AC7BDFAAD54C2E8D55195E30A678E72C0AD2DF4EA5F3E3DE0E66DBC4BE66") { result in
            switch result {
            case .success(let tx):
                print(tx)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        restApi.getTransaction(by: "C7983B1ADCADDB68D240151BD2256BFB48B784E1A85D2E3E4F87CBF6DF3F9251") { result in
            switch result {
            case .success(let tx):
                print(tx)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        restApi.getValidators(at: 54738) { result in
            switch result {
            case .success(let validators):
                print(validators)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        restApi.getLatestValidators { result in
            switch result {
            case .success(let validators):
                print(validators)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        restApi.getBlock(at: 54738) { result in
            switch result {
            case .success(let block):
                print(block)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
       restApi.getLatestBlock { result in
            switch result {
            case .success(let block):
                print(block)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        restApi.getSyncingInfo { result in
            switch result {
            case .success(let sync):
                print(sync)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        restApi.getNodeInfo { result in
            switch result {
            case .success(let nodeInfo):
                print(nodeInfo)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        guard let key = selectedKey, let addr = key.address else { return }
        restApi.getAccount(address: addr) { result in
            switch result {
            case .success(let address):
                print(address)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
    

}
