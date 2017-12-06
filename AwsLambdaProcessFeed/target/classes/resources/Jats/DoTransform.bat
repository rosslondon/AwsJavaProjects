@echo off

RaptorXML xslt --xslt-version=1 --input="C:\GitHub\Personal\AwsJavaProjects\AWSLambdaProcessFeedXml\src\main\resources\Jats\SDY_v4_i4_043802_1.xml" --output="C:\Test\Fairburn\DataCapture\AipJats.xml" --xml-validation-error-as-warning=true %* "MappingMapToinspec-content.xslt"
IF ERRORLEVEL 1 EXIT/B %ERRORLEVEL%
