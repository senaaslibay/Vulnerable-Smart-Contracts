pragma solidity 0.7.0;

//transfer between users

contract BasicBank3  {

    mapping (address => uint) private userFunds;
    address private commissionCollector;
    uint private collectedComission = 0;

    constructor() {
        commissionCollector = msg.sender;
    }
    
    modifier onlyCommissionCollector {
        require(msg.sender == commissionCollector);
        _;
    }

    function deposit() public payable {
        //external olabilir
        require(msg.value >= 1 ether); //gönderilen eth miktarı 1 den fazla olmalı
        userFunds[msg.sender] += msg.value; //işlemi yapan kullanıcının adres değeri msg.value kadar artırıldı.
        //msg.value değerinin eksi olması durumu var mı bilmiyrum eğer öyleyse uint sıkıntısı olabilir.
    }

    function withdraw(uint _amount) external payable {
        require(getBalance(msg.sender) >= _amount);
        payable (msg.sender).transfer(_amount);//burda payable demek gerekiyo mu bilmiyorum fonksiyon zaten payable.
        userFunds[msg.sender] -= _amount;
        userFunds[commissionCollector] += _amount/100; //%1 komisyon olarak commission_taker hesabına ekleniyor.
        //burada collectedComission değişkeni kullanılabilirmiş direkt atmak yerine
    }   

    function getBalance(address _user) public view returns(uint) {
        //bu da belki onlycommissionCollector modifier istiyor olabilir.
        return userFunds[_user];
    }

    function getCommissionCollector() public view returns(address) {
        //external olabilir
        return commissionCollector;
    }

    function transfer(address _userToSend, uint _amount) external{
        //require gerekiyor amount gönderenin amaount'undan küçük olmalı
        userFunds[_userToSend] += _amount;
        userFunds[msg.sender] -= _amount;
    }

    function setCommissionCollector(address _newCommissionCollector) external onlyCommissionCollector{
        commissionCollector = _newCommissionCollector;
    }

    function collectCommission() external {
        //onlycomissioncolletor modifier'ı olması gerekiyor
        //collectedComission kullanılmıyo yani içi dolu değil
        userFunds[msg.sender] += collectedComission;
        collectedComission = 0;
    }
}
