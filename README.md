Azure Blob Storage - Find Blobs that have a particular Access Tier
==================================================================

            

I created this script to be able to search large Azure blob storage containers for blobs that had a 'Hot' access tier. The variable within the script can be edited to search for Blobs with Hot, Cold or Archive access tiers. I've included the use of the Continuation
 Token within the Get-AzureStorageBlob, which is helpful for searching large storage containers. Without this, I found that the shell script would hang or fail on these big datasets.


Any feedback, positive or negative, would be greatly appreciated.


 


 

 

 


        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
