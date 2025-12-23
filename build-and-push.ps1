# =========================
# CONFIG
# =========================
$dockerUsername = "rutwik31"

# Docker Hub API URL for public repositories
$apiUrl = "https://hub.docker.com/v2/repositories/$dockerUsername/?page_size=100"

Write-Host "Fetching public Docker Hub repositories for user: $dockerUsername ..."

# Call Docker Hub API
$response = Invoke-RestMethod -Uri $apiUrl -Method Get

# Check if results exist
if ($response.results.Count -eq 0) {
    Write-Host "No public repositories found for $dockerUsername"
    exit
}

# List repository names
Write-Host "Public Docker Hub repositories:"
foreach ($repo in $response.results) {
    Write-Host "- " $repo.name
}
