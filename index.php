<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$scriptPath = '/RaspController/monitoring_v12.py';
$cacheFile = 'cache.xml';
$cacheTime = 5; // Cache duration in seconds

function runPythonScript($scriptPath) {
    $output = shell_exec("python3 " . escapeshellarg($scriptPath));
    return $output !== null ? $output : "";
}

function parseOutputToXml($output) {
    $lines = explode(PHP_EOL, trim($output));
    $xml = '<Monitoring>';
    $mounts = '';
    $inMount = false;

    foreach ($lines as $line) {
        if (strpos($line, '=') !== false) {
            list($tag, $value) = explode('=', $line, 2);
            $tag = trim($tag);
            $value = trim($value);

            // Handle FS start
            if ($tag === 'FS' && $value === '[') {
                continue;
            }

            // Handle FS end (closing all mounts)
            if ($tag === 'FS' && $value === ']') {
                if ($inMount) {
                    $mounts .= '</Mount>';
                    $inMount = false;
                }
                continue;
            }

            // Handle Mount separator (`,`)
            if ($tag === ',' && $inMount) {
                $mounts .= '</Mount><Mount>';
                continue;
            }

            // Parse numerical values with units
            if (preg_match('/([0-9.]+)\s*([a-zA-Z%]*)/', $value, $matches)) {
                $element = "<$tag><Value>{$matches[1]}</Value>";
                if (!empty($matches[2])) {
                    $element .= "<Unit>{$matches[2]}</Unit>";
                }
                $element .= "</$tag>";
            } else {
                $element = "<$tag>" . htmlspecialchars($value) . "</$tag>";
            }

            // Handle mount points correctly
            if ($tag === 'Mountpoint') {
                // If we were already in a mount, close the previous one
                if ($inMount) {
                    $mounts .= '</Mount>';
                }

                // Start a new mount
                $mounts .= "<Mount><Mountpoint>" . htmlspecialchars($value) . "</Mountpoint>";

                $inMount = true;
            } elseif ($inMount) {
                $mounts .= $element; // Add other elements (e.g., DiskTotal, DiskUsed, etc.)
            } else {
                $xml .= $element;
            }
        }
    }

    // Close the last open mount tag if needed
    if ($inMount) {
        $mounts .= '</Mount>';
    }

    // Add mounts to the XML
    if (!empty($mounts)) {
        $xml .= "<Mounts>$mounts</Mounts>";
    }

    $xml .= '<LastUpdated>' . date('c') . '</LastUpdated>';
    $xml .= '</Monitoring>';
    return $xml;
}

// Check if cache file exists and is still valid
if (file_exists($cacheFile) && (time() - filemtime($cacheFile)) < $cacheTime) {
    $xmlOutput = file_get_contents($cacheFile);
} else {
    $output = runPythonScript($scriptPath);
    if ($output === "") {
        $xmlOutput = "<Error>Failed to get stats, ensure you have retrieved stats before using https://www.egalnetsoftwares.com/apps/raspcontroller</Error>";
    } else {
        $xmlOutput = parseOutputToXml($output);
        file_put_contents($cacheFile, $xmlOutput);
    }
}

// Output as text if requested
if (isset($_GET['text'])) {
    header('Content-Type: text/plain');
    echo $output;
    exit();
}

// Output as XML
header('Content-Type: application/xml');
echo '<?xml version="1.0" encoding="UTF-8"?>';
if (!isset($_GET['xml'])) {
    echo '<?xml-stylesheet type="text/xsl" href="transform.xslt"?>';
}
echo $xmlOutput;
?>
