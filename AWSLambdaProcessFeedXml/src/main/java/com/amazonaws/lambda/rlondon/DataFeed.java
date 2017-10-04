package com.amazonaws.lambda.rlondon;

import com.amazonaws.services.s3.AmazonS3;

import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.S3Object;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.util.Scanner;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class DataFeed {
	private AmazonS3 s3 = AmazonS3ClientBuilder.standard().build();

	public boolean IetTv(String bucket, String key)
	{
		String newKey = key.replace(".xml", "_info.log");
		String contentBody = String.format("Key: %s", key);
		
		boolean result = Transform(bucket, key, "IetTvParser.xslt");  
		if (result)
			s3.putObject("rlondon-importfile", newKey.replace(".xml", "_2.xml"), contentBody);
		else
			s3.putObject("rlondon-importfile", newKey.replace(".xml", "_error.xml"), contentBody);
		
        return result;
	}
	
	private boolean transformXml(S3Object s3Object, String xsltFile) {
		try {
			// Prepare the input and output files
	     	Source source = new StreamSource(s3Object.getObjectContent());
	     	StringWriter writer = new StringWriter();
	        StreamResult result = new StreamResult(writer);

	        // Create transformer factory
	     	TransformerFactory factory = TransformerFactory.newInstance();
	     	String resourceString = getFile(xsltFile);
	     	s3.putObject("rlondon-importfile","resourceString.log",resourceString);
	     	InputStream resource = this.getClass().getResourceAsStream(xsltFile);
	     	
	     	// Use the factory to create a template containing the xslt file
	     	Templates template = factory.newTemplates(new StreamSource(resource));
	     	s3.putObject("rlondon-importfile","template.log","Template");
	     	
	     	// Use the template to create a transformer
	     	Transformer xformer = template.newTransformer();
	     	s3.putObject("rlondon-importfile","start_transform.log","Starting transform...");
	     	xformer.transform(source, result);
	     	String strResult = writer.toString();
	     	s3.putObject("rlondon-importfile","_transformed.xml", strResult);
	     	
		}
		catch (TransformerException e) {
			// TODO Auto-generated catch block
			s3.putObject("rlondon-importfile", "transform_error.log", e.getMessage());
			e.printStackTrace();
			return false;
		}
		return true;
    }
	
	private boolean Transform(String bucket, String sourceXml, String xsltFile)
	{
		S3Object s3object = s3.getObject(new GetObjectRequest(bucket, sourceXml));
		        
        return transformXml(s3object, xsltFile);
	}
	
	private String getFile(String fileName) {
		s3.putObject("rlondon-importfile", "getFile.log", "Start");
		StringBuilder result = new StringBuilder("");
		//Get file from resources folder
		s3.putObject("rlondon-importfile", "getting_resource_file.txt",fileName);
		try {
			InputStream is =  this.getClass().getClassLoader().getResourceAsStream(fileName);
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			s3.putObject("rlondon-importfile", "buffer_file.txt",br.readLine());
			s3.putObject("rlondon-importfile", "loaded_resource_file.txt",fileName);
			File file = new File(this.getClass().getResource(fileName).getFile());
			s3.putObject("rlondon-importfile", "loaded_resource_file.txt",fileName);
			Scanner scanner = new Scanner(file);
			s3.putObject("rlondon-importfile", "scanner.txt","Stuff");
			int lineCount = 0;
			while (scanner.hasNextLine()) {
				lineCount++;
				String line = scanner.nextLine();
				s3.putObject("rlondon-importfile", "resource_file" + lineCount + ".txt", line);
				result.append(line).append("\n");
			}

			scanner.close();

		} catch (IOException e) {
			s3.putObject("rlondon-importfile", "io_error.log", e.getMessage());
			e.printStackTrace();
		}

		return result.toString();

	  }

	}

