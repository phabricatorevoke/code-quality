package demo.csc.customer.dao;

import demo.csc.customer.domain.Customer;

public interface CustomerDao {
	Customer getUserById(String id);
}
