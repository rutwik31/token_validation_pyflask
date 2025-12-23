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

# Full image names
$imageTagged = "${dockerUsername}/${imageName}:${tag}"
$imageLatest = "${dockerUsername}/${imageName}:latest"

# =========================
# INFORM USER
# =========================
Write-Host "==============================="
Write-Host "Docker Build & Push Script"
Write-Host "Repository: $dockerUsername/$imageName"
Write-Host "Versioned tag: $imageTagged"
Write-Host "Latest tag: $imageLatest"
Write-Host "==============================="

# =========================
# BUILD (uses existing Dockerfile)
# =========================
Write-Host "Building Docker image from current directory..."
docker build -t $imageTagged .

if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker build failed"
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
Write-Host "Repository: $dockerUsername/$imageName"
Write-Host "Versioned image: $imageTagged"
Write-Host "Latest image: $imageLatest"
Write-Host "You can find your images at: https://hub.docker.com/r/$dockerUsername/$imageName"
Write-Host "==============================="
