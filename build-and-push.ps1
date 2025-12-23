# =========================
# CONFIG
# =========================
$dockerUsername = "rutwik31"
$imageName = "python-app"

# Dynamic tag (commit SHA or timestamp)
if ($env:GITHUB_SHA) {
    $tag = $env:GITHUB_SHA.Substring(0,7)
} else {
    $tag = (Get-Date -Format "yyyyMMddHHmmss")
}

$imageTagged = "${dockerUsername}/${imageName}:${tag}"
$imageLatest = "${dockerUsername}/${imageName}:latest"

# =========================
# DEBUG INFO
# =========================
Write-Host "==============================="
Write-Host "Docker Build & Push Script"
Write-Host "Repository: $dockerUsername/$imageName"
Write-Host "Versioned tag: $imageTagged"
Write-Host "Latest tag: $imageLatest"
Write-Host "Listing current directory contents:"
Get-ChildItem
Write-Host "==============================="

# =========================
# BUILD IMAGE
# =========================
Write-Host "Building Docker image from existing Dockerfile in current directory..."
docker build -t $imageTagged .

if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker build failed. Make sure Dockerfile exists in the current directory."
    exit 1
}

# =========================
# TAG AS LATEST
# =========================
docker tag $imageTagged $imageLatest

# =========================
# PUSH TO DOCKER HUB
# =========================
Write-Host "Pushing Docker images to Docker Hub..."
docker push $imageTagged
docker push $imageLatest

Write-Host "==============================="
Write-Host "Docker image push completed!"
Write-Host "Versioned image: $imageTagged"
Write-Host "Latest image: $imageLatest"
Write-Host "Docker Hub URL: https://hub.docker.com/r/$dockerUsername/$imageName"
Write-Host "==============================="
