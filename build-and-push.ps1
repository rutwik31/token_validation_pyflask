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

# FIX: use ${} to avoid colon parsing issue
$imageTagged = "${dockerUsername}/${imageName}:${tag}"
$imageLatest = "${dockerUsername}/${imageName}:latest"

Write-Host "Building Docker image from current directory..."

# =========================
# BUILD (uses existing Dockerfile)
# =========================
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
docker push $imageTagged
docker push $imageLatest

Write-Host "Docker image pushed successfully"
Write-Host $imageTagged
Write-Host $imageLatest
