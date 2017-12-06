package com.amazonaws.lambda.processfeed;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.event.S3EventNotification.S3EventNotificationRecord;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.S3Object;

public class LambdaFunctionHandler implements RequestHandler<S3Event, String> {

	private AmazonS3 s3Client = AmazonS3ClientBuilder.standard().build();
	private AmazonS3 s3 = AmazonS3ClientBuilder.standard().build();

    public LambdaFunctionHandler() {}

    // Test purpose only.
    LambdaFunctionHandler(AmazonS3 s3) {
    	this.s3Client = s3;
    }

    @Override
    public String handleRequest(S3Event s3Event, Context context) {
         try {
             for (S3EventNotificationRecord record: s3Event.getRecords()) {
                 String srcBucket = record.getS3().getBucket().getName();

                 // Object key may have spaces or unicode non-ASCII characters.
                 String srcKey = record.getS3().getObject().getKey()
                         .replace('+', ' ');
                 srcKey = URLDecoder.decode(srcKey, "UTF-8");

                 // Detect file type
                 Matcher matcher = Pattern.compile(".*\\.([^\\.]*)").matcher(srcKey);
                 if (!matcher.matches()) {
                     System.out.println("Unable to detect file type for key " + srcKey);
                     return "";
                 }
                 s3Client = AmazonS3ClientBuilder.standard().build();
                 S3Object s3Object = s3Client.getObject(new GetObjectRequest(srcBucket, srcKey));
                 String srcFeed = srcKey.substring(0,srcKey.indexOf("/"));
                 
                 boolean feedProcessed = false; 

		            DataFeed dataFeed = new DataFeed();
		        	srcKey = URLDecoder.decode(srcKey, "UTF-8");
		        	
		        	String contentBody = String.format("Starting Feed: %s, Key: %s, Bucket: %s", srcFeed, srcKey, srcBucket);
		        	String logBody = String.format("%s_start.txt", srcFeed);
		        	
		    		switch (srcFeed.toLowerCase()) {
				    	case "aipjats" :
				    		s3.putObject("rlondon-importfile", logBody, contentBody);
				    		feedProcessed = dataFeed.AipJats(s3Object);
				    		s3.putObject("rlondon-importfile", "aipjats_end.txt", "Feed ended.");
				    		break;
			        	case "iettv" :
			        		s3.putObject("rlondon-importfile", logBody, contentBody);
			        		feedProcessed = dataFeed.IetTv(s3Object);
				    		s3.putObject("rlondon-importfile", "iettv_end.txt", "Feed ended.");
				    		break;
			        	default:
			        		s3.putObject("rlondon-importfile", "feed_not_found.txt", "Feed not found.");
			        		break;
			        }
                 
             s3.putObject("rlondon-importfile", "ProcessFeedResult.txt", String.valueOf(feedProcessed));
             }
             return "Ok";
         } catch (IOException e) {
             throw new RuntimeException(e); 
         } 
    }
}