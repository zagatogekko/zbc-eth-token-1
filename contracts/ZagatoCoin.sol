// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ZagatoCoin {
    // definiciones
    string tokenName;
    string public tokenSymbol;
    // string public constant SYMBOL;
    // cantidad de decimales
    uint8 public tokenDecimals;
    // cantidad total en la red
    uint256 private tokenTotalSupply;

    // legder: es una relacion entre alguin y lo que tiene
    // , con esto generamos automaticamente como obtener balanceOf
    mapping(address => uint256) public balanceOf;

    // Como hacemos una transferencia de una cuetna a otra
    // de una direccion del dueño mapeamos hacia otra direccion del que gasta y cuanto
    // son como permisos, de quien a quien y cuanto
    mapping(address => mapping(address => uint256)) public allowance;

    // Eventos
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // Permite poner condiciones de aprobacion de una transaccion
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // Modificadores

    // Constructores, el estandar no indica como se hace el constructor
    constructor(string memory _name, string memory _symbol, uint8 _decimals,  uint256 _totalSupply) public {
        tokenName = _name;
        tokenSymbol = _symbol;
        tokenDecimals = _decimals;
        tokenTotalSupply = _totalSupply;

        // lo mas comun es que todo el balance inicial es de la persona que crea el contrato
        balanceOf[msg.sender] = _totalSupply;
        // de la direccion cero a quien lo recibe que es en inicio el dueño del token
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // Metodos
    /*function getSymbol() public view returns (string memory) {
        return symbol;
    }*/

    function name() public view returns (string memory) {
        return tokenName;
    }

    function symbol() public view returns (string memory) {
        return tokenSymbol;
    }

    function decimals() public view returns (uint8) {
        return tokenDecimals;
    }

    function totalSupply() public view returns (uint256) {
        return tokenTotalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "No tienes esa cantidad");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // a quien estas aprobando y por cuanto estas aprobando ?
    function approve(address _spender, uint256 _value) public returns (bool) {
        // iniciamos permitiendo que se haga esta trabferebcua
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // esto es lo que hace el exchange cuando transfiere a tu nombre
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        // validamos permisos
        require(allowance[_from][msg.sender] >= _value, "No tienes permisos para mover esta cantidad");
        // validamos el balance, debe tener la cantidad esperada como minimo
        require(balanceOf[_from] >= _value, "No tienes esa cantidad");
        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        balanceOf[_to] += _value;

        return true;
    }
    
}
