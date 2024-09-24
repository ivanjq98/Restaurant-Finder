from brownie import SmartContract, accounts
from scripts.helpful_scripts import get_account 

def deploy_Smart_Contract(): 
    owner = accounts[0] 
    print(owner)
    account = accounts[1]
    print(account)


def main():
    deploy_Smart_Contract()
