#################################
# Region: North America
#################################

# Set the source and destination folder paths
$sourceFolder = ".\North America\Aftermarket Releases"
$destinationFolder = ".\North America\Previous Revisions"

# Get all the files in the source folder
$files = Get-ChildItem -Path $sourceFolder

# Create a hashtable to store the highest revision or version for each filename along with its extension
$highestRevisions = @{}

# Loop through each file in the source folder
foreach ($file in $files) {
    $filename = $file.BaseName  # Get the file name without extension

    $currentRevision = 0  # Default revision or version number
    $isVersion = $false   # Track if it's a version number

    # Check if the filename matches the pattern ' (Rev #)' and extract the revision number
    if ($filename -match ' \(Rev (\d+)\)') {
        $currentRevision = [int]$Matches[1]  # Convert the revision number to an integer
        $filename = $filename -replace ' \(Rev (\d+)\)', ''  # Remove the revision from the filename
    }
    # Check if the filename matches the pattern ' (v#.#)' and extract the version number
    elseif ($filename -match ' \(v(\d+\.\d+)\)') {
        $currentRevision = [decimal]$Matches[1]  # Convert the version number to a decimal
        $filename = $filename -replace ' \(v(\d+\.\d+)\)', ''  # Remove the version from the filename
        $isVersion = $true  # Mark as version
    }

    $extension = $file.Extension  # Get the file extension

    # Check if the current file has a higher revision or version than the stored highest for the filename
    if (-not $highestRevisions.ContainsKey("$filename$extension") -or $currentRevision -gt $highestRevisions["$filename$extension"]["Revision"]) {
        $highestRevisions["$filename$extension"] = @{
            "Filename" = $filename
            "Revision" = $currentRevision
            "IsVersion" = $isVersion
            "Extension" = $extension
        }
    }
}

# Remove duplicate entries with lower revisions or versions from the $highestRevisions hashtable
$uniqueRevisions = @{}
foreach ($fileData in $highestRevisions.Values) {
    $filename = $fileData["Filename"]
    $revision = $fileData["Revision"]
    $extension = $fileData["Extension"]

    if ($uniqueRevisions.ContainsKey("$filename$extension")) {
        $existingRevision = $uniqueRevisions["$filename$extension"]["Revision"]
        if ($revision -gt $existingRevision) {
            $uniqueRevisions["$filename$extension"] = @{
                "Filename" = $filename
                "Revision" = $revision
                "Extension" = $extension
            }
        }
    }
    else {
        $uniqueRevisions["$filename$extension"] = @{
            "Filename" = $filename
            "Revision" = $revision
            "Extension" = $extension
        }
    }
}

# Create a new hashtable to store the filenames generated in step 9
$generatedFilenames = @{}

# Display the reassembled filenames and highest revisions, and add them to the new hashtable
foreach ($fileData in $uniqueRevisions.Values) {
    $filename = $fileData["Filename"]
    $revision = $fileData["Revision"]
    $isVersion = $fileData["IsVersion"]
    $extension = $fileData["Extension"]

    if ($revision -eq 0) {
        $reassembledFilename = "$filename$extension"
    }
    elseif ($isVersion) {
        $reassembledFilename = "$filename (v$revision)$extension"
    }
    else {
        $reassembledFilename = "$filename (Rev $revision)$extension"
    }

    Write-Host "Filename: $reassembledFilename, Highest Revision/Version: $revision"

    # Add the generated filename to the hashtable
    $generatedFilenames["$filename$extension"] = $reassembledFilename
}

# Move files not found in the $generatedFilenames hashtable to the destination folder
foreach ($file in $files) {
    $filename = $file.Name
    if (-not $generatedFilenames.ContainsKey($filename)) {
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $filename
        Move-Item -Path $file.FullName -Destination $destinationPath
        Write-Host "Moved file '$filename' to '$destinationPath'"
    }
}

Write-Host "North American Revisions Parsed."