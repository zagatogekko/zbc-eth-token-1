const Migrations = artifacts.require("Migrations");
const ZagatoCoin = artifacts.require("ZagatoCoin");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  // no se por que aca se pasa el decimals si finalmente no lo va a utilizar
  // y es necesario pasarle ese valor en el total supply
  deployer.deploy(ZagatoCoin, 'ZagatoCoin', "ZGC", 3, Math.pow(10, 8) * Math.pow(10, 3));
};
