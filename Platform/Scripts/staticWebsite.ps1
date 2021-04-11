# Enable Static Website setting for Production Storage Account
az storage blob service-properties update --account-name sairishtechieblogprod --static-website --404-document 404.html --index-document index.html

# Enable Static Website setting for Staging Storage Account
az storage blob service-properties update --account-name sairishtechieblogstage --static-website --404-document 404.html --index-document index.html