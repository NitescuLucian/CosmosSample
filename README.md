# CosmosSample

To run:

- create 2 folders at the same level, CosmosRestAPI and CosmosSample
- clone this repo and CosmosRestAPI to it's coresponding folder
- have xCode installed and launch CosmosSample.xcworkspace
- have gaiad started
- have the gacli rest server started

gaiacli rest-server --chain-id=genki-4002 \
    --laddr=tcp://localhost:1317 \
    --node tcp://localhost:26657 \
    --trust-node=true
    
- the app can be tested/used in the simulator only, unless you edit the code to use a remote available rest server
