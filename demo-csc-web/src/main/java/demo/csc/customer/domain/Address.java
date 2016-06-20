package demo.csc.customer.domain;

public class Customer {
	private String userId;
	private String userName;
	private Address address;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public void setAddress(Address address){
		this.address = address;
	}
	
	public Address getAddress(){
		return address;
	}
}
