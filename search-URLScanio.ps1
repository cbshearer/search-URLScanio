## URLScanIO
## Chris Shearer
## 8.21.2019
## URLScan.io API docs: https://urlscan.io/about-api/

## Accept CLI parameters
    param ($u)

## Create an account on https://urlscan.io/user/signup
    $URLScanIOapikey = "xxxxxxxx"

## Assign variables if they were entered from the CLI
    if ($u){$urllist = @($u)}
    
## If variable wasn't passed from the CLI, then see if they were entered into script directly or pulled from a list
    else {
        ## Enter your array of sites to scan here
            $URLList = @("microsoft.com",
                         "google.com",
                         "facebook.com",
                         "amazon.com")

        ## Alternatively, you can pull many sites from a file
            #$URLList = Get-Content "E:\temp\THREAT_LIST.txt"
    }

## Set TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

foreach ($url in $URLList)
    {   
        ## Submit
            Write-Host "======================="
            Write-Host "Submitting: " -nonewline; Write-Host -f Cyan $url
            $Invoke = Invoke-WebRequest -Headers @{"API-Key" = "$URLScanIOapikey"} -Method Post ` -Body "{`"url`":`"$url`"}" -Uri https://urlscan.io/api/v1/scan/ ` -ContentType application/json
            $Content = $invoke.Content | ConvertFrom-Json
        
        ## Results
            $ioResult     = $null     ## Null out the variable
            $URLScanIOURI = "https://urlscan.io/api/v1/result/" + $content.uuid + '/'
            Write-Host $URLScanIOURI
        
        ## Check every 10 seconds to see if the results are ready. 
            do  {
                    Start-Sleep 10
                    Write-Host "     ZZZzzz..." 
                    try { $ioResult = Invoke-WebRequest -Uri $URLScanIOURI -Method Get -ContentType application/json -ErrorAction SilentlyContinue
                          $ioResult = $ioResult | ConvertFrom-Json }
                    catch {}
                }
            while ((!($ioResult)) -or ($ioresult.message -eq 'notdone') -or ($ioresult.message -like 'not found'))

        ## Display score with red if over 80, else green
            if ($ioResult.verdicts.overall.score -ge 80)  
                {Write-Host "Score (0-100) : " -nonewline; Write-Host -f Red   $ioResult.verdicts.overall.score}
            else                                        
                {Write-Host "Score (0-100) : " -nonewline; Write-Host -f green $ioResult.verdicts.overall.score}
        
        ## Display verdict in red if malicious, else green
            if ($ioResult.verdicts.overall.malicious -like 'TRUE')
                {Write-Host "Is malicious? : " -nonewline; Write-Host -f Red   $ioResult.verdicts.overall.malicious}
            else 
                {Write-Host "Is malicious? : " -nonewline; Write-Host -f Green $ioResult.verdicts.overall.malicious}
        
        ## Display categories first overall, secondary urlscan, tertiary engines
            if      ($ioResult.verdicts.overall.categories)            {Write-Host "Category     : " -nonewline; Write-Host -f magenta $ioResult.verdicts.overall.categories}
            elseif  ($ioResult.verdicts.URLScan.verdicts.categories)   {Write-Host "Category     : " -nonewline; Write-Host -f magenta $ioResult.verdicts.URLScan.categories}
            elseif  ($ioResult.verdicts.engines.verdicts.categories)   {Write-Host "Category     : " -nonewline; Write-Host -f magenta $ioResult.verdicts.engines.verdicts.categories}
            else    {Write-Host "Category     : " -nonewline; Write-Host -f Cyan "unknown"}
    }
