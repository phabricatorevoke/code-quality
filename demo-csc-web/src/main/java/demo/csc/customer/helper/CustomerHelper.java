package demo.csc.customer.helper;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.logging.Logger;

import demo.csc.customer.domain.Address;

public class CustomerHelper {
	private static final Logger LOGGER = Logger.getLogger(CustomerHelper.class);
	private Integer counter;
	private boolean isValidInput;
	
	public static void readFile(String filePath, String fileName) {
		System.out.println("filePath: "+filePath+", fileName: "+fileName);
		readFromFileInputStream(filePath, fileName);
	}

	private static void readFromFileInputStream(String filePath, String fileName) {
		try (FileInputStream fis = new FileInputStream(new File(filePath + fileName))) {
			int data = fis.read();
			while (data != -1) {
				data = fis.read();
			}

		} catch (FileNotFoundException e) {
			LOGGER.error("Requested file not found: "+filePath + fileName, e);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void readFile(String filePath, String fileName, boolean condition) {
		if(condition){
			readFromFileInputStream(filePath, fileName);
		}
	}
	
	public static String formatString(String input){
		return input.toUpperCase();
	}
	
	public static String formatAddress(Address address){
		String formattedAddr="";
		if(address!=null && address.getFlatNo()!=null && address.getApartmentName()!=null){
			formattedAddr = address.getFlatNo()+", "+address.getApartmentName();
		}
		return formattedAddr;
	}
}
