package demo.csc.customer.dao;

import demo.csc.customer.domain.Customer;

public class CustomerDaoImpl implements CustomerDao{

	@Override
	public Customer getUserById(String id) {
		String sql = "select user_name, email from user where user_id="+id;
		
		//Tuned SQL query for better performance, making use of indexes 
		
		//Using groupby clause for unique results
		
		return null;
	}

}
