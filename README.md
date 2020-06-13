# search-URLScanio
- Use PowerShell to submit an array of URLS to urlscan.io.
- Parse and display some of the results once the scan is complete.
- API documentation: https://urlscan.io/about-api/

## To use this script:
- Line 7: API Key
  - Create an account on https://urlscan.io/user/signup
  - Sign in and Add / show an API key
  - Enter your API key on line 7 as the variable $URLScanIOapikey
- Line 9: URLs should be loaded into the array, replacing the samples
- Line 16: If it is easier, you can uncomment line 16 and enter the path to a file of URLs you would like to scan; 1 URL per line in the file. (Sample file: https://github.com/cbshearer/search-URLScanio/blob/master/THREAT_LIST.txt) 

## The following information is returned on the screen: 
- URL Being submitted
- URI endpoint: JSON of result
- Scan link: HTML page with results
- Score: from 0-100 - if score is over 80, result is displayed in red.
- Is Malicious?: True/False verdict
- Category: category as determined by overall, URLScan or other engines.
