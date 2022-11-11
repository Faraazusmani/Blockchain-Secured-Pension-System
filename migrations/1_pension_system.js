const PensionSystem = artifacts.require("./PensionSystem");

module.exports = function (deployer) {
    console.log('Hora raha bhai, ek mint...')
  deployer.deploy(PensionSystem);
  console.log('Ho gya !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
};
