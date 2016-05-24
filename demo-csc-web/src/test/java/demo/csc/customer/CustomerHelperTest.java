package demo.csc.customer;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import demo.csc.customer.helper.CustomerHelper;

public class CustomerHelperTest {
	
	@Test
	public void readFile_VaildInputs(){
		CustomerHelper.readFile("/temp","sampleDoc");
		assertTrue(true);
	}
}
