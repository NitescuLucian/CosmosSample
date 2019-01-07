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
    var account: Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func getAccountUpdate(completion: @escaping (Bool)->()) {
        guard let key = selectedKey, let addr = key.address else { return }
        restApi.getAccount(address: addr) { result in
            switch result {
            case .success(let address):
                self.account = address
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
         }
    }
    
    @IBAction func getDelegationsAction(_ sender: Any) {
        
        getAccountUpdate { success in
            if success, let acc = self.account?.value?.address {
                self.restApi.getDelegations(for: acc, completion: { result in
                    switch result {
                    case .success(let delegations):
                        print(delegations)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
                
                self.restApi.getDelegation(for: acc, validator: "cosmosvaloper1r627wlvrhkk637d4zarv2jpkuwuwurj978s96c", completion: { result in
                    switch result {
                    case .success(let delegation):
                        print(delegation)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })

            } else {
                print("No account or balance")
            }
        }
    }
    
    @IBAction func getRedelegationsAction(_ sender: Any) {
        getAccountUpdate { success in
            if success, let acc = self.account?.value?.address {
                self.restApi.getRedelegations(for: acc, completion: { result in
                    switch result {
                    case .success(let redelegations):
                        print(redelegations)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        }
    }
    
    @IBAction func getUnbondingDelegationsAction(_ sender: Any) {
        
        getAccountUpdate { success in
            if success, let acc = self.account?.value?.address {
                self.restApi.getUnbondingDelegations(for: acc, completion: { result in
                    switch result {
                    case .success(let udelegations):
                        print(udelegations)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
                
                self.restApi.getUnbondingDelegation(for: acc, validator: "cosmosvaloper1r627wlvrhkk637d4zarv2jpkuwuwurj978s96c", completion: { result in
                    switch result {
                    case .success(let delegation):
                        print(delegation)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
                
            } else {
                print("No account or balance")
            }
        }
    }

    @IBAction func transferAction(_ sender: Any) {
        
        getAccountUpdate { success in
            if success {
                guard let accnum = self.account?.value?.accountNumber,
                    let seq = self.account?.value?.sequence,
                    let accName = self.selectedKey?.name else {
                    return
                }
                
                let transferData = TransferPostData(name: accName, pass: "Sw1ft2015", chain: "testing", amount: "50", denom: "STAKE", accNum: accnum, sequence: seq)
                self.restApi.bankTransfer(to: "cosmos1wtv0kp6ydt03edd8kyr5arr4f3yc52vp5g7na0", transferData: transferData) { result in
                    switch result {
                    case .success(let resp):
                        print(resp)
                    case .failure(let error):
                        let errMsg = error.localizedDescription
                        let data = errMsg.data(using: .utf8) ?? Data()
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(TransferError.self, from: data)
                            print(decoded)
                        } catch {
                            print(error.localizedDescription)
                        }

                    }
                }

            } else {
                print("Wroooong")
            }
        }
    }
    
    @IBAction func delegationAction(_ sender: Any) {
        
        getAccountUpdate { success in
            if success {
                guard let accnum = self.account?.value?.accountNumber,
                    let seq = self.account?.value?.sequence,
                    let accAddr = self.account?.value?.address,
                    let accName = self.selectedKey?.name else {
                        return
                }
                
                let transferData = DelegationPostData(validator: "cosmosvaloper1r627wlvrhkk637d4zarv2jpkuwuwurj978s96c", delegator: accAddr, name: accName, pass: "Sw1ft2015", chain: "testing", amount: "1", denom: "STAKE", accNum: accnum, sequence: seq)
                self.restApi.delegation(from: accAddr, transferData: transferData) { result in
                    switch result {
                    case .success(let resp):
                        print(resp)
                    case .failure(let error):
                        let errMsg = error.localizedDescription
                        let data = errMsg.data(using: .utf8) ?? Data()
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(TransferError.self, from: data)
                            print(decoded)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
            } else {
                print("Wroooong")
            }
        }
    }

    @IBAction func redelegationAction(_ sender: Any) {
        
        getAccountUpdate { success in
            if success {
                guard let accnum = self.account?.value?.accountNumber,
                    let seq = self.account?.value?.sequence,
                    let accAddr = self.account?.value?.address,
                    let accName = self.selectedKey?.name else {
                        return
                }
                
                let transferData = RedelegationPostData(sourceValidator: "cosmosvaloper1r627wlvrhkk637d4zarv2jpkuwuwurj978s96c", destValidator: "cosmosvaloper1r627wlvrhkk637d4zarv2jpkuwuwurj978s96c", delegator: accAddr, name: accName, pass: "Sw1ft2015", chain: "testing", amount: "5", accNum: accnum, sequence: seq)
                self.restApi.redelegation(from: accAddr, transferData: transferData) { result in
                    switch result {
                    case .success(let resp):
                        print(resp)
                    case .failure(let error):
                        let errMsg = error.localizedDescription
                        let data = errMsg.data(using: .utf8) ?? Data()
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(TransferError.self, from: data)
                            print(decoded)
                        } catch {
                            print(errMsg)
                        }
                    }
                }
                
            } else {
                print("Wroooong")
            }
        }
    }

    @IBAction func unbondAction(_ sender: Any) {
        
        getAccountUpdate { success in
            if success {
                guard let accnum = self.account?.value?.accountNumber,
                    let seq = self.account?.value?.sequence,
                    let accAddr = self.account?.value?.address,
                    let accName = self.selectedKey?.name else {
                        return
                }
                
                let transferData = UnbondingDelegationPostData(validator: "cosmosvaloper1r627wlvrhkk637d4zarv2jpkuwuwurj978s96c", delegator: accAddr, name: accName, pass: "Sw1ft2015", chain: "testing", amount: "2", accNum: accnum, sequence: seq)
                self.restApi.unbonding(from: accAddr, transferData: transferData) { result in
                    switch result {
                    case .success(let resp):
                        print(resp)
                    case .failure(let error):
                        let errMsg = error.localizedDescription
                        let data = errMsg.data(using: .utf8) ?? Data()
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(TransferError.self, from: data)
                            print(decoded)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
            } else {
                print("Wroooong")
            }
        }
    }

    private func misc() {
        
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

    }
}
