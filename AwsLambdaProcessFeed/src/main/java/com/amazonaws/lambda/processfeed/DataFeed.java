package com.amazonaws.lambda.processfeed;

import com.amazonaws.services.s3.AmazonS3;

import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.S3Object;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class DataFeed {
	private AmazonS3 s3 = AmazonS3ClientBuilder.standard().build();
	
	
	public boolean IetTv(S3Object s3Object) 
	{
		boolean result = false;
		try {
			Path path = Paths.get(DataFeed.class.getResource("/").toURI());
			s3.putObject("rlondon-importfile", "Path.txt", path.toString());
			//File curDir = new File(".");
	        //getAllFiles(curDir);
			
		//result = DoTransform(s3Object, "Jats/AipJatsParser_new.xslt");
			
			result = fileTransform(s3Object, path + "/resources/IetTv/IetTvParser.xslt");
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return result;
	}
	
	public static boolean setCurrentDirectory(String directory_name)
    {
        boolean result = false;  // Boolean indicating whether directory was set
        File    directory;       // Desired current working directory

        directory = new File(directory_name).getAbsoluteFile();
        if (directory.exists() || directory.mkdirs())
        {
            result = (System.setProperty("user.dir", directory.getAbsolutePath()) != null);
        }

        return result;
    }
	
	public boolean AipJats(S3Object s3Object) 
	{
		boolean result = false;
		
		try {
			Path path = Paths.get(DataFeed.class.getResource("/").toURI());
		//result = DoTransform(s3Object, "Jats/AipJatsParser_new.xslt");
			result = setCurrentDirectory(path + "/resources/Jats");
			result = fileTransform(s3Object, path + "/resources/Jats/AipJatsParser_new.xslt");
			//File curDir = new File(".");
	        //getAllFiles(curDir);
	        
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	/*
	private boolean transformXml(S3Object s3Object, String xsltSource) {
		boolean success = false; 
		try {
			
			Source xmlInput = new StreamSource(s3Object.getObjectContent());
			File xslInput = new File(xsltSource);
			TransformerFactory factory = TransformerFactory.newInstance();
			Templates xsl = factory.newTemplates(new StreamSource(xslInput));
			Transformer transformer = xsl.newTransformer();
			
			StringWriter outWriter = new StringWriter();
			StreamResult result = new StreamResult( outWriter );
			transformer.transform(xmlInput, result);
			StringBuffer sb = outWriter.getBuffer(); 
			String finalstring = sb.toString();
			s3.putObject("rlondon-importfile", s3Object.getKey(), finalstring);
			success = true;
		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			s3.putObject("rlondon-importfile", "TransformConfigError.txt", e.getMessage());
		} catch (TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			s3.putObject("rlondon-importfile", "TransformError.txt", e.getMessage());
		}
		return success;
	}
	*/
	
	private static void getAllFiles(File curDir) {
		AmazonS3 s3Object = AmazonS3ClientBuilder.standard().build();
        File[] filesList = curDir.listFiles();
        for(File f : filesList){
        	String files = f.getName() + ".txt";
        	s3Object.putObject("rlondon-importfile", files, f.getAbsolutePath() + ": " + f.getPath() + ": " + f.getName());
            if(f.isDirectory())
                getAllFiles(f);
            //if(f.isFile()){
            //   files += f.getName() + ", ";
            //}
        }
    }
	
	private boolean fileTransform(S3Object s3Object, String xsltSource) {
		boolean success = false;  
		try {
			TransformerFactory factory = TransformerFactory.newInstance();
			//TransformerFactory factory = new net.sf.saxon.TransformerFactoryImpl();
			
			File xsltFile = new File(xsltSource);
			 
			FileInputStream xsltInputStream = new FileInputStream(xsltFile);
	
			Source xslt = new StreamSource(xsltFile);
			Transformer transformer = factory.newTransformer(xslt);
				 
			StringWriter outWriter = new StringWriter();
			StreamResult result = new StreamResult( outWriter );
			transformer.transform(new StreamSource(s3Object.getObjectContent()), result);
			StringBuffer sb = outWriter.getBuffer(); 
			String finalstring = sb.toString();
			s3.putObject("rlondon-importfile", s3Object.getKey(), finalstring);
			success = true;
		}
		catch (TransformerException e) {
			s3.putObject("rlondon-importfile", "TransformerException.txt", e.getMessage());
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			s3.putObject("rlondon-importfile", "FileNotFoundException.txt", e.getMessage());
		} 
		return success;
	}
	
	private boolean DoTransform(S3Object s3Object, String xsltSource) {
		boolean success = false;  
		InputStream xsltFile = this.getClass().getResourceAsStream(xsltSource);
		s3.putObject("rlondon-importfile","gotResourceFile.txt",xsltSource);
	    //File xsltFile = new File(xsltSource);
		s3.putObject("rlondon-importfile", s3Object.getKey().replaceAll(".xml", ".txt"), "Transform started");
		try {
			TransformerFactory factory = TransformerFactory.newInstance();
			//TransformerFactory factory = new net.sf.saxon.TransformerFactoryImpl();
			Source xslt = new StreamSource(xsltFile);
			//xslt.setSystemId("/Nlm/");
			Transformer transformer = factory.newTransformer(xslt);
			
			//Source xslt = new StreamSource(xsltFile);
			//Transformer transformer = xsl.newTransformer();
			StringWriter outWriter = new StringWriter();
			StreamResult result = new StreamResult( outWriter );
			transformer.transform(new StreamSource(s3Object.getObjectContent()), result);
			StringBuffer sb = outWriter.getBuffer(); 
			String finalstring = sb.toString();
			s3.putObject("rlondon-importfile", s3Object.getKey(), finalstring);
			success = true;
		}
		catch (TransformerException e) {
			s3.putObject("rlondon-importfile", "TransformError.txt", e.getMessage());
		} 
		return success;
	}
}



