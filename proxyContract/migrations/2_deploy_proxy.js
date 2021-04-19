// "Dogs" is the contract name
const Dogs = artifacts.require("Dogs");
const DogsUpdated = artifacts.require("DogsUpdated");
const Proxy = artifacts.require("Proxy");

module.exports = async function(deployer, network, accounts) {
    // Deploy contracts
    const dogs = await Dogs.new();
    const proxy = await Proxy.new(dogs.address);

    // Takes the Dogs source code, .at: create an instance of Dog with proxy's address
    // There's a Dog contract at proxy's address.
    // So we can call functions that don't exist on Proxy but exist on Dog
    var proxyDog = await Dogs.at(proxy.address);
    
    // set nr of dogs through proxy
    await proxyDog.setNumberOfDogs(10);

    // Testing
    let nrOfDogs = await proxyDog.getNumberOfDogs();
    console.log('proxy', nrOfDogs.toNumber());

    nrOfDogs = await dogs.getNumberOfDogs();
    console.log('dogs, should be 0 as storage is in proxy contract', nrOfDogs.toNumber());

    // Deploy new version of Dogs
    const dogsUpdated = await DogsUpdated.new();
    await proxy.upgrade(dogsUpdated.address);

    // Fool Truffle again. It now thinks proxyDog has all functions
    proxyDog = await DogsUpdated.at(proxy.address);
    // Initialize proxy state.
    // We only called initialize in DogsUpdated's constructor, to set the owner variable there.
    // We need to call it through proxy as well, to set the owner variable in proxy.
    proxyDog.initialize(accounts[0]);

    // Check so that storage remained
    nrOfDogs = await proxyDog.getNumberOfDogs();
    console.log('updated proxy, should be same as prev. proxy', nrOfDogs.toNumber());

    // set nr of dogs through proxy with new func contract (onlyOwner)
    await proxyDog.setNumberOfDogs(30);

    // Check so that storage changed
    nrOfDogs = await proxyDog.getNumberOfDogs();
    console.log('updated proxy, should change to 30', nrOfDogs.toNumber());

}