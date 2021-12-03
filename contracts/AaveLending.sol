//SPDX-License-Identifier:UNLICENSED
pragma solidity >=0.5.0 <=0.9.0;

interface IWETHGateway {
  function depositETH(
    address lendingPool,
    address onBehalfOf,
    uint16 referralCode
  ) external payable;

  function withdrawETH(
    address lendingPool,
    uint256 amount,
    address onBehalfOf
  ) external;

}

interface ILendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);
}

interface IERC20 {
   function approve(address spender, uint256 amount) external returns (bool);
   function allowance(address owner, address spender) external view returns (uint256);
}

interface IAaveIncentivesController{
       function claimRewards( address[] calldata assets,uint256 amount,address to) external returns (uint256);
       function getRewardsBalance(address[] calldata assets, address user)external view returns (uint256);
}
contract aaveLending{
    fallback() external payable {}
    receive() external payable {}
    address[] reward=[0xF45444171435d0aCB08a8af493837eF18e86EE27];
    address aaveIncentive = 0xd41aE58e803Edf4304334acCE4DC4Ec34a63C644;
		address ethGateWayAddress= 0xee9eE614Ad26963bEc1Bec0D2c92879ae1F209fA;
		address lendingPoolProviderAddress = 0x178113104fEcbcD7fF8669a0150721e231F0FD4B;
		address aMaticToken = 0xF45444171435d0aCB08a8af493837eF18e86EE27;
    
   
    //Lend to Aave
   function lendToAave() public payable{
        IWETHGateway ethGateWay = IWETHGateway(ethGateWayAddress);
        ILendingPoolAddressesProvider lendingProvider = ILendingPoolAddressesProvider(
                lendingPoolProviderAddress
            );
        ethGateWay.depositETH{value:msg.value}(lendingProvider.getLendingPool(), address(this),0);
    }
    //get the amount of token that can be claimed
		function getClaimAmount() public view returns(uint){
				IAaveIncentivesController claim = IAaveIncentivesController(aaveIncentive);
        return(claim.getRewardsBalance(reward,address(this)));
    }
		//to claim the reward amount
    function claimReward(uint _amount) public{
				IAaveIncentivesController claim = IAaveIncentivesController(aaveIncentive);
        claim.claimRewards(reward,_amount,msg.sender);
    }
		//approve the ethgateway contract to use aMatic
    function setApproval(uint _amount) public{
         IERC20(aMaticToken).approve(ethGateWayAddress,_amount);
    }
	  // get the allownace amount
    function getAllowanceAmount(address _owner, address _spender) public view returns(uint256){
        return(IERC20(aMaticToken).allowance(_owner,_spender));
    }
    // Withdraw from Aave
    function withDrawFromAave(uint256 _amount) public payable{
       IWETHGateway ethGateWay = IWETHGateway(ethGateWayAddress);
        ILendingPoolAddressesProvider lendingProvider = ILendingPoolAddressesProvider(
                lendingPoolProviderAddress
            );
        ethGateWay.withdrawETH(lendingProvider.getLendingPool(),_amount,msg.sender);
        
    }
	
		
   
}