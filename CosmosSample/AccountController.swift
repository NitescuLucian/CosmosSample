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
        
        guard let key = selectedKey else { return }
        restApi.getAccount(address: key.address) { result in
            switch result {
            case .success(let address):
                print(address)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }

    }
    

}
