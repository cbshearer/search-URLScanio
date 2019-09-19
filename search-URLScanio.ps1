## URLScanIO
## Chris Shearer
## 8.21.2019
## URLScan.io API docs: https://urlscan.io/about-api/

$CredFile        = import-csv 'E:\scripts\powershell\submit-URLScanIO\credentials.csv'
$URLScanIOapikey = $CredFile | Where-Object -Property Type -eq 'URLScanIOapiKey'
$URLScanIOapikey = $URLScanIOapikey.data

## Enter your array of sites to scan here
    $URLList = @()
    $URLList += "resources-bobscottsinsights.com/"
    $URLList += "google.com"
    $URLList += "facebook.com"
    $URLList += "amazon.com"

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
                    try { $ioResult = Invoke-WebRequest -Uri $URLScanIOURI -Method Get -ContentType application/json -ErrorAction SilentlyContinue }
                    catch {}
                }
            while (!($ioResult))

            $ioResult = $ioResult | ConvertFrom-Json

        ## Display score with red if over 80, else green
            if ($ioResult.verdicts.overall.score -ge 80)  
                {Write-Host "Score (1-100) : " -nonewline; Write-Host -f Red   $ioResult.verdicts.overall.score}
            else                                        
                {Write-Host "Score (1-100) : " -nonewline; Write-Host -f green $ioResult.verdicts.overall.score}
        
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
