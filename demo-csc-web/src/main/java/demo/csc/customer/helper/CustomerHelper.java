package demo.csc.customer.helper;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.apache.log4j.Logger;

public class CustomerHelper {
	private static final Logger LOGGER = Logger.getLogger(CustomerHelper.class);
	private CustomerHelper(){}
	
	public static void readFile(String filePath, String fileName) {
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
			LOGGER.error("Error while reading the file.", e);
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
}
