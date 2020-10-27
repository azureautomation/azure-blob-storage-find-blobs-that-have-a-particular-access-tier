Import-Module Azure

#Define storage account information
$StorageAccount = "storage1"
$StorageAccountKey = "#####################################################"
$containername = "container1"
 
#Create a storage context
$context = New-AzureStorageContext -StorageAccountName $StorageAccount -StorageAccountKey $StorageAccountKey

#Set variables for processing batches & continuation token
$MaxReturn = 100000
$Token = $Null

#Define blog array for reporting
$blobarray = @()

#Set Blob Access Tier
$accesstier = 'Hot'

#Create a loop to process the whole container in blob batches of 100,000

do
 {
     #Process a total of 100,000 Blobs at a time. This is extremely useful for large containers
     $blobs = Get-AzureStorageBlob -Container $containername -Context $context -MaxCount $MaxReturn -ContinuationToken $Token

     #Filter out only blobs that have an access tier of $accesstier. $sblobs is short for select blobs!
     
     $sblobs = $blobs | Where-Object {$_.ICloudBlob.Properties.StandardBlobTier -eq $accesstier}

     #Add these filtered sblobs to our array
     foreach($sblob in $sblobs) {

        #Add select blobs to array
        $blobarray += $sblob

                }  
     
     if($Blobs.Length -le 0) { Break;}

     $Token = $blobs[$blobs.Count -1].ContinuationToken;
 }
 While ($Token -ne $Null)

#Export results of uploaded blogs to CSV file

$timestamp = get-date -UFormat %d%m%y%H%M

$export = "C:\temp\$containername Tier_Status $timestamp.csv"

$blobarray | Select-Object -Property Name, BlobType, LastModified, Length, @{n='AccessTier';e={$_.ICloudBlob.Properties.StandardBlobTier}} | Export-Csv $export -NoTypeInformation

#Email CSV file to pre-determined recipients

Start-Sleep -s 5

$fulldate = Get-Date -Format g
$smtpServer ="8.8.8.8"
$file = $export
$att = new-object Net.Mail.Attachment($file)
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = "sender@test.com"
$msg.To.Add("recipient@test.com")
$msg.Subject = "$timestamp : Get Blob Storage Tier - $containername "
$msg.Body = "Blob Storage Tier status - Report attached for $containername on $fulldate"
$msg.Attachments.Add($att)
$smtp.Send($msg)
$att.Dispose()