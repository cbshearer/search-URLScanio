# search-URLScanio

- Use PowerShell to submit an array of URLS to urlscan.io.
- Parse and display some of the results once the scan is complete.
- API documentation: https://urlscan.io/about-api/

## To use this module

- Import the module

```PowerShell
PS C:\temp> Import-Module .\search-URLScanio
```

- Change parameters on line 15
  - Create an account on https://urlscan.io/user/signup
  - Sign in and add / show an API key
  - Enter your API key on line 15 as the variable $URLScanIOapikey

- Mandatory parameter:
  - -u: URL
- Example:

```PowerShell
search-URLScanio -u https://example.com/super/fun
search-URLScanio longjohngrays.top/o365.html,http://orangelobster.biz/super/duper/sekret.php
```

## The following information is returned on the screen

- URL Being submitted
- Result URL: URLScan.io web page with results
- "ZZZzzz..." every 10 seconds indicate we are waiting for the scan to complete and return results.
- Scan link: HTML page with results
- Score: from 0-100 - higher is worse, if score is over 80, result is displayed in red.
- Is Malicious?: True/False verdict
- Category: category as determined by overall, URLScan or other engines.
