package demo.csc.customer.dao;

import demo.csc.customer.domain.Customer;

public class CustomerDaoImpl implements CustomerDao{

	@Override
	public Customer getUserById(String id) {
		
		//Tuned SQL query for better performance, making use of indexes 
		return null;
	}

}
