package com.amazonaws.lambda.rlondon;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.S3Object;

public class LambdaFunctionHandler implements RequestHandler<S3Event, String> {

    private AmazonS3 s3 = AmazonS3ClientBuilder.standard().build();

    public LambdaFunctionHandler() {}

    // Test purpose only.
    LambdaFunctionHandler(AmazonS3 s3) {
        this.s3 = s3;
    }

    @Override
    public String handleRequest(S3Event event, Context context) {
        context.getLogger().log("Received event: " + event);

        // Get the object from the event and show its content type
        String bucket = event.getRecords().get(0).getS3().getBucket().getName();
        String key = event.getRecords().get(0).getS3().getObject().getKey();
        String feed = key.substring(0,key.indexOf("/"));
    	String file = key.substring(key.indexOf("/")+1);
        String contentBody = String.format("Feed: %s, File: %s, Bucket: %s", feed, file, bucket);
        
        s3.putObject("rlondon-importfile", "feed_info.txt", contentBody);
    	
        boolean feedProcessed = false; 
        
        try {
        	DataFeed dataFeed = new DataFeed();
        	s3.putObject("rlondon-importfile", key.replace(".xml", ".txt"), bucket);
        	switch (feed.toLowerCase()) {
        		case "iettv" :
        			feedProcessed = dataFeed.IetTv(bucket, key);
        			break;
        		default:
        			break;
        	}
        	
        	
        	S3Object response = s3.getObject(new GetObjectRequest(bucket, key));
            String contentType = response.getObjectMetadata().getContentType();
                        String newKey = key.replace(".xml", ".txt");
            s3.putObject("rlondon-importfile", newKey, contentBody);
            
            context.getLogger().log("CONTENT TYPE: " + contentType);
            return contentType;
        } catch (Exception e) {
            e.printStackTrace();
            context.getLogger().log(String.format(
                "Error getting object %s from bucket %s. Make sure they exist and"
                + " your bucket is in the same region as this function.", key, bucket));
            throw e;
        }
    }
}