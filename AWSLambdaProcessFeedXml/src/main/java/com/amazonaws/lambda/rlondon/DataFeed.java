package com.amazonaws.lambda.rlondon;

import com.amazonaws.services.s3.AmazonS3;

import org.w3c.dom.Document;

import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.S3Object;

import java.io.InputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class DataFeed {
	private static AmazonS3 s3 = AmazonS3ClientBuilder.standard().build();

	public static boolean IetTv(String bucket, String key)
	{
		String newKey = key.replace(".xml", ".log");
		String contentBody = String.format("Key: %s", key);
        s3.putObject("rlondon-importfile", newKey, contentBody);
		
        return Transform(bucket, key, "resources/IetTv/IetTvParser.xslt"); 
	}
	
	private static boolean Transform(String bucket, String sourceXml, String transformFile)
	{
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		Document document;
		
		
		S3Object s3object = s3.getObject(new GetObjectRequest(bucket, sourceXml));
		InputStream xml = s3object.getObjectContent();
		
		File xsl = new File("C:\\temp\\persons.xsl");
	    
		DocumentBuilder builder = factory.newDocumentBuilder();
	    document = builder.parse(xml);
	    /* 
	    // Use a Transformer for output
	    TransformerFactory transformerFactory = TransformerFactory.newInstance();
	    StreamSource style = new StreamSource(transformFile);
	    Transformer transformer = transformerFactory.newTransformer(style);

	    DOMSource source = new DOMSource(document);
	    StreamResult result = new StreamResult(System.out);
	    transformer.transform(source, result);
	    */
		
		return false;
	}
}
