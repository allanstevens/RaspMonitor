<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" />
    <xsl:template match="/">
        <html>
            <head>
                <title>CPU, RAM, Storage and Network Monitoring</title>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        margin: 20px auto;
                        background: #f9f9f9;
                        color: #333;
                        max-width: 1000px;
                    }
                    h1 {
                        margin: 10px 0;
                    }
                    a {
                        color: #333;
                        text-decoration:none;
                        font-weight: bold;
                    }
                    a:hover {
                        text-decoration: underline;
                    }
                    table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 20px;                        
                        border-radius: 10px;
                        box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.1), 0 6px 20px 0 rgba(0, 0, 0, 0.1);
                    }                    
                    th, td {
                        border: 1px solid #ccc;
                        padding: 8px;
                        text-align: left;
                    }
                    th {
                        background-color: #f2f2f2;
                    }
                    tr:nth-child(even) {
                        background-color: #f9f9f9;
                    }
                    .error {
                        color: red;
                        font-weight: bold;
                    }
                    .last-updated {
                        margin: 10px 0;
                        font-size: 0.9em;
                        color: #666;
                    }
                </style>
            </head>
            <body>
                <h1><a href='#cpu'>CPU</a>, <a href='#ram'>RAM</a>, <a href='#storage'>Storage</a> and <a href='#network'>Network</a> Monitoring</h1>
                <div class="last-updated">
                    <xsl:text>Last Updated: </xsl:text>
                    <xsl:value-of select="Monitoring/LastUpdated" />
                </div>
                <xsl:choose>
                    <xsl:when test="Monitoring/Error">
                        <div class="error">
                            <xsl:value-of select="Monitoring/Error" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>

                        <!-- CPU Section -->
                        <h2><a name="cpu">CPU</a></h2>
                        <table>
                            <xsl:apply-templates select="Monitoring/CpuUsage | Monitoring/CpuFreqCurrent | Monitoring/CpuFreqMin | Monitoring/CpuFreqMax | Monitoring/CpuTemp | Monitoring/CpuCount" />
                        </table>

                        <!-- RAM Section -->
                        <h2><a name="ram">RAM</a></h2>
                        <table>
                            <xsl:apply-templates select="Monitoring/RamTotal | Monitoring/RamUsed | Monitoring/RamFree | Monitoring/RamAvailable | Monitoring/RamPercent" />
                        </table>

                        <!-- Mounts Section -->
                        <h2><a name="storage">STORAGE</a></h2>
                        <table>
                            <tr>
                                <th>Mountpoint</th>
                                <th>Total</th>
                                <th>Used</th>
                                <th>Free</th>
                                <th>Percent</th>
                            </tr>
                            <xsl:apply-templates select="Monitoring/Mounts/Mount" />
                        </table>

                       
                        <!-- Network Section -->
                        <h2><a name="network">DOWNLOAD</a></h2>
                        <table>
                            <xsl:apply-templates select="Monitoring/DownloadSpeed | Monitoring/BytesRecv | Monitoring/PacketsRecv |  Monitoring/NetErrorIn" />
                        </table>


                       
                        <!-- Network Section -->
                        <h2><a name="network">UPLOAD</a></h2>
                        <table>
                            <xsl:apply-templates select="Monitoring/UploadSpeed | Monitoring/BytesSent | Monitoring/PacketsSent | Monitoring/NetErrorOut" />
                        </table>


                    </xsl:otherwise>
                </xsl:choose>
                <p>View <a href="?xml">XML</a> or <a href="?text">plain text</a></p>    
                <p><a href="https://github.com/allanstevens/RaspMonitor">https://github.com/allanstevens/RaspMonitor</a></p>                
                <p><small>Stats provided by <a href='https://www.egalnetsoftwares.com/apps/raspcontroller/' target="_blank">RASPCONTROLLER</a> python script, please consider buying a license</small></p> 
            </body>
        </html>
    </xsl:template>
    <xsl:template match="Monitoring/*">
        <tr>
            <td>
                <!-- Match the metric name directly from the variable -->
                <xsl:choose>
                    <!-- CPU -->
                    <xsl:when test="name() = 'CpuUsage'">Usage</xsl:when>
                    <xsl:when test="name() = 'CpuTemp'">Temperature</xsl:when>
                    <xsl:when test="name() = 'CpuCount'">Core count</xsl:when>
                    <xsl:when test="name() = 'CpuFreqCurrent'">Current frequency</xsl:when>
                    <xsl:when test="name() = 'CpuFreqMin'">Minimum frequency</xsl:when>
                    <xsl:when test="name() = 'CpuFreqMax'">Maximum frequency</xsl:when>
                    <!-- RAM -->
                    <xsl:when test="name() = 'RamTotal'">Total</xsl:when>
                    <xsl:when test="name() = 'RamUsed'">Used</xsl:when>
                    <xsl:when test="name() = 'RamFree'">Free</xsl:when>
                    <xsl:when test="name() = 'RamAvailable'">Available</xsl:when>
                    <xsl:when test="name() = 'RamPercent'">Usage</xsl:when>
                    <!-- Network -->
                    <xsl:when test="name() = 'DownloadSpeed'">Speed</xsl:when>
                    <xsl:when test="name() = 'UploadSpeed'">Speed</xsl:when>
                    <xsl:when test="name() = 'BytesRecv'">RX Bytes</xsl:when>
                    <xsl:when test="name() = 'BytesSent'">TX Bytes</xsl:when>
                    <xsl:when test="name() = 'PacketsRecv'">RX Packets</xsl:when>
                    <xsl:when test="name() = 'PacketsSent'">TX Packets</xsl:when>
                    <xsl:when test="name() = 'NetErrorIn'">Incomming errors</xsl:when>
                    <xsl:when test="name() = 'NetErrorOut'">Outgoing errors</xsl:when>
                    <!-- Storage -->
                    <xsl:when test="name() = 'DiskTotal'">Total</xsl:when>
                    <xsl:when test="name() = 'DiskUsed'">Used</xsl:when>
                    <xsl:when test="name() = 'DiskFree'">Free</xsl:when>
                    <xsl:when test="name() = 'DiskPercent'">Usage</xsl:when>
                    <xsl:otherwise><xsl:value-of select="name()" /></xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:value-of select="Value" />
                <xsl:if test="Unit">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="Unit" />
                </xsl:if>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="Mount">
        <tr>
            <td><xsl:value-of select="Mountpoint" /></td>
            <td><xsl:value-of select="DiskTotal/Value" /> <xsl:value-of select="DiskTotal/Unit" /></td>
            <td><xsl:value-of select="DiskUsed/Value" /> <xsl:value-of select="DiskUsed/Unit" /></td>
            <td><xsl:value-of select="DiskFree/Value" /> <xsl:value-of select="DiskFree/Unit" /></td>
            <td><xsl:value-of select="DiskPercent/Value" /> <xsl:value-of select="DiskPercent/Unit" /></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
